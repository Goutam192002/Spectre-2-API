import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

final class AdminToken: Codable {

    // DEVSCORCH: Token Variabels

    var id: UUID?
    var token: String
    var adminID: Admin.ID
    
    // DEVSCORCH: Token Variable Initialiser

    init(token: String, adminID: Admin.ID) {
        
        self.token = token
        self.adminID = adminID
    }
}

extension AdminToken: PostgreSQLUUIDModel {}

extension AdminToken: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.adminID, to: \Admin.id)
        }
    }
}

extension AdminToken {
    static func generate(for admin: Admin) throws -> AdminToken {
        let random = try CryptoRandom().generateData(count: 16)
        return try AdminToken(token: random.base64EncodedString(), adminID: admin.requireID())
    }
}

extension AdminToken: Content {}

extension AdminToken: Authentication.Token {
    static let userIDKey: UserIDKey = \AdminToken.adminID
    typealias UserType = Admin
}

extension AdminToken: BearerAuthenticatable {
    static let tokenKey: TokenKey = \AdminToken.token
}
