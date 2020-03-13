import Vapor
import Authentication


struct CourseCategoryController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoute = router.grouped("spectre", "categories")
        
        let authSessionRoutes = router.grouped(User.authSessionsMiddleware())

        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = categoriesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        let adminTokenAuthMiddleware = Admin.tokenAuthMiddleware()
        let adminGuardfAuthMiddleware = Admin.guardAuthMiddleware()
        let adminTokenAuthGroup = categoriesRoute.grouped(adminTokenAuthMiddleware, adminGuardfAuthMiddleware)
        
        adminTokenAuthGroup.post(CourseCategory.self, use: createHandler)
        adminTokenAuthGroup.delete(CourseCategory.parameter, use: deleteHandler)
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(CourseCategory.parameter, use: getHandler)
        categoriesRoute.get(CourseCategory.parameter, "courses", use: getCoursesHandler)
        
        tokenAuthGroup.post(CourseCategory.self, use: createHandler)
        
    }
    
    // DEVSCORCHL Categories Handler for creation of Categories
    func createHandler(_ req: Request, category: CourseCategory) throws -> Future<CourseCategory> {
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
    func getCoursesHandler(_ req: Request) throws -> Future<[Courses]> {
        return try req.parameters.next(CourseCategory.self).flatMap(to: [Courses].self) { category in
            try category.courses.query(on: req).all()
        }
    }
    
    func deleteHandler(_ req: Request)  throws -> Future<HTTPStatus> {
        return try req.parameters.next(CourseCategory.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
}

