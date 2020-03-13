import Vapor
import FluentPostgreSQL

final class Download: Codable {
    
    // DEVSCORCH: Download Variabels
    
    var id: Int?
    var name: String
    var description: String
    var downloadUrl: String
    var image: String
    var fileSize: Int
    var files: Int
    
    // DEVSCORCH: Download Initialisers
    
    init(name: String, description: String, downloadUrl: String, fileSize: Int, files: Int, image: String) {
        self.name = name
        self.description = description
        self.downloadUrl = downloadUrl
        self.fileSize = fileSize
        self.files = files
        self.image = image
    }
}

extension Download: PostgreSQLModel {}
extension Download: Content {}
extension Download: Migration {}
extension Download: Parameter {}
