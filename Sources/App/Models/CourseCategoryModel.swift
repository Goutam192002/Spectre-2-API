import Vapor
import FluentPostgreSQL

struct CourseCategory: Codable {
    
    // DEVSCORCH: Course Variable
    
    var id: Int?
    var name: String
    
    // DEVSCORCH: Course initialiser
    
    init(name: String) {
        self.name = name
    }
}

extension CourseCategory: PostgreSQLModel {}
extension CourseCategory: Content {}
extension CourseCategory: Migration {}
extension CourseCategory: Parameter {}

extension CourseCategory {
    var courses: Siblings<CourseCategory, Courses, CourseCategoryPivot> {
        return siblings()
}
}
