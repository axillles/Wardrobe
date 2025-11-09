import SwiftUI

struct OnboardingView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var currentPage = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Your Digital Wardrobe",
            description: "Capture and organize all your clothing items in one place",
            systemImage: "photo.on.rectangle.angled"
        ),
        OnboardingPage(
            title: "AI-Powered Outfits",
            description: "Get personalized outfit suggestions based on your style and preferences",
            systemImage: "sparkles"
        ),
        OnboardingPage(
            title: "Never Miss a Fit",
            description: "Mix and match your clothes like never before with intelligent recommendations",
            systemImage: "star.fill"
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack(spacing: 20) {
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.black : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                // Buttons
                if currentPage == pages.count - 1 {
                    PrimaryButton(title: "Get Started") {
                        coordinator.completeOnboarding()
                    }
                    .padding(.horizontal, 32)
                    .transition(.opacity)
                } else {
                    HStack {
                        Button("Skip") {
                            coordinator.completeOnboarding()
                        }
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                        
                        Spacer()
                        
                        PrimaryButton(title: "Next") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                        .frame(width: 120)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .padding(.bottom, 40)
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 100))
                .foregroundColor(.black)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}
