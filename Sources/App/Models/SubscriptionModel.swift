import Vapor
import FluentPostgreSQL

final class Subscription: Codable {
    
    // DEVSCORCH: Subscription variabels
    
    var id: Int?
    var subscriptionName: String
    var tierOne: String
    var tierTwo: String?
    var tierThree: String?
    var tierFour: String?
    var tierFive: String?
    var tierSix: String?
    var tierSeven: String?
    var subscriptionPrice: Int
    var subscriptionUrl: String
    
    // DEVSCORCH: Subscription Initialiser
    
    init(subscriptionName: String, tierOne: String, tierTwo: String, tierThree: String, tierFour: String, tierFive: String, tierSix: String, tierSeven: String, subscriptionPrice: Int, subscriptionUrl: String) {
        self.subscriptionName = subscriptionName
        self.tierOne = tierOne
        self.tierTwo = tierTwo
        self.tierThree = tierThree
        self.tierFour = tierFour
        self.tierFive = tierFive
        self.tierSix = tierSix
        self.tierSeven = tierSeven
        self.subscriptionPrice = subscriptionPrice
        self.subscriptionUrl = subscriptionUrl
    }
}

extension Subscription: PostgreSQLModel {}
extension Subscription: Content {}
extension Subscription: Migration {}
extension Subscription: Parameter {}
