import SwiftUI
import SwiftData

struct SignUpScreen: View {
    @Environment(\.modelContext) private var modelContext
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var showLoginScreen = false

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            ScrollView {
                VStack {
                    Spacer()
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenWidth * 0.85, height: screenWidth * 0.85)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: screenWidth * 0.005))
                        .shadow(radius: screenWidth * 0.015)
                        .padding(.top, screenHeight * 0.02)
                        .accessibilityIdentifier("SignUpScreenLogo")

                    Spacer(minLength: screenHeight * 0.02)
                    
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(screenWidth * 0.02)
                        .padding(.horizontal, screenWidth * 0.05)
                        .font(.system(size: screenWidth * 0.045))
                        .autocapitalization(.none)
                        .accessibilityIdentifier("Username")

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(screenWidth * 0.02)
                        .padding(.horizontal, screenWidth * 0.05)
                        .font(.system(size: screenWidth * 0.045))
                        .accessibilityIdentifier("Email")

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(screenWidth * 0.02)
                        .padding(.horizontal, screenWidth * 0.05)
                        .font(.system(size: screenWidth * 0.045))
                        .accessibilityIdentifier("Password")

                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(screenWidth * 0.02)
                        .padding(.horizontal, screenWidth * 0.05)
                        .font(.system(size: screenWidth * 0.045))
                        .accessibilityIdentifier("ConfirmPassword")

                    if showError {
                        Text("Passwords do not match or invalid data")
                            .foregroundColor(.red)
                            .font(.system(size: screenWidth * 0.035))
                            .padding(.top, screenHeight * 0.01)
                            .accessibilityIdentifier("SignUpErrorLabel")
                    }

                    Spacer(minLength: screenHeight * 0.02)

                    Button(action: registerUser) {
                        Text("SIGN UP")
                            .font(.system(size: screenWidth * 0.045, weight: .bold))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray) // Original gray color
                            .foregroundColor(.white)
                            .cornerRadius(screenWidth * 0.02)
                            .padding(.horizontal, screenWidth * 0.05)
                    }
                    .accessibilityIdentifier("SIGN UP")
                    .padding(.top, screenHeight * 0.02)

                    Button(action: {
                        showLoginScreen = true
                    }) {
                        Text("Do you have an account?")
                            .foregroundColor(.gray)
                            .underline()
                            .font(.system(size: screenWidth * 0.04))
                            .padding(.top, screenHeight * 0.01)
                            .accessibilityIdentifier("GoToLoginButton")
                    }
                    .padding(.bottom, screenHeight * 0.02)

                }
                .padding(.top, screenHeight * 0.02)
                .frame(width: screenWidth, alignment: .center)
            }
            .ignoresSafeArea(edges: .bottom)
            .fullScreenCover(isPresented: $showLoginScreen) {
                LoginScreen()
            }
            .navigationBarBackButtonHidden(true)
        }
        //.edgesIgnoringSafeArea(.all)
    }

    private func registerUser() {
        // Reset error before validation
        showError = false

        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            showError = true
            return
        }

        // Email format validation
        guard isValidEmail(email) else {
            showError = true
            return
        }

        let newUser = User(email: email, username: username, password: password)
        do {
            try modelContext.insert(newUser)
            print("User registered successfully")
            showLoginScreen = true
        } catch {
            print("Error registering user: \(error)")
            showError = true
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}

// Preview for SwiftUI
struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
