import Foundation
import Vapor
import FluentPostgreSQL

final class BlogPostModel: Codable {
    
    // DEVSCORCH: Blog variables
    
    var id: UUID?
    var blogTitle: String
    var publicationDate: String
    var writer: String
    var tags: Array<String>
    var publication: String
    
    // DEVSCORCH: Blog intro variables
    
    var category: String
    var introImage: String
    
    init(blogTitle: String, publicationDate: String, writer: String, tags: Array<String>, publication: String, category: String, introImage: String) {
        self.blogTitle = blogTitle
        self.publication = publicationDate
        self.writer = writer
        self.tags = tags
        self.category = category
        self.introImage = introImage
        self.publicationDate = publicationDate
    }
    
}

extension BlogPostModel: PostgreSQLUUIDModel {
    
}

extension BlogPostModel: Migration {
    var categories: Siblings<BlogPostModel, BlogCategoryModel, BlogCategoryPivot> {
        return siblings()
    }
    
}

extension BlogPostModel: Content {}

extension BlogPostModel: Parameter {}
