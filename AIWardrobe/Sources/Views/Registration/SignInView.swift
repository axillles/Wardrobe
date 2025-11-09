import SwiftUI

struct SignInView: View {
    @ObservedObject var appCoordinator: AppCoordinator
    @Binding var isPresented: Bool
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Logo/Title
                    VStack(spacing: 12) {
                        Image(systemName: "tshirt.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.black)
                        
                        Text("Welcome back")
                            .font(.system(size: 32, weight: .bold))
                        
                        Text("Sign in to continue")
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
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        PrimaryButton(
                            title: "Sign In",
                            action: {
                                Task {
                                    await viewModel.signIn()
                                    
                                    if viewModel.isAuthenticated {
                                        isPresented = false
                                        appCoordinator.loginCompleted()
                                    }
                                }
                            },
                            isLoading: viewModel.isLoading
                        )
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}
