import SwiftUI

struct RegistrationFlowView: View {
    @ObservedObject var appCoordinator: AppCoordinator
    @StateObject private var registrationCoordinator = RegistrationCoordinator()
    @State private var showSignInView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Current Step Content
                Group {
                    switch registrationCoordinator.currentStep {
                    case .basicInfo:
                        BasicInfoStepView(coordinator: registrationCoordinator)
                    case .stylePreferences:
                        StylePreferencesStepView(coordinator: registrationCoordinator)
                    case .colorPreferences:
                        ColorPreferencesStepView(coordinator: registrationCoordinator)
                    case .authentication:
                        AuthenticationStepView(
                            coordinator: registrationCoordinator,
                            appCoordinator: appCoordinator
                        )
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
                // Progress Indicator at the top
                VStack {
                    ProgressBar(currentStep: registrationCoordinator.currentStep)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .overlay(alignment: .topTrailing) {
                if registrationCoordinator.currentStep == .basicInfo {
                    Button(action: {
                        showSignInView = true
                    }) {
                        Text("Sign In")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 16)
                }
            }
            .sheet(isPresented: $showSignInView) {
                SignInView(appCoordinator: appCoordinator, isPresented: $showSignInView)
            }
        }
    }
}

struct ProgressBar: View {
    let currentStep: RegistrationCoordinator.RegistrationStep
    
    var progress: CGFloat {
        switch currentStep {
        case .basicInfo:
            return 0.25
        case .stylePreferences:
            return 0.5
        case .colorPreferences:
            return 0.75
        case .authentication:
            return 1.0
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(height: 6)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.black)
                    .frame(width: geometry.size.width * progress, height: 6)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 6)
    }
}
