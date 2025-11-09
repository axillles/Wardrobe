import Foundation

struct ClothingItem: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let imageURL: String
    let category: ClothingCategory
    let color: String?
    let brand: String?
    let season: Season?
    let aiDescription: String? // JSON string of ClothingDescription
    let createdAt: Date
    
    enum ClothingCategory: String, Codable, CaseIterable {
        case tops = "Tops"
        case bottoms = "Bottoms"
        case outerwear = "Outerwear"
        case dresses = "Dresses"
        case shoes = "Shoes"
        case accessories = "Accessories"
    }
    
    enum Season: String, Codable, CaseIterable {
        case spring = "Spring"
        case summer = "Summer"
        case fall = "Fall"
        case winter = "Winter"
        case allYear = "All Year"
    }
}
