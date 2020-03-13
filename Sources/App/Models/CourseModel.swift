import Vapor
import FluentPostgreSQL
import Foundation

final class Courses: Codable {
    
    // DEVSCORCH: Courses Variables
    
    var id: UUID?
    var courseName: String
    var instructor: String
    var courseDescription: String
    var lectures: Int
    var sections: Int
    var courseImage: String
    var publishDate: String
    var lastUpdatedDate: String?
    var difficulty: String
    var courseDuration: String
    var beginURL: String
    var forWhoName: String
    var forWhoText: String
    var introVideo: String
    
    // DEVSCORCH: Courses Initialiser
    
    init(courseName: String, courseDescription: String, instructor: String, lectures: Int, sections: Int, courseImage: String, publishDate: String, difficulty: String, beginURL: String, courseDuration: String, forWho: String, introVideo: String, forWhoName: String, forWhoText: String, lastUpdatedDate: String) {
        self.courseName = courseName
        self.instructor = instructor
        self.courseDescription = courseDescription
        self.lectures = lectures
        self.sections = sections
        self.courseImage = courseImage
        self.publishDate = publishDate
        self.difficulty = difficulty
        self.courseDuration = courseDuration
        self.beginURL = beginURL
        self.forWhoName = forWhoName
        self.forWhoText = forWhoText
        self.introVideo = introVideo
        self.lastUpdatedDate = lastUpdatedDate
    }
}

extension Courses: PostgreSQLUUIDModel {}
extension Courses: Migration {
    var categories: Siblings<Courses, CourseCategory, CourseCategoryPivot> {
        return siblings()
    }
}

extension Courses: Content {}
extension Courses: Parameter {}

extension Courses {
    var section: Children<Courses, CourseSection> {
        return children(\.courseID)
    }
}
