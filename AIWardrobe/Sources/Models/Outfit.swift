import Foundation

struct Outfit: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let name: String
    let items: [UUID] // Array of ClothingItem IDs
    let occasion: String?
    let aiGenerated: Bool
    let createdAt: Date
    var isFavorite: Bool
}
