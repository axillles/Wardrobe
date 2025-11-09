import SwiftUI

struct HeightPickerView: View {
    @Binding var height: Int?
    @State private var selectedCm: Int = 170
    
    let cmRange = 140...220
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Height", selection: $selectedCm) {
                ForEach(Array(cmRange), id: \.self) { cm in
                    Text("\(cm) cm")
                        .font(.system(size: 20))
                        .tag(cm)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)
            .onChange(of: selectedCm) { newValue in
                height = newValue
            }
        }
        .onAppear {
            if let currentHeight = height {
                selectedCm = currentHeight
            } else {
                height = selectedCm
            }
        }
    }
}

struct WeightPickerView: View {
    @Binding var weight: Int?
    @State private var selectedKg: Int = 70
    
    let kgRange = 40...150
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Weight", selection: $selectedKg) {
                ForEach(Array(kgRange), id: \.self) { kg in
                    Text("\(kg) kg")
                        .font(.system(size: 20))
                        .tag(kg)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)
            .onChange(of: selectedKg) { newValue in
                weight = newValue
            }
        }
        .onAppear {
            if let currentWeight = weight {
                selectedKg = currentWeight
            } else {
                weight = selectedKg
            }
        }
    }
}

struct AgePickerView: View {
    @Binding var age: Int?
    @State private var selectedAge: Int = 25
    
    let ageRange = 13...100
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Age", selection: $selectedAge) {
                ForEach(Array(ageRange), id: \.self) { age in
                    Text("\(age) years")
                        .font(.system(size: 20))
                        .tag(age)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)
            .onChange(of: selectedAge) { newValue in
                age = newValue
            }
        }
        .onAppear {
            if let currentAge = age {
                selectedAge = currentAge
            } else {
                age = selectedAge
            }
        }
    }
}
