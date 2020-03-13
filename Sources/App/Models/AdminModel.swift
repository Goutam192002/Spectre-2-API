import Vapor
import FluentPostgreSQL
import Foundation
import Authentication

final class Admin: Codable {
    
    // DEVSCORCH: Personal Variabels
    
    var id: UUID?
    var name: String
    var lastname: String
    var email: String
    var adminPhoto: String?
    var adminDescription: String?
    var teachedCourses: [String]?
    
    
    // DEVSCORCH: Authentication Variables
    
    var username: String
    var password: String
    
    // DEVSCORCH: Social variables
    
    var adminFacebook: String?
    var adminGithub: String?
    var adminInstagram: String?
    
    // DEVSCORCH: Initialiser
    
    init(name: String, lastname: String, email: String, username: String, password: String) {
        
        // DEVSCORCH: Personal Variable Initialiser
        
        self.name = name
        self.lastname = lastname
        self.email = email
        
        // DEVSCORCH: Authentication Initialiser
        
        self.username = username
        self.password = password
     
    }
    
    final class Public: Codable {
        
        // DEVSCORCH: Public Personal Variables
        
        var id: UUID?
        var name: String
        var lastname: String
        
        // DEVSCORCH Public Authentication Variabels
        
        var username: String
        
        // DEVSCORCH: Public Social Variables
        
        var adminFacebook: String?
        var adminGithub: String?
        var adminInstagram: String?
        
        init(id: UUID, name: String, lastname: String, username: String) {
            self.id = id
            self.name = name
            self.lastname = lastname
            self.username = username
        }
    }
}

extension Admin: PostgreSQLUUIDModel {}
extension Admin: Content {}

extension Admin: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) {
            builder in
            try addProperties(to: builder)
            builder.unique(on: \.username)
            builder.unique(on: \.email)
        }
    }
}

extension Admin: Parameter {}
extension Admin.Public: Content {}

extension Admin {
    func converToPublic() -> Admin.Public {
        return Admin.Public(id: id!, name: name, lastname: lastname, username: username)
    }
}

extension Future where T: Admin {
    func convertToPublic() -> Future<Admin.Public> {
        return self.map(to: Admin.Public.self) { admin in
            return admin.converToPublic()
        }
    }
}

extension Admin: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \Admin.username
    static let passwordKey: PasswordKey = \Admin.password
}

extension Admin: TokenAuthenticatable {
    typealias TokenType = AdminToken
}

extension Admin: PasswordAuthenticatable {}
extension Admin: SessionAuthenticatable {}

