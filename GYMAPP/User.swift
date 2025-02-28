import SwiftData
import SwiftUI

@Model
class User {
    @Attribute(.unique) var email: String
    var username: String
    var password: String
    var age: Int
    var height: Double
    var weight: Double
    var level: String
    var gender: String
    
    var bmi: Double {
        weight / pow(height / 100.0, 2)
    }

    var bmiCategory: String {
        switch gender.lowercased() {
        case "male", "m":
            switch bmi {
            case ..<18.5:
                return "Underweight"
            case 18.5..<25:
                return "Normal weight"
            case 25..<30:
                return "Overweight"
            default:
                return "Obese"
            }
        case "female", "f":
            switch bmi {
            case ..<18.0:
                return "Underweight"
            case 18.0..<24:
                return "Normal weight"
            case 24..<29:
                return "Overweight"
            default:
                return "Obese"
            }
        default:
            // Domyślne progi, jeśli płeć nie jest określona
            switch bmi {
            case ..<18.5:
                return "Underweight"
            case 18.5..<25:
                return "Normal weight"
            case 25..<30:
                return "Overweight"
            default:
                return "Obese"
            }
        }
    }

    init(
        email: String,
        username: String,
        password: String,
        age: Int = 20,
        height: Double = 180.00,
        weight: Double = 70.00,
        level: String = "Beginner",
        gender: String = "Not specified"
    ) {
        self.email = email
        self.username = username
        self.password = password
        self.age = age
        self.height = height
        self.weight = weight
        self.level = level
        self.gender = gender
    }
    func isValid() -> Bool {
            guard !email.isEmpty else {
                return false
            }
            guard age > 0 else {
                return false
            }
            guard height > 0 else {
                return false
            }
            guard weight > 0 else {
                return false
            }
            return true
        }

}
