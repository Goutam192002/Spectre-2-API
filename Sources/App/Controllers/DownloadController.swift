import Vapor
import FluentPostgreSQL
import Authentication

struct DownloadsController: RouteCollection {
    func boot(router: Router) throws {
        
        let downloadRoute = router.grouped("spectre", "downloads")
        
        // DEVSCORCH: TokenAuth Middleware
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let authSessionRoutes = router.grouped(User.authSessionsMiddleware())


        
        let basicAuthGroup = downloadRoute.grouped(basicAuthMiddleware)

        
        let adminTokenAuthMiddleware = Admin.tokenAuthMiddleware()
        let adminGuardfAuthMiddleware = Admin.guardAuthMiddleware()
        let adminTokenAuthGroup = downloadRoute.grouped(adminTokenAuthMiddleware, adminGuardfAuthMiddleware)
        
        adminTokenAuthGroup.post(Download.self, use: createDownloadHandler)
        adminTokenAuthGroup.put(Download.parameter, use: updateDownloadHandler)
        basicAuthGroup.get(Download.parameter, use: getDownloadHandler)
        basicAuthGroup.get(use: getAllDownloadHandler)
        
    }
    
    // DEVSCORCH: Downloads Create Handler
    
    func createDownloadHandler(_ req: Request, download: Download) throws -> Future<Download> {
        return try req.content.decode(Download.self).flatMap(to: Download.self) { downloads in
            return downloads.save(on: req)
        }
    }
    
    // DEVSCORCH: Download Handler
    
    func getDownloadHandler(_ req: Request) throws -> Future<Download> {
        return try req.parameters.next(Download.self)
    }
    
    // DEVSCORCH: Download All Handler
    
    func getAllDownloadHandler(_ req: Request) throws -> Future<[Download]> {
    return Download.query(on: req).all()
    }
    
    // DEVSCORCH: Update DOwnload Handler
    
    func updateDownloadHandler(_ req: Request) throws -> Future<Download> {
        return try flatMap(to: Download.self, req.parameters.next(Download.self), req.content.decode(Download.self)) {
            download, updatedDownload in
            download.name = updatedDownload.name
            download.description = updatedDownload.description
            download.downloadUrl = updatedDownload.downloadUrl
            download.files = updatedDownload.files
            download.fileSize = updatedDownload.fileSize
            
            return download.save(on: req)
        }
    }
    
}




