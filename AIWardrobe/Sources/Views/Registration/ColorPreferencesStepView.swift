import SwiftUI

struct ColorPreferencesStepView: View {
    @ObservedObject var coordinator: RegistrationCoordinator
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    let availableColors: [(name: String, color: Color)] = [
        ("Black", .black),
        ("White", .white),
        ("Gray", .gray),
        ("Navy", Color(red: 0, green: 0.2, blue: 0.4)),
        ("Blue", .blue),
        ("Red", .red),
        ("Pink", .pink),
        ("Purple", .purple),
        ("Green", .green),
        ("Brown", Color(red: 0.6, green: 0.4, blue: 0.2)),
        ("Beige", Color(red: 0.96, green: 0.96, blue: 0.86)),
        ("Yellow", .yellow),
        ("Orange", .orange),
        ("Olive", Color(red: 0.5, green: 0.5, blue: 0)),
        ("Burgundy", Color(red: 0.5, green: 0, blue: 0.13))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("Choose your colors")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("Select the colors you prefer in your wardrobe")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Color Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(availableColors, id: \.name) { colorItem in
                        ColorCircle(
                            colorName: colorItem.name,
                            color: colorItem.color,
                            isSelected: coordinator.userProfile.preferredColors.contains(colorItem.name)
                        ) {
                            toggleColor(colorItem.name)
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
                .disabled(!coordinator.canProceedFromColorPreferences())
                .opacity(coordinator.canProceedFromColorPreferences() ? 1 : 0.5)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
    
    private func toggleColor(_ colorName: String) {
        if let index = coordinator.userProfile.preferredColors.firstIndex(of: colorName) {
            coordinator.userProfile.preferredColors.remove(at: index)
        } else {
            coordinator.userProfile.preferredColors.append(colorName)
        }
    }
}

struct ColorCircle: View {
    let colorName: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 70, height: 70)
                    .overlay(
                        Circle()
                            .stroke(colorName == "White" ? Color(.systemGray4) : Color.clear, lineWidth: 1)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: isSelected ? 3 : 0)
                            .padding(-4)
                    )
                    .overlay(
                        Group {
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(colorName == "White" || colorName == "Yellow" || colorName == "Beige" ? .black : .white)
                                    .background(
                                        Circle()
                                            .fill(colorName == "White" || colorName == "Yellow" || colorName == "Beige" ? Color.white : Color.black)
                                            .frame(width: 20, height: 20)
                                    )
                            }
                        }
                    )
                
                Text(colorName)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
