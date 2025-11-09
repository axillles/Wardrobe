import Foundation

struct ClothingDescription: Codable {
    let itemId: UUID
    let detailedDescription: String
    let dominantColors: [String]
    let pattern: String?
    let material: String?
    let style: [String]
    let formality: FormalityLevel
    let season: [String]
    let occasion: [String]
    let fit: FitType?
    let condition: String?
    
    enum FormalityLevel: String, Codable {
        case casual = "casual"
        case smartCasual = "smart_casual"
        case businessCasual = "business_casual"
        case formal = "formal"
        case athletic = "athletic"
    }
    
    enum FitType: String, Codable {
        case tight = "tight"
        case fitted = "fitted"
        case regular = "regular"
        case relaxed = "relaxed"
        case oversized = "oversized"
    }
    
    // For database storage
    var jsonString: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    static func from(jsonString: String) -> ClothingDescription? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(ClothingDescription.self, from: data)
    }
}

struct OutfitRecommendation: Codable {
    let outfitName: String
    let description: String
    let occasion: String
    let styleVibe: String
    let itemIds: [UUID]
    let reasoning: String
    let seasonSuitability: [String]
    let tips: [String]
}
