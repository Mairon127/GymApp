import XCTest

final class GYMAPPUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    /// Test sprawdzający, czy ekran powitalny (WelcomeScreen) wyświetla podstawowe elementy.
    func testWelcomeScreenUIElements() throws {
        // Sprawdzamy, czy obraz/logo jest widoczne
        let logo = app.images["Logo"] // Upewnij się, że w SwiftUI: .accessibilityIdentifier("Logo") albo .accessibilityLabel("Logo")
        XCTAssertTrue(logo.waitForExistence(timeout: 3), "Logo nie jest widoczne na ekranie powitalnym.")
        
        // Sprawdzamy przycisk SIGN UP
        let signUpButton = app.buttons["SIGN UP"] // .accessibilityIdentifier("SIGN UP")
        XCTAssertTrue(signUpButton.waitForExistence(timeout: 3), "Przycisk SIGN UP nie jest widoczny.")
        
        // Sprawdzamy przycisk LOGIN
        let loginButton = app.buttons["LOGIN"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 3), "Przycisk LOGIN nie jest widoczny.")
    }
    
    /// Test przejścia z ekranu powitalnego do ekranu rejestracji (SignUpScreen).
    func testNavigateToSignUpScreen() throws {
        let signUpButton = app.buttons["SIGN UP"]
        XCTAssertTrue(signUpButton.waitForExistence(timeout: 2))
        signUpButton.tap()
        
        // Sprawdzamy, czy pojawił się jakiś charakterystyczny element ekranu rejestracji, np. textField "Username"
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.waitForExistence(timeout: 3), "Pole tekstowe Username nie pojawiło się po przejściu do SignUpScreen.")
    }
    
    /// Test próby rejestracji z niepoprawnie wypełnionymi danymi.
    func testSignUpWithInvalidData() throws {
        // Przechodzimy na ekran rejestracji
        let signUpButton = app.buttons["SIGN UP"]
        signUpButton.tap()
        
        // Wypełniamy dane błędne (np. e-mail bez '@')
        let usernameTextField = app.textFields["Username"]
        let emailTextField = app.textFields["Email"]
        let passwordSecureField = app.secureTextFields["Password"]
        let confirmPasswordSecureField = app.secureTextFields["Confirm Password"]
        
        // Wprowadzamy dane
        usernameTextField.tap()
        usernameTextField.typeText("TestUser")
        
        emailTextField.tap()
        emailTextField.typeText("bademail.com")
        
        passwordSecureField.tap()
        passwordSecureField.typeText("12345678")
        
        confirmPasswordSecureField.tap()
        confirmPasswordSecureField.typeText("87654321") // Celowo inne hasło
        
        // Tap na finalny przycisk rejestracji
        let registerButton = app.buttons["SIGN UP"] // lub "SIGN UP" o innej etykiecie
        registerButton.tap()
        
        // Oczekujemy pojawienia się komunikatu o błędzie
        // Załóżmy, że label o błędzie to "Passwords do not match or invalid data"
        let errorLabel = app.staticTexts["Passwords do not match or invalid data"]
        XCTAssertTrue(errorLabel.waitForExistence(timeout: 2), "Komunikat o błędzie się nie pojawił.")
    }
    
    /// Test przejścia z ekranu powitalnego do logowania (LoginScreen).
    func testNavigateToLoginScreen() throws {
        let loginButton = app.buttons["LOGIN"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 2))
        loginButton.tap()
        
        // Sprawdzamy, czy pojawił się textField Email
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 3), "Pole tekstowe Email nie pojawiło się po przejściu na LoginScreen.")
    }
    
    /// Test logowania z poprawnymi danymi (przykład).
    func testLoginWithValidCredentials() throws {
        // Przechodzimy na ekran logowania
        let loginButton = app.buttons["LOGIN"]
        loginButton.tap()
        
        // Wprowadzamy poprawne dane
        let emailTextField = app.textFields["Email"]
        let passwordSecureField = app.secureTextFields["Password"]
        
        emailTextField.tap()
        emailTextField.typeText("abcd@gmail.com")
        
        passwordSecureField.tap()
        passwordSecureField.typeText("abcd")
        
        // Wciskamy przycisk LOGIN
        let loginButtonFinal = app.buttons["LOGIN"]
        loginButtonFinal.tap()
        
        let menuContainer = app.otherElements["MenuScreenContainer"]
        XCTAssertTrue(menuContainer.waitForExistence(timeout: 5),
                      "Nie przeszliśmy do MenuScreen po poprawnym logowaniu.")
    }
    
    /// Test sprawdzający, czy w BottomMenu znajdują się cztery przyciski (Home, Notification, Settings, Profile).
    func testBottomMenuButtonsExist() throws {
        //    Sprawdzamy, czy widać przycisk LOGIN.
        let welcomeLoginButton = app.buttons["LOGIN"]
        if welcomeLoginButton.waitForExistence(timeout: 3) {
            welcomeLoginButton.tap()
   
            let emailTextField = app.textFields["Email"]
            XCTAssertTrue(emailTextField.waitForExistence(timeout: 3), "Nie widać pola Email.")
            emailTextField.tap()
            emailTextField.typeText("abcd@gmail.com")
            
            let passwordSecureField = app.secureTextFields["Password"]
            XCTAssertTrue(passwordSecureField.waitForExistence(timeout: 3), "Nie widać pola Password.")
            passwordSecureField.tap()
            passwordSecureField.typeText("abcd")
            
            let finalLoginButton = app.buttons["LOGIN"]
            XCTAssertTrue(finalLoginButton.waitForExistence(timeout: 3), "Nie znaleziono przycisku LOGIN na ekranie logowania.")
            finalLoginButton.tap()
        }
        else {
            print("Wygląda na to, że już nie jesteśmy na WelcomeScreen.")
        }
        
        //    Sprawdzamy istnienie przycisków:
        let homeButton = app.buttons["HomeButton"]
        let notificationButton = app.buttons["NotificationButton"]
        let settingsButton = app.buttons["SettingsButton"]
        let profileButton = app.buttons["ProfileButton"]
        
        XCTAssertTrue(homeButton.waitForExistence(timeout: 5), "Przycisk Home nie został odnaleziony.")
        XCTAssertTrue(notificationButton.waitForExistence(timeout: 5), "Przycisk Notification nie został odnaleziony.")
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Przycisk Settings nie został odnaleziony.")
        XCTAssertTrue(profileButton.waitForExistence(timeout: 5), "Przycisk Profile nie został odnaleziony.")
    }
    
    /// Test nawigacji do ekranu powiadomień (NotificationsScreen).
    func testBottomMenuNavigationToNotifications() throws {
        let welcomeLoginButton = app.buttons["LOGIN"]
        if welcomeLoginButton.waitForExistence(timeout: 3) {
            welcomeLoginButton.tap()
           
            let emailField = app.textFields["Email"]
            XCTAssertTrue(emailField.waitForExistence(timeout: 3),
                          "Nie znaleziono pola 'Email' na LoginScreen.")
            emailField.tap()
            emailField.typeText("abcd@gmail.com")
            
            let passwordField = app.secureTextFields["Password"]
            XCTAssertTrue(passwordField.waitForExistence(timeout: 3),
                          "Nie znaleziono pola 'Password' na LoginScreen.")
            passwordField.tap()
            passwordField.typeText("abcd")
            
            let finalLoginButton = app.buttons["LOGIN"]
            XCTAssertTrue(finalLoginButton.waitForExistence(timeout: 3),
                          "Nie znaleziono finalnego przycisku LOGIN na LoginScreen.")
            finalLoginButton.tap()
        } else {
            print("Wygląda na to, że aplikacja nie pokazuje WelcomeScreen – może już jesteśmy zalogowani.")
        }

        //    Sprawdzamy, czy pojawia się HomeButton z BottomMenu.
        let homeButton = app.buttons["HomeButton"]
        XCTAssertTrue(homeButton.waitForExistence(timeout: 5),
                      "Brak HomeButton – prawdopodobnie nadal nie mamy dolnego menu.")
        
        let notificationButton = app.buttons["NotificationButton"]
        XCTAssertTrue(notificationButton.waitForExistence(timeout: 3),
                      "Nie znaleziono przycisku NotificationButton w dolnym menu.")
        notificationButton.tap()
        
        let notificationsTitle = app.staticTexts["Notifications"]
        XCTAssertTrue(notificationsTitle.waitForExistence(timeout: 3),
                      "Nie udało się przejść do ekranu Notifications.")
    }
    
    /// Test wypełnienia i zapisu parametrów w SettingsScreen.
    func testFillAndSaveSettings() throws {
        let welcomeLoginButton = app.buttons["LOGIN"]
        if welcomeLoginButton.waitForExistence(timeout: 3) {
            welcomeLoginButton.tap()
            
            let emailField = app.textFields["Email"]
            XCTAssertTrue(emailField.waitForExistence(timeout: 3),
                          "Nie znaleziono pola 'Email' na LoginScreen.")
            emailField.tap()
            emailField.typeText("abcd@gmail.com")
            
            let passwordField = app.secureTextFields["Password"]
            XCTAssertTrue(passwordField.waitForExistence(timeout: 3),
                          "Nie znaleziono pola 'Password' na LoginScreen.")
            passwordField.tap()
            passwordField.typeText("abcd")
            
            let finalLoginButton = app.buttons["LOGIN"]
            XCTAssertTrue(finalLoginButton.waitForExistence(timeout: 3),
                          "Nie znaleziono finalnego przycisku LOGIN na LoginScreen.")
            finalLoginButton.tap()
        } else {
            print("Wygląda na to, że aplikacja nie pokazuje WelcomeScreen – być może już jesteśmy zalogowani.")
        }
        
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5),
                      "Nie znaleziono SettingsButton. Prawdopodobnie nie jesteśmy na ekranie z BottomMenu.")
        settingsButton.tap()

        let menButton = app.buttons["Men"]
        let womenButton = app.buttons["Women"]
        
        if menButton.exists {
            menButton.tap()
        } else {
            womenButton.tap()
        }
        
        // Obsługa slidera
        let weightSlider = app.sliders["WeightSliderTile"]
        if weightSlider.waitForExistence(timeout: 5) {
            // Przestawiamy suwak np. na 30% zakresu
            weightSlider.adjust(toNormalizedSliderPosition: 0.3)
        }
        
        let heightSlider = app.sliders["HeightSliderTile"]
        if heightSlider.waitForExistence(timeout: 5) {
            // Przestawiamy suwak np. na 10% zakresu
            heightSlider.adjust(toNormalizedSliderPosition: 0.1)
        }
        
        let saveButton = app.buttons["Save Parameters"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5),
                      "Przycisk zapisu parametrów nie istnieje na ekranie Settings.")
        saveButton.tap()
        
        let successAlert = app.alerts["Success"]
        XCTAssertTrue(successAlert.waitForExistence(timeout: 5),
                      "Alert sukcesu zapisu parametrów nie pojawił się.")
        
        successAlert.buttons["OK"].tap()
    }
    
    /// Test wprowadzenia liczby powtórzeń i zapisania (wysłania) ćwiczenia.
    func testCompleteAnExercise() throws {
        let welcomeLoginButton = app.buttons["LOGIN"]
        if welcomeLoginButton.waitForExistence(timeout: 3) {
            welcomeLoginButton.tap()
            
            let emailField = app.textFields["Email"]
            XCTAssertTrue(emailField.waitForExistence(timeout: 3),
                          "Nie znaleziono pola 'Email' na LoginScreen.")
            emailField.tap()
            emailField.typeText("abcd@gmail.com")  // Twój testowy mail
            
            let passwordField = app.secureTextFields["Password"]
            XCTAssertTrue(passwordField.waitForExistence(timeout: 3),
                          "Nie znaleziono pola 'Password' na LoginScreen.")
            passwordField.tap()
            passwordField.typeText("abcd")             // Twoje testowe hasło
            
            // Klikamy drugi przycisk LOGIN
            let finalLoginButton = app.buttons["LOGIN"]
            XCTAssertTrue(finalLoginButton.waitForExistence(timeout: 3),
                          "Nie znaleziono finalnego przycisku LOGIN na LoginScreen.")
            finalLoginButton.tap()
        } else {
            print("Wygląda na to, że aplikacja nie pokazuje WelcomeScreen – być może już jesteśmy zalogowani.")
        }
        
        let homeButton = app.buttons["HomeButton"]
        XCTAssertTrue(homeButton.waitForExistence(timeout: 5),
                      "Brak HomeButton – prawdopodobnie MenuScreen (z dolnym menu) nie jest wyświetlony.")
        
        let pushUpsButton = app.staticTexts["PUSH-UPS"]
        XCTAssertTrue(pushUpsButton.waitForExistence(timeout: 5),
                      "Nie znaleziono ćwiczenia 'PUSH-UPS' na liście.")
        pushUpsButton.tap()
        
        let plusButton = app.buttons["+"]
        XCTAssertTrue(plusButton.waitForExistence(timeout: 3),
                      "Nie znaleziono przycisku '+' na ExerciseScreen.")
        plusButton.tap()
        plusButton.tap()
        // Teraz licznik powinien wynosić 2
        
        let sendButton = app.buttons["Send"]
        XCTAssertTrue(sendButton.exists,
                      "Przycisk 'Send' nie istnieje na ExerciseScreen.")
        sendButton.tap()
        

        let successAlert = app.alerts["Success"]
        XCTAssertTrue(successAlert.waitForExistence(timeout: 3),
                      "Alert sukcesu nie pojawił się po zapisaniu ćwiczenia.")
        
        successAlert.buttons["OK"].tap()
    }
}
