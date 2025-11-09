import Foundation
import SwiftUI

@MainActor
class RegistrationCoordinator: ObservableObject {
    @Published var currentStep: RegistrationStep = .basicInfo
    @Published var userProfile: UserProfile
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    enum RegistrationStep {
        case basicInfo
        case stylePreferences
        case colorPreferences
        case authentication
    }
    
    init() {
        // Initialize with default values
        self.userProfile = UserProfile(
            userId: UUID(),
            height: nil,
            weight: nil,
            age: nil,
            preferredStyles: [],
            preferredColors: [],
            measurementUnit: .metric
        )
    }
    
    func nextStep() {
        withAnimation {
            switch currentStep {
            case .basicInfo:
                currentStep = .stylePreferences
            case .stylePreferences:
                currentStep = .colorPreferences
            case .colorPreferences:
                currentStep = .authentication
            case .authentication:
                break
            }
        }
    }
    
    func previousStep() {
        withAnimation {
            switch currentStep {
            case .basicInfo:
                break
            case .stylePreferences:
                currentStep = .basicInfo
            case .colorPreferences:
                currentStep = .stylePreferences
            case .authentication:
                currentStep = .colorPreferences
            }
        }
    }
    
    func canProceedFromBasicInfo() -> Bool {
        return userProfile.height != nil && userProfile.weight != nil && userProfile.age != nil
    }
    
    func canProceedFromStylePreferences() -> Bool {
        return !userProfile.preferredStyles.isEmpty
    }
    
    func canProceedFromColorPreferences() -> Bool {
        return !userProfile.preferredColors.isEmpty
    }
}
