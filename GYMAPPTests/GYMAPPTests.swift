import XCTest
@testable import GYMAPP

final class GYMAPPUserTests: XCTestCase {
    
    func testBMICalculation() {
        let user = User(email: "test@example.com", username: "TestUser", password: "1234",
                        age: 25, height: 180, weight: 75, level: "Intermediate", gender: "Male")
        XCTAssertEqual(user.bmi, 23.15, accuracy: 0.01, "BMI calculation is incorrect")
    }
    
    func testBMICategory() {
        let user = User(email: "abcd@gmail.com", username: "Abcd", password: "abcd",
                        age: 25, height: 180, weight: 90, level: "Intermediate", gender: "Male")
        XCTAssertEqual(user.bmiCategory, "Overweight", "BMI category calculation is incorrect")
    }
    
    func testInvalidUserAge() {
        let user = User(email: "test@example.com", username: "TestUser", password: "1234",
                        age: -5, height: 180, weight: 75, level: "Beginner", gender: "Female")
        XCTAssertFalse(user.isValid(), "User with negative age should not be valid")
    }
    
    func testTotalCaloriesBurned() {
        let exercise = CompletedExercise(exerciseName: "Push-ups", repetitions: 20, date: Date(),
                                         caloriesPerRep: 0.5)
        XCTAssertEqual(exercise.totalCaloriesBurned, 10.0, "Total calories burned calculation is incorrect")
    }
    
    // Test sprawdza, czy kategoria BMI dla płci żeńskiej jest odpowiednio obliczana.
    func testBMICategoryForFemale() {
        let user = User(email: "fem@example.com", username: "FemUser", password: "1234",
                        age: 30, height: 165, weight: 70, level: "Intermediate", gender: "Female")
        XCTAssertEqual(user.bmiCategory, "Overweight", "Female BMI category calculation is incorrect")
    }
    
    func testEmptyEmailUserValidation() {
        let user = User(email: "", username: "NoEmail", password: "pass123",
                        age: 20, height: 170, weight: 60, level: "Beginner", gender: "Male")
        XCTAssertFalse(user.isValid(), "User with empty email should not be valid")
    }
    
    func testCompletedExerciseEmptyName() {
        let exercise = CompletedExercise(exerciseName: "",
                                         repetitions: 10,
                                         date: Date(),
                                         caloriesPerRep: 0.4)
        // Zakładamy, że isValid() zwraca false, jeśli exerciseName jest pusty.
        XCTAssertFalse(exercise.isValid(), "Exercise with empty name should be invalid")
    }
    
    func testCompletedExerciseZeroRepetitions() {
        let exercise = CompletedExercise(exerciseName: "Squats",
                                         repetitions: 0,
                                         date: Date(),
                                         caloriesPerRep: 0.2)
        XCTAssertFalse(exercise.isValid(), "Exercise with zero repetitions should be invalid")
    }
    
    func testUserLevelUpdate() {
        let user = User(email: "update@example.com", username: "Updater", password: "pass",
                        age: 25, height: 175, weight: 70, level: "Beginner", gender: "Male")
        
        user.level = "Advanced"
        
        XCTAssertEqual(user.level, "Advanced", "User level update did not persist correctly")
    }
}
