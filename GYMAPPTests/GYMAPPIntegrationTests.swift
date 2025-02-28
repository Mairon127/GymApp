import XCTest
@testable import GYMAPP

final class GYMAPPIntegrationTests: XCTestCase {

    // Test przepływu rejestracji i logowania użytkownika
    func testUserRegistrationAndLoginFlow() throws {
        let user = User(email: "test@example.com",
                        username: "testuser",
                        password: "securepassword",
                        age: 25,
                        height: 180.0,
                        weight: 75.0,
                        level: "Intermediate",
                        gender: "male")

        // Sprawdzenie danych użytkownika
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.username, "testuser")

        // Obliczanie BMI i kategorii BMI
        let expectedBMI = user.weight / ((user.height / 100) * (user.height / 100))
        XCTAssertEqual(user.bmi, expectedBMI, accuracy: 0.01)
        XCTAssertEqual(user.bmiCategory, "Normal weight")
    }

    // Test dodawania nowego ćwiczenia
    func testAddingNewExercise() throws {
        let exercise = CompletedExercise(
            exerciseName: "Push Ups",
            repetitions: 15,
            date: Date(),
            caloriesPerRep: 0.5
        )

        // Sprawdzenie nazwy i liczby powtórzeń
        XCTAssertEqual(exercise.exerciseName, "Push Ups")
        XCTAssertEqual(exercise.repetitions, 15)

        // Sprawdzenie poprawności wyliczania spalonych kalorii
        XCTAssertEqual(exercise.totalCaloriesBurned, 7.5, accuracy: 0.01)

        // Sprawdzenie poprawności walidacji
        XCTAssertTrue(exercise.isValid())
    }

    /// Test sprawdza, czy po zmianie danych użytkownika (np. w SettingsScreen) poprawnie aktualizują się atrybuty.
    func testUserParametersUpdateFlow() throws {
        // Tworzymy użytkownika
        let user = User(email: "update@example.com",
                        username: "Updater",
                        password: "oldPass",
                        age: 30,
                        height: 170.0,
                        weight: 65.0,
                        level: "Beginner",
                        gender: "female")

        // Symulacja zmiany parametrów (np. w SettingsScreen)
        user.height = 165.0
        user.weight = 60.0
        user.age = 31
        user.level = "Intermediate"
        user.gender = "male"

        // Sprawdzamy, czy po zmianie parametrów zmieniły się obliczenia BMI i kategorii
        XCTAssertEqual(user.height, 165.0)
        XCTAssertEqual(user.weight, 60.0)
        XCTAssertEqual(user.age, 31)
        XCTAssertEqual(user.level, "Intermediate")
        XCTAssertEqual(user.gender, "male")

        // Nowe BMI
        let expectedNewBMI = user.weight / pow(user.height / 100.0, 2)
        XCTAssertEqual(user.bmi, expectedNewBMI, accuracy: 0.01)
    }

    /// Test sprawdza, czy ćwiczenia dodane do listy lub bazy danych użytkownika dają poprawny bilans spalonych kalorii.
    func testUserExercisesCaloriesIntegration() throws {
        // Użytkownik
        let user = User(email: "calories@example.com",
                        username: "CalUser",
                        password: "1234",
                        age: 25,
                        height: 175.0,
                        weight: 70.0,
                        level: "Beginner",
                        gender: "female")

        // Lista wykonanych ćwiczeń (przykładowo)
        let exercise1 = CompletedExercise(exerciseName: "Squats",
                                          repetitions: 30,
                                          date: Date(),
                                          caloriesPerRep: 0.3)

        let exercise2 = CompletedExercise(exerciseName: "Push Ups",
                                          repetitions: 20,
                                          date: Date(),
                                          caloriesPerRep: 0.5)

        // W sumie: (30 * 0.3) + (20 * 0.5) = 9 + 10 = 19 kcal
        let totalBurned = exercise1.totalCaloriesBurned + exercise2.totalCaloriesBurned
        XCTAssertEqual(totalBurned, 19.0, accuracy: 0.01)
    }

    /// Test sprawdza, czy próba rejestracji użytkownika z niepoprawnymi danymi (np. pusty e-mail) jest blokowana.
    func testUserRegistrationInvalidDataFlow() throws {
        let invalidUser = User(email: "",
                               username: "Invalid",
                               password: "1234",
                               age: 25,
                               height: 180.0,
                               weight: 70.0,
                               level: "Beginner",
                               gender: "male")

        // Oczekujemy, że taki user będzie niepoprawny
        XCTAssertFalse(invalidUser.isValid(), "User with empty email should not pass validation")
    }

    func testAddingHighRepetitionExercise() throws {
        let exercise = CompletedExercise(
            exerciseName: "MarathonPushUps",
            repetitions: 10_000,
            date: Date(),
            caloriesPerRep: 0.2
        )

        XCTAssertTrue(exercise.isValid(), "Exercise with large repetition count should still be valid if > 0")

        // Sprawdzenie, czy kalkulacja spalonych kalorii nie powoduje błędu
        let expectedCalories = Double(10_000) * 0.2
        XCTAssertEqual(exercise.totalCaloriesBurned, expectedCalories, accuracy: 0.001)
    }
}
