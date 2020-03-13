import Vapor
import FluentPostgreSQL


struct BlogController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let blogRoute = router.grouped("spectre", "blog")
        
        let authSessionRoutes = router.grouped(User.authSessionsMiddleware())
        
        let adminTokenAuthMiddleware = Admin.tokenAuthMiddleware()
        let adminGuardfAuthMiddleware = Admin.guardAuthMiddleware()
        let adminTokenAuthGroup = blogRoute.grouped(adminTokenAuthMiddleware, adminGuardfAuthMiddleware)
        
        adminTokenAuthGroup.post(BlogPostModel.self, use: createHandler)

        
      
    }
    
    
    // DEVSCORCH: Create BlogPost
          
    func createHandler(_ req: Request, blogPost: BlogPostModel) throws -> Future<BlogPostModel> {
        return blogPost.save(on: req)
    }
    
    // DEVSCORCH: DeleteHandler
    
    func deleteHandler(_ req: Request)  throws -> Future<HTTPStatus> {
           return try req.parameters.next(BlogPostModel.self).delete(on: req).transform(to: HTTPStatus.noContent)
       }
    
//     func updateHandler(_ req: Request) throws -> Future<BlogPostModel> {
//           return try flatMap(to: BlogPostModel.self, req.parameters.next(BlogPostModel.self), req.content.decode(BlogPostModel.self)) {
//                   blog, updatedBlog in
//            blog.
//               
//               
//           }
//    }
    
}
