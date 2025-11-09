import Foundation

struct UserProfile: Codable {
    let userId: UUID
    var height: Int? // in cm
    var weight: Int? // in kg
    var age: Int?
    var preferredStyles: [StylePreference]
    var preferredColors: [String]
    var measurementUnit: MeasurementUnit
    
    enum MeasurementUnit: String, Codable {
        case metric
        case imperial
    }
    
    enum StylePreference: String, Codable, CaseIterable {
        case casual = "Casual"
        case formal = "Formal"
        case sporty = "Sporty"
        case elegant = "Elegant"
        case streetwear = "Streetwear"
        case minimalist = "Minimalist"
        case bohemian = "Bohemian"
        case vintage = "Vintage"
    }
    
    // Helper computed properties for imperial units
    var heightInFeet: Int? {
        guard let height = height else { return nil }
        return Int(Double(height) / 30.48)
    }
    
    var heightInInches: Int? {
        guard let height = height else { return nil }
        let totalInches = Double(height) / 2.54
        let feet = Int(totalInches / 12)
        return Int(totalInches) - (feet * 12)
    }
    
    var weightInPounds: Int? {
        guard let weight = weight else { return nil }
        return Int(Double(weight) * 2.20462)
    }
}
