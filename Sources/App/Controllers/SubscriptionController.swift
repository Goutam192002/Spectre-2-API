import Vapor
import FluentPostgreSQL
import Authentication
import Stripe

struct SubscriptionController: RouteCollection {
    func boot(router: Router) throws {
        
        let subscriptionRoute = router.grouped("spectre", "subscriptions")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = subscriptionRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        let authsessionRoute = router.grouped(User.authSessionsMiddleware())
        
        let adminTokenAuthMiddleware = Admin.tokenAuthMiddleware()
        let adminGuardfAuthMiddleware = Admin.guardAuthMiddleware()
        let adminTokenAuthGroup = subscriptionRoute.grouped(adminTokenAuthMiddleware, adminGuardfAuthMiddleware)
        
        adminTokenAuthGroup.post(Subscription.self, use: createSubscriptionHandler)
        adminTokenAuthGroup.put(Subscription.parameter, use: updateSubscriptionHandler)
        
        subscriptionRoute.get(use: getAllSubscriptionHandler)
        subscriptionRoute.get(use: getSubscriptionHandler)
        
    }
    
    // DEVSCORCH: createSubscriptionHandler
    
    func createSubscriptionHandler(_ req: Request, subscription: Subscription) throws -> Future<Subscription> {
        return try req.content.decode(Subscription.self).flatMap(to: Subscription.self) { subscription  in
            return subscription.save(on: req)
        }
    }
    
    // DEVSCORCH: Get all subscriptionHandler
    
    func getAllSubscriptionHandler(_ req: Request) throws -> Future<[Subscription]> {
        return Subscription.query(on: req).all()
    }
    
    // DEVSCORCH: Get subscriptionHandler
    
    func getSubscriptionHandler(_ req: Request) throws -> Future<Subscription> {
        return try req.parameters.next(Subscription.self)
    }
    
    // DEVSCORCH: Subscription UpdateHandler
    
    func updateSubscriptionHandler(_ req: Request) throws -> Future<Subscription> {
        return try flatMap(to: Subscription.self, req.parameters.next(Subscription.self), req.content.decode(Subscription.self)) {
            subscription, updatedSubscription in
            subscription.subscriptionName = updatedSubscription.subscriptionName
            subscription.subscriptionPrice = updatedSubscription.subscriptionPrice
            subscription.subscriptionUrl = updatedSubscription.subscriptionUrl
            subscription.tierOne = updatedSubscription.tierOne
            subscription.tierTwo = updatedSubscription.tierTwo
            subscription.tierThree = updatedSubscription.tierThree
            subscription.tierFour = updatedSubscription.tierFour
            subscription.tierFive = updatedSubscription.tierFive
            subscription.tierSix = updatedSubscription.tierSix
            subscription.tierSeven = updatedSubscription.tierSeven
            return subscription.save(on: req)
        }
    }
}
