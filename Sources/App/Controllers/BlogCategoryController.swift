
import Vapor
import Authentication


struct BlogCategoryController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoute = router.grouped("spectre", "blog-categorory")
        
        let authSessionRoutes = router.grouped(User.authSessionsMiddleware())

        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = categoriesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        let adminTokenAuthMiddleware = Admin.tokenAuthMiddleware()
        let adminGuardfAuthMiddleware = Admin.guardAuthMiddleware()
        let adminTokenAuthGroup = categoriesRoute.grouped(adminTokenAuthMiddleware, adminGuardfAuthMiddleware)
        
        adminTokenAuthGroup.post(BlogCategoryModel.self, use: createHandler)
        adminTokenAuthGroup.delete(BlogCategoryModel.parameter, use: deleteHandler)
        
        
    }
    
    // DEVSCORCHL Categories Handler for creation of Categories
    func createHandler(_ req: Request, category: BlogCategoryModel) throws -> Future<BlogCategoryModel> {
        return category.save(on: req)
    }
    
    // DEVSCORCH: Categories Handler for retrieving Categories
    func getAllHandler(_ req: Request) throws -> Future<[CourseCategory]> {
        return CourseCategory.query(on: req).all()
    }
    
    // DEVSCORCH: Categories Handler for retrieving one specific Category
    func getHandler(_ req: Request) throws -> Future<CourseCategory> {
        
        return try req.parameters.next(CourseCategory.self)
    }
    
    // DEVSCORCH: Handler for retrieving specific Courses in a Category
    func getCoursesHandler(_ req: Request) throws -> Future<[BlogPostModel]> {
        return try req.parameters.next(BlogCategoryModel.self).flatMap(to: [BlogPostModel].self) { category in
            try category.blogPostModel.query(on: req).all()
        }
    }
    
    func deleteHandler(_ req: Request)  throws -> Future<HTTPStatus> {
        return try req.parameters.next(BlogCategoryModel.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
}
