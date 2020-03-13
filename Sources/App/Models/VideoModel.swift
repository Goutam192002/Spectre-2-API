import Vapor
import FluentPostgreSQL

final class VideoModel: Codable {
    
    // DEVSCORCH: Video Variabels
    var id: Int?
    var videoName: String
    var videoNumber: Int
    var videoURL: String
    var videoDuration: String
    var sectionID: CourseSection.ID
    
    // DEVSCORCH: Video Initialiser

    
    init(videoName: String, videoURL: String, sectionID: CourseSection.ID, videoNumber: Int, videoDuration : String) {
        self.videoName = videoName
        self.videoURL = videoURL
        self.sectionID = sectionID
        self.videoNumber = videoNumber
        self.videoDuration = videoDuration
        
    }
}

extension VideoModel: PostgreSQLModel {}
extension VideoModel: Migration {}
extension VideoModel: Content {}
extension VideoModel: Parameter {}

extension VideoModel {
    var section: Parent<VideoModel, CourseSection> {
        return parent(\.sectionID)
    }
}
