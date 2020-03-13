import Foundation
import FluentPostgreSQL

final class BlogCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot {
    
    // DEVSCORCH: Category Pivot
    
    var id: UUID?
    var blogID: BlogPostModel.ID
    var blogCategoryID: BlogCategoryModel.ID
    
    typealias Left = BlogPostModel
    typealias Right = BlogCategoryModel
    
    static let leftIDKey: LeftIDKey = \.blogID
    static let rightIDKey: RightIDKey = \.blogCategoryID
    
    init(_ blogPostModel: BlogPostModel, _ category: BlogCategoryModel) throws {
        self.blogID = try blogPostModel.requireID()
        self.blogCategoryID = try category.requireID()
    }
}

extension BlogCategoryPivot: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.blogID, to: \BlogPostModel.id, onDelete: .cascade)
            builder.reference(from: \.blogCategoryID, to: \BlogCategoryModel.id, onDelete: .cascade)
        }
    }
}
