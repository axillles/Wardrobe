import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    private let supabaseService = SupabaseService.shared
    
    var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }
    
    var isValidPassword: Bool {
        password.count >= 6
    }
    
    var passwordsMatch: Bool {
        password == confirmPassword
    }
    
    func signUp() async {
        guard isValidEmail else {
            errorMessage = "Please enter a valid email address"
            return
        }
        
        guard isValidPassword else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        guard passwordsMatch else {
            errorMessage = "Passwords do not match"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await supabaseService.signUp(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signIn() async {
        guard isValidEmail else {
            errorMessage = "Please enter a valid email address"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Please enter your password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await supabaseService.signIn(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
}
