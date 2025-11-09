import SwiftUI

struct StylePreferencesStepView: View {
    @ObservedObject var coordinator: RegistrationCoordinator
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("What's your style?")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("Select one or more styles that match your vibe")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Style Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(UserProfile.StylePreference.allCases, id: \.self) { style in
                        StyleCard(
                            style: style,
                            isSelected: coordinator.userProfile.preferredStyles.contains(style)
                        ) {
                            toggleStyle(style)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            
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
                    title: "Continue",
                    action: {
                        coordinator.nextStep()
                    }
                )
                .disabled(!coordinator.canProceedFromStylePreferences())
                .opacity(coordinator.canProceedFromStylePreferences() ? 1 : 0.5)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
    
    private func toggleStyle(_ style: UserProfile.StylePreference) {
        if let index = coordinator.userProfile.preferredStyles.firstIndex(of: style) {
            coordinator.userProfile.preferredStyles.remove(at: index)
        } else {
            coordinator.userProfile.preferredStyles.append(style)
        }
    }
}

struct StyleCard: View {
    let style: UserProfile.StylePreference
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: styleIcon)
                    .font(.system(size: 40))
                    .foregroundColor(isSelected ? .white : .black)
                
                Text(style.rawValue)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : .black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(isSelected ? Color.black : Color(.systemGray6))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.black : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var styleIcon: String {
        switch style {
        case .casual:
            return "tshirt"
        case .formal:
            return "person.fill"
        case .sporty:
            return "figure.run"
        case .elegant:
            return "sparkles"
        case .streetwear:
            return "shoe.fill"
        case .minimalist:
            return "square.fill"
        case .bohemian:
            return "leaf.fill"
        case .vintage:
            return "clock.fill"
        }
    }
}
