import SwiftUI

@MainActor
class AppCoordinator: ObservableObject {
    @Published var currentFlow: AppFlow = .onboarding
    
    enum AppFlow {
        case onboarding
        case authentication
        case main
    }
    
    init() {
        checkAppState()
    }
    
    func checkAppState() {
        // Check if user has seen onboarding
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if !hasSeenOnboarding {
            currentFlow = .onboarding
        } else if SupabaseService.shared.currentUser != nil {
            currentFlow = .main
        } else {
            currentFlow = .authentication
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        currentFlow = .authentication
    }
    
    func loginCompleted() {
        currentFlow = .main
    }
    
    func logout() {
        Task {
            try? await SupabaseService.shared.signOut()
            currentFlow = .authentication
        }
    }
    
    @ViewBuilder
    func start() -> some View {
        switch currentFlow {
        case .onboarding:
            OnboardingView(coordinator: self)
        case .authentication:
            RegistrationFlowView(appCoordinator: self)
        case .main:
            MainTabView(coordinator: self)
        }
    }
}
