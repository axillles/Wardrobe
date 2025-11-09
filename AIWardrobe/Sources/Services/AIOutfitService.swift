import Foundation

class AIOutfitService {
    static let shared = AIOutfitService()
    
    private let openAIService = OpenAIService.shared
    
    private init() {}
    
    /// Analyze clothing item from image using OpenAI Vision API
    func analyzeClothingImage(data: Data) async throws -> ClothingDescription {
        return try await openAIService.analyzeClothingImage(imageData: data)
    }
    
    /// Generate outfit suggestions based on available clothing items using OpenAI
    func generateOutfitSuggestions(
        from items: [ClothingItem],
        occasion: String? = nil,
        season: ClothingItem.Season? = nil
    ) async throws -> [Outfit] {
        // Filter items based on criteria
        var filteredItems = items
        
        if let season = season {
            filteredItems = filteredItems.filter { $0.season == season || $0.season == .allYear }
        }
        
        // Parse AI descriptions from items
        var descriptions: [ClothingDescription] = []
        for item in filteredItems {
            if let aiDescriptionJSON = item.aiDescription,
               let description = ClothingDescription.from(jsonString: aiDescriptionJSON) {
                // Update the itemId to match the actual clothing item
                var updatedDescription = ClothingDescription(
                    itemId: item.id,
                    detailedDescription: description.detailedDescription,
                    dominantColors: description.dominantColors,
                    pattern: description.pattern,
                    material: description.material,
                    style: description.style,
                    formality: description.formality,
                    season: description.season,
                    occasion: description.occasion,
                    fit: description.fit,
                    condition: description.condition
                )
                descriptions.append(updatedDescription)
            }
        }
        
        // If no AI descriptions available, return empty array
        guard !descriptions.isEmpty else {
            return []
        }
        
        // Use OpenAI to generate outfit recommendations
        let seasonString = season?.rawValue
        let recommendations = try await openAIService.generateOutfits(
            from: descriptions,
            occasion: occasion,
            season: seasonString,
            maxOutfits: 5
        )
        
        // Convert OutfitRecommendation to Outfit
        var outfits: [Outfit] = []
        for recommendation in recommendations {
            guard let userId = filteredItems.first?.userId else { continue }
            
            let outfit = Outfit(
                id: UUID(),
                userId: userId,
                name: recommendation.outfitName,
                items: recommendation.itemIds,
                occasion: recommendation.occasion,
                aiGenerated: true,
                createdAt: Date(),
                isFavorite: false
            )
            outfits.append(outfit)
        }
        
        return outfits
    }
}
