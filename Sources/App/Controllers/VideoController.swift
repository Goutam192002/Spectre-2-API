import Vapor
import Fluent
import Authentication

struct VideoController: RouteCollection {
    func boot(router: Router) throws {
        let videoRoute = router.grouped("spectre", "videos")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = videoRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        let authSessionRoutes = router.grouped(User.authSessionsMiddleware())

        
        let adminTokenAuthMiddleware = Admin.tokenAuthMiddleware()
        let adminGuardfAuthMiddleware = Admin.guardAuthMiddleware()
        let adminTokenAuthGroup = videoRoute.grouped(adminTokenAuthMiddleware, adminGuardfAuthMiddleware)
        
        adminTokenAuthGroup.post(VideoModel.self, use: createVideoHandler)
        
    }
    
    func createVideoHandler(_ req: Request, video: VideoModel) throws -> Future<VideoModel> {
        return try req.content.decode(VideoModel.self).flatMap(to: VideoModel.self) { video in
            return video.save(on: req)
        }
    }
    
    func getVideoHandler(req: Request) throws -> Future<CourseSection> {
        let user = try req.requireAuthenticated(User.self)
        if user.subscriptionIsActive == true {
            return try req.parameters.next(VideoModel.self).flatMap(to: CourseSection.self) { video in
                return video.section.get(on: req)
            }
        } else {
            throw Abort(.badRequest, reason: "You dont have a active subscription. Make sure to activate a subscription plan and try again")
        }
    }
    
    func getAllVideoHandler(_ req: Request) throws -> Future<[VideoModel]> {
        let user = try req.requireAuthenticated(User.self)
        if user.subscriptionIsActive == true {
            return VideoModel.query(on: req).all()
        } else {
            throw Abort(.badRequest, reason: "You dont have a active subscription. Make sure to activate a subscription plan and try again")
        }
    }
}


