import Vapor
import FluentPostgreSQL
import Authentication

struct SectionController: RouteCollection {
    
    // DEVSCORCH: Router function
    
    func boot(router: Router) throws {
        
        // DEVSCORCH: Section Router and sectionRouter  Handlers
        let sectionRoute = router.grouped("spectre", "sections")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = sectionRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        let authSessionRoutes = router.grouped(User.authSessionsMiddleware())

        
        let adminTokenAuthMiddleware = Admin.tokenAuthMiddleware()
        let adminGuardfAuthMiddleware = Admin.guardAuthMiddleware()
        let adminTokenAuthGroup = sectionRoute.grouped(adminTokenAuthMiddleware, adminGuardfAuthMiddleware)
        
        let authSessionRoute = router.grouped(User.authSessionsMiddleware())
        
        adminTokenAuthGroup.post(CourseSection.self, use: createCourseSectionHandler)
        authSessionRoute.get(CourseSection.parameter, use: getSectionHandler)
        authSessionRoute.get(CourseSection.parameter, use: getCourseHandler)
       // adminTokenAuthGroup.put(CourseSection.parameter, use: updateSectionHandler)

        
    }
    
    // DEVSCORCH: Create Handler for creating course Sections
    func createCourseSectionHandler(_ req: Request, section: CourseSection) throws -> Future<CourseSection> {
        return try req.content.decode(CourseSection.self).flatMap(to: CourseSection.self) { section in
            return section.save(on: req)
        }
    }
    
    // DEVSCORCH: Get handler for getting sections
    func getSectionHandler(_ req: Request) throws -> Future<CourseSection> {
        let _ = try req.parameters.next(Courses.self)
        return try req.parameters.next(CourseSection.self)
    }
    
    // DEVSCORCH: Get Handler for getting Courses Sections
    func getCourseHandler(_ req: Request) throws ->  Future<Courses> {
        return try req.parameters.next(CourseSection.self).flatMap(to: Courses.self) { section in
            section.courses.get(on: req)
        }
    }
    
//    func updateSectionHandler(_ req: Request) throws -> Future<CourseSection> {
//        return try flatMap(to: CourseSection.self, req.parameters.next(CourseSection.self), req.content.decode(CourseSection.self)) {
//             courseSection, updatedCourseSection in
//               courseSection.sectionName = updatedCourseSection
//            return courseSection.save(on: req)
//        }
//    }
    
}

