import Foundation
import Supabase

@MainActor
class SupabaseService: ObservableObject {
    static let shared = SupabaseService()
    
    private let client: SupabaseClient
    @Published var currentUser: User?
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: Config.supabaseURL)!,
            supabaseKey: Config.supabaseAnonKey
        )
        
        // Configure auth client to emit local session as initial session
        Task {
            // This addresses the warning about initial session behavior
            await checkSession()
        }
    }
    
    // MARK: - Authentication
    
    func signUp(email: String, password: String) async throws -> User {
        let response = try await client.auth.signUp(
            email: email,
            password: password
        )
        
        guard let session = response.session else {
            throw NSError(domain: "SupabaseService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No session returned"])
        }
        
        let user = User(
            id: session.user.id,
            email: session.user.email ?? email,
            createdAt: Date()
        )
        
        currentUser = user
        return user
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let session = try await client.auth.signIn(
            email: email,
            password: password
        )
        
        let user = User(
            id: session.user.id,
            email: session.user.email ?? email,
            createdAt: Date()
        )
        
        currentUser = user
        return user
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
        currentUser = nil
    }
    
    func checkSession() async {
        do {
            let session = try await client.auth.session
            currentUser = User(
                id: session.user.id,
                email: session.user.email ?? "",
                createdAt: Date()
            )
        } catch {
            currentUser = nil
        }
    }
    
    // MARK: - Clothing Items
    
    func fetchClothingItems() async throws -> [ClothingItem] {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "SupabaseService", code: 2, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let response: [ClothingItem] = try await client.database
            .from("clothing_items")
            .select()
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
        
        return response
    }
    
    func addClothingItem(_ item: ClothingItem) async throws {
        try await client.database
            .from("clothing_items")
            .insert(item)
            .execute()
    }
    
    func deleteClothingItem(id: UUID) async throws {
        try await client.database
            .from("clothing_items")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }
    
    // MARK: - Outfits
    
    func fetchOutfits() async throws -> [Outfit] {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "SupabaseService", code: 2, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let response: [Outfit] = try await client.database
            .from("outfits")
            .select()
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
        
        return response
    }
    
    func saveOutfit(_ outfit: Outfit) async throws {
        try await client.database
            .from("outfits")
            .insert(outfit)
            .execute()
    }
    
    func deleteOutfit(_ id: UUID) async throws {
        try await client.database
            .from("outfits")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }
    
    // MARK: - Storage
    
    func uploadImage(data: Data, fileName: String) async throws -> String {
        let file = File(name: fileName, data: data, fileName: fileName, contentType: "image/jpeg")
        
        try await client.storage
            .from("wardrobe-images")
            .upload(
                fileName,
                data: data,
                options: FileOptions(contentType: "image/jpeg")
            )
        
        let url = try client.storage
            .from("wardrobe-images")
            .getPublicURL(path: fileName)
        
        return url.absoluteString
    }
}
