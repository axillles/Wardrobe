import SwiftUI

struct BasicInfoStepView: View {
    @ObservedObject var coordinator: RegistrationCoordinator
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("Tell us about yourself")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("This helps us give you better outfit suggestions")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Measurements
            VStack(spacing: 32) {
                MeasurementCard(title: "Height") {
                    HeightPickerView(height: $coordinator.userProfile.height)
                }
                
                MeasurementCard(title: "Weight") {
                    WeightPickerView(weight: $coordinator.userProfile.weight)
                }
                
                MeasurementCard(title: "Age") {
                    AgePickerView(age: $coordinator.userProfile.age)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Continue Button
            PrimaryButton(
                title: "Continue",
                action: {
                    coordinator.nextStep()
                }
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .disabled(!coordinator.canProceedFromBasicInfo())
            .opacity(coordinator.canProceedFromBasicInfo() ? 1 : 0.5)
        }
    }
}

struct MeasurementCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            content
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        }
    }
}
