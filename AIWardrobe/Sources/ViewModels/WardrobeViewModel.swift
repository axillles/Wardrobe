import Foundation
import SwiftUI
import PhotosUI

@MainActor
class WardrobeViewModel: ObservableObject {
    @Published var clothingItems: [ClothingItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingAddItem = false
    @Published var selectedCategory: ClothingItem.ClothingCategory?
    
    private let supabaseService = SupabaseService.shared
    private let aiService = AIOutfitService.shared
    
    func fetchItems() async {
        isLoading = true
        errorMessage = nil
        
        do {
            clothingItems = try await supabaseService.fetchClothingItems()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func addItem(imageData: Data, category: ClothingItem.ClothingCategory, brand: String?, season: ClothingItem.Season?) async {
        guard let userId = supabaseService.currentUser?.id else { return }
        
        print("📦 Adding new clothing item - Category: \(category.rawValue)")
        isLoading = true
        errorMessage = nil
        
        do {
            // Upload image
            let fileName = "\(UUID().uuidString).jpg"
            print("📋 Uploading image: \(fileName)")
            let imageURL = try await supabaseService.uploadImage(data: imageData, fileName: fileName)
            print("✅ Image uploaded: \(imageURL)")
            
            // Analyze image with AI
            var aiDescriptionJSON: String?
            do {
                print("🤖 Starting AI image analysis...")
                let aiDescription = try await aiService.analyzeClothingImage(data: imageData)
                aiDescriptionJSON = aiDescription.jsonString
                print("✅ AI analysis completed successfully")
            } catch {
                // If AI analysis fails, continue without it
                print("❌ AI analysis failed: \(error)")
                if let openAIError = error as? OpenAIError {
                    switch openAIError {
                    case .invalidAPIKey:
                        print("⚠️ OpenAI API key is invalid or missing")
                    case .apiError(let message):
                        print("⚠️ OpenAI API error: \(message)")
                    case .networkError(let netError):
                        print("⚠️ Network error: \(netError.localizedDescription)")
                    default:
                        print("⚠️ Error type: \(openAIError)")
                    }
                }
            }
            
            // Create clothing item with AI description
            let itemId = UUID()
            var finalAIDescription: String?
            
            // Update the itemId in the AI description if available
            if let descJSON = aiDescriptionJSON,
               var desc = ClothingDescription.from(jsonString: descJSON) {
                let updatedDesc = ClothingDescription(
                    itemId: itemId,
                    detailedDescription: desc.detailedDescription,
                    dominantColors: desc.dominantColors,
                    pattern: desc.pattern,
                    material: desc.material,
                    style: desc.style,
                    formality: desc.formality,
                    season: desc.season,
                    occasion: desc.occasion,
                    fit: desc.fit,
                    condition: desc.condition
                )
                finalAIDescription = updatedDesc.jsonString
            }
            
            let item = ClothingItem(
                id: itemId,
                userId: userId,
                imageURL: imageURL,
                category: category,
                color: nil,
                brand: brand,
                season: season,
                aiDescription: finalAIDescription,
                createdAt: Date()
            )
            
            try await supabaseService.addClothingItem(item)
            await fetchItems()
            showingAddItem = false
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func deleteItem(_ item: ClothingItem) async {
        do {
            try await supabaseService.deleteClothingItem(id: item.id)
            await fetchItems()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var filteredItems: [ClothingItem] {
        if let category = selectedCategory {
            return clothingItems.filter { $0.category == category }
        }
        return clothingItems
    }
}
