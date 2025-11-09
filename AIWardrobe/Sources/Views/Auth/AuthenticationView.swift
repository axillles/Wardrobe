import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel = AuthViewModel()
    @State private var isSignUpMode = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Logo/Title
                    VStack(spacing: 12) {
                        Image(systemName: "tshirt.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.black)
                        
                        Text("AI Wardrobe")
                            .font(.system(size: 36, weight: .bold))
                        
                        Text(isSignUpMode ? "Create your account" : "Welcome back")
                            .font(.system(size: 17))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 60)
                    
                    // Form
                    VStack(spacing: 16) {
                        CustomTextField(
                            placeholder: "Email",
                            text: $viewModel.email,
                            keyboardType: .emailAddress
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        
                        CustomTextField(
                            placeholder: "Password",
                            text: $viewModel.password,
                            isSecure: true
                        )
                        
                        if isSignUpMode {
                            CustomTextField(
                                placeholder: "Confirm Password",
                                text: $viewModel.confirmPassword,
                                isSecure: true
                            )
                        }
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        PrimaryButton(
                            title: isSignUpMode ? "Sign Up" : "Sign In",
                            action: {
                                Task {
                                    if isSignUpMode {
                                        await viewModel.signUp()
                                    } else {
                                        await viewModel.signIn()
                                    }
                                    
                                    if viewModel.isAuthenticated {
                                        coordinator.loginCompleted()
                                    }
                                }
                            },
                            isLoading: viewModel.isLoading
                        )
                        .padding(.top, 8)
                        
                        Button(action: {
                            withAnimation {
                                isSignUpMode.toggle()
                                viewModel.clearError()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text(isSignUpMode ? "Already have an account?" : "Don't have an account?")
                                    .foregroundColor(.secondary)
                                Text(isSignUpMode ? "Sign In" : "Sign Up")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                            }
                            .font(.system(size: 15))
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}
