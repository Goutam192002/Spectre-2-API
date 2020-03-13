import Vapor
import FluentPostgreSQL

final class CourseSection: Codable {
    
    // DEVSCORCH: CourseSection variabels
    
    var id: Int?
    var sectionName: String
    var sectionNumber: Int
    var sectionDescription: String
    var sectionDuration: String
    var courseID: Courses.ID
    
    // DEVSCORCH: CourseSection Initialiser
    
    init(id: Int, sectionName: String, courseID: Courses.ID, sectionNumber: Int, sectionDescription: String, sectionDuration: String) {
        self.id = id
        self.sectionName = sectionName
        self.courseID = courseID
        self.sectionNumber = sectionNumber
        self.sectionDescription = sectionDescription
        self.sectionDuration = sectionDuration
    }
}

extension CourseSection: Migration {}
extension CourseSection: PostgreSQLModel {}
extension CourseSection: Content {}
extension CourseSection: Parameter {}

extension CourseSection {
    var courses: Parent<CourseSection, Courses> {
        return parent(\.courseID)
    }
}

extension CourseSection {
    var videos: Children<CourseSection, VideoModel> {
        return children(\.sectionID)
    }
}
