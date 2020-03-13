import Vapor
import FluentPostgreSQL
import Authentication

struct CourseController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let coursesRoute = router.grouped("spectre", "courses")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = coursesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        let authSessionRoutes = router.grouped(User.authSessionsMiddleware())

        
        
        let adminTokenAuthMiddleware = Admin.tokenAuthMiddleware()
        let adminGuardfAuthMiddleware = Admin.guardAuthMiddleware()
        let adminTokenAuthGroup = coursesRoute.grouped(adminTokenAuthMiddleware, adminGuardfAuthMiddleware)
        
        // DEVSCORCH: Admin Handlers
        
        adminTokenAuthGroup.post(Courses.parameter, "categories", CourseCategory.parameter, use: addCategoryHandler)
        adminTokenAuthGroup.put(Courses.parameter, use: updateHandler)
        adminTokenAuthGroup.post(Courses.self, use: createHandler)
        
        
        // DEVSCORCH: Course Route handlers
        
        coursesRoute.get(use: getAllHandler)
        coursesRoute.get(Courses.parameter, use: getHandler)

    }

    // DEVSCORCH: Course CreateHandler
    
    func createHandler(_ req: Request, course: Courses) throws -> Future<Courses> {
        return try req.content.decode(Courses.self).flatMap(to: Courses.self) { courses in
            return courses.save(on: req)
        }
    }
    
    // DEVSCORCH: Course getHandler
    func getHandler(_ req: Request) throws -> Future<Courses> {
        return try req.parameters.next(Courses.self)
    }
    
    // DEVSCORCH: Course CreateHandler
    func getAllHandler(_ req: Request) throws -> Future<[Courses]> {
        return Courses.query(on: req).all()
    }
    
    
    // DEVSCORCH: Course UpdateHandler
    func updateHandler(_ req: Request) throws -> Future<Courses> {
        return try flatMap(to:Courses.self, req.parameters.next(Courses.self), req.content.decode(Courses.self)) {
            courses, updatedCourse in
            courses.courseName = updatedCourse.courseName
            courses.instructor = updatedCourse.instructor
            courses.courseDescription = updatedCourse.courseDescription
            courses.courseImage = updatedCourse.courseImage
            return courses.save(on: req)
        }
    }
    
    // DEVSCORCHL Categories Handler for creation of Categories
    func createCategoryHandler(_ req: Request, category: CourseCategory) throws -> Future<CourseCategory> {
        return category.save(on: req)
    }
    
    // DEVSCORCH: Category CreateHandler
    func addCategoryHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Courses.self), req.parameters.next(CourseCategory.self)) { courses, category in
            return courses.categories.attach(category, on: req).transform(to: .created)
        }
    }
    
    // DEVSCORCH: Category Course Handlers
    func getCategoriesHandler(_ req: Request) throws -> Future<[CourseCategory]> {
        return try req.parameters.next(Courses.self).flatMap(to: [CourseCategory].self) { courses in
            try courses.categories.query(on: req).all()
        }
    }
    
    // DEVSCORCH: Handler for retrieving all sections in a Course
//    func getAllSectionHandler(_ req: Request) throws -> Future<[CourseSection]> {
//        return try req.parameters.next(Courses.self).flatMap(to: [CourseSection].self) { courses in
//            try courses.sections.query(on: req).all()
//        }
//    }
    
    // DEVSCORCH: Handler for retrieving one section in a Course
    
    func getSectionHandler(_ req: Request) throws -> Future<CourseSection> {
        let _ = try req.parameters.next(Courses.self)
        return try req.parameters.next(CourseSection.self)
    }
    
    // DEVSCORCH: Handler for retrieving Videos from Sections
    
    func getAllVideoHandler(_ req: Request) throws -> Future<[VideoModel]> {
        let _ = try req.parameters.next(Courses.self)
        
        let user = try req.requireAuthenticated(User.self)
        if user.subscriptionIsActive == true {
            return try req.parameters.next(CourseSection.self).flatMap(to: [VideoModel].self) { videos in
                return VideoModel.query(on: req).all()
            }
        } else {
            throw Abort(.badRequest, reason: "You dont have a active subscription. Make sure to activate a subscription plan and try again")
        }
        
    }
    
    func getVideoHandler(req: Request) throws -> Future<VideoModel> {
        let _ = try req.parameters.next(Courses.self)
        let user = try req.requireAuthenticated(User.self)
        
        if user.subscriptionIsActive == true {
        let _ = try req.parameters.next(CourseSection.self)
        return try req.parameters.next(VideoModel.self)
        } else {
            throw Abort(.badRequest, reason: "You dont have a active subscription. Make sure to activate a subscription plan and try again")
        }
    }
}

