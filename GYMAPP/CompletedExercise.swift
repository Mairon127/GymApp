import SwiftData
import Foundation

@Model
class CompletedExercise {
    @Attribute(.unique) var id: UUID
    var exerciseName: String
    var repetitions: Int
    var date: Date
    var caloriesPerRep: Double

    // ilość spalonych kalorii dla wykonanej ilości powtórzeń
    var totalCaloriesBurned: Double {
        return Double(repetitions) * caloriesPerRep
    }

    init(exerciseName: String, repetitions: Int, date: Date, caloriesPerRep: Double) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.repetitions = repetitions
        self.date = date
        self.caloriesPerRep = caloriesPerRep
    }
    func isValid() -> Bool {
            guard !exerciseName.isEmpty else {
                return false
            }
            guard repetitions > 0 else {
                return false
            }
            guard caloriesPerRep >= 0 else {
                return false
            }
            return true
        }
}


