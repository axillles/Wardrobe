import SwiftUI

struct AuthenticationStepView: View {
    @ObservedObject var coordinator: RegistrationCoordinator
    @ObservedObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("Create your account")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("You're almost done!")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Form
            VStack(spacing: 16) {
                CustomTextField(
                    placeholder: "Email",
                    text: $coordinator.email,
                    keyboardType: .emailAddress
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                
                CustomTextField(
                    placeholder: "Password",
                    text: $coordinator.password,
                    isSecure: true
                )
                
                CustomTextField(
                    placeholder: "Confirm Password",
                    text: $coordinator.confirmPassword,
                    isSecure: true
                )
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Navigation Buttons
            HStack(spacing: 12) {
                Button(action: {
                    coordinator.previousStep()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                
                PrimaryButton(
                    title: "Sign Up",
                    action: {
                        Task {
                            viewModel.email = coordinator.email
                            viewModel.password = coordinator.password
                            viewModel.confirmPassword = coordinator.confirmPassword
                            
                            await viewModel.signUp()
                            
                            if viewModel.isAuthenticated {
                                // TODO: Save user profile to database
                                appCoordinator.loginCompleted()
                            }
                        }
                    },
                    isLoading: viewModel.isLoading
                )
                .disabled(!canSignUp())
                .opacity(canSignUp() ? 1 : 0.5)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
    
    private func canSignUp() -> Bool {
        return !coordinator.email.isEmpty &&
               !coordinator.password.isEmpty &&
               coordinator.password == coordinator.confirmPassword &&
               coordinator.password.count >= 6
    }
}
