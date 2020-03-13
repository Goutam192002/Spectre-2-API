import Vapor
import FluentPostgreSQL
import Stripe

struct BlazeModel: Codable {
    
    let id: String?
    let object: String?
    let application_free_percent: Double?
    let billing_cycle_anchor: Int?
    let billing_thresholds: String?
    let cancel_at_period_end: Bool?
    let canceled_at: Int?
    let collection_method: String?
    let created: Int?
    let current_period_end: Int?
    let current_period_start: Int?
    
    
    
    
}
