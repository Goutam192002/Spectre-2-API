import Vapor
import Foundation
import FluentPostgreSQL
import Authentication

final class User: Codable {
    
    // DEVSCORCH: Personal Variabels
    
    var id: UUID?
    var name: String?
    var lastName: String?
    var dateOfBirth: String?
    var userImage: String?
    var email: String?
    var userDescription: String?
    var specialty: [String]?
    var stripe_session_id: String?

    // DEVSCORCH: Authentication Variables
    
    var username: String
    var password: String

    // DEVSCORCH: Course Variabels
    
    var videoWatched: [String]?
    var coursesFollowed: [String]?
    var sectionFinished: [String]?
    
    // DEVSCORCH: Subscription Variabels
    
    var stripeID: String?
    var subscription: String?
    var subscriptionIsActive: Bool? = false
    var dateJoined: Date?
    
    
    // DEVSCORCH: Initialiser
    
    init(name: String?, lastName: String?, dateOfBirth: String?, userImage: String? = nil, email: String?, userDescription: String?, specialty: [String]?, username: String, password: String, videoWatched: [String]?, coursesFollowed: [String]?, stripeID: String?, subscription: String?, subscriptionIsActive: Bool?, dateJoined: Date?, stripe_session_id: String, sectionFinished: [String]) {
        
        // DEVSCORCH: Personal Variabels Initialisers
        
        self.name = name
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.userImage = userImage
        self.email = email!
        self.userDescription = userDescription
        self.specialty = specialty
        
        // DEVSCORCH: Authentication Variables Initialisers
        
        self.username = username
        self.password = password
        
        // DEVSCORCH: Course Variables Initialisers
        
        self.videoWatched = videoWatched
        self.coursesFollowed = coursesFollowed
        self.sectionFinished = sectionFinished
        
        // DEVSCORCH: Subscription Variables Initialisers
        
        self.stripeID = stripeID
        self.subscription = subscription
        self.subscriptionIsActive = subscriptionIsActive
        self.dateJoined = dateJoined
        self.stripe_session_id = stripe_session_id
    }
    
    final class Public: Codable {
        
        // DEVSCORCH: Public Variables
        
        var id: UUID?
        var username: String
        var userdescription: String?
        var specialty: [String]?
        var userImage: String?
        var stripeID: String?
        var subscriptionIsActive: Bool?
        
        init(id: UUID, username: String, userDescription: String, specialty: [String], userImage: String, stripeID: String, subscriptionIsActive: Bool) {
            self.id = id
            self.username = username
            self.userdescription = userDescription
            self.specialty = specialty
            self.userImage = userImage
            self.stripeID = stripeID
            self.subscriptionIsActive = subscriptionIsActive
        }
    }
    
}

extension User: PostgreSQLUUIDModel {}
extension User: Content {}

extension User: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) {
            builder in
            try addProperties(to: builder)
            builder.unique(on: \.username)
            builder.unique(on: \.email)
        }
    }
}

extension User: Parameter {}
extension User.Public: Content {}

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: id!, username: username, userDescription: userDescription!, specialty: specialty!, userImage: userImage!, stripeID: stripeID!, subscriptionIsActive: subscriptionIsActive!)
    }
}

extension Future where T: User {
    func converttoPublic() -> Future<User.Public> {
        return self.map(to: User.Public.self) { user in
            return user.convertToPublic()
        }
    }
}

extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.username
    static let passwordKey: PasswordKey = \User.password
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}

extension User: PasswordAuthenticatable {}
extension User: SessionAuthenticatable {}
