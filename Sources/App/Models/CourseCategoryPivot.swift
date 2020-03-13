import FluentPostgreSQL
import Foundation

final class CourseCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot {
    
    // DEVSCORCH: Category Pivor
    
    var id: UUID?
    var courseID: Courses.ID
    var categoryID: CourseCategory.ID
    
    typealias Left = Courses
    typealias Right = CourseCategory
    
    static let leftIDKey: LeftIDKey = \.courseID
    static let rightIDKey: RightIDKey = \.categoryID
    
    // DEVSCORCH: Category Pivor Initialiser
    
    init(_ courses: Courses, _ category: CourseCategory) throws {
        self.courseID = try courses.requireID()
        self.categoryID = try category.requireID()
    }
}

extension CourseCategoryPivot: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.courseID, to: \Courses.id, onDelete: .cascade)
            builder.reference(from: \.categoryID, to: \CourseCategory.id, onDelete: .cascade)
        }
    }
}


