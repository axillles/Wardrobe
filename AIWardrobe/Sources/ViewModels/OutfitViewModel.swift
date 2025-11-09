import Foundation

@MainActor
class OutfitViewModel: ObservableObject {
    @Published var outfits: [Outfit] = []
    @Published var suggestedOutfits: [Outfit] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabaseService = SupabaseService.shared
    private let aiService = AIOutfitService.shared
    
    func fetchOutfits() async {
        isLoading = true
        errorMessage = nil
        
        do {
            outfits = try await supabaseService.fetchOutfits()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func generateSuggestions(season: ClothingItem.Season? = nil, occasion: String? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let items = try await supabaseService.fetchClothingItems()
            suggestedOutfits = try await aiService.generateOutfitSuggestions(
                from: items,
                occasion: occasion,
                season: season
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func saveOutfit(_ outfit: Outfit) async {
        do {
            try await supabaseService.saveOutfit(outfit)
            await fetchOutfits()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteOutfit(_ outfit: Outfit) async {
        do {
            try await supabaseService.deleteOutfit(outfit.id)
            await fetchOutfits()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
