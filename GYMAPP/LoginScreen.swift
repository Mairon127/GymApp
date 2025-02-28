import SwiftUI
import SwiftData

struct LoginScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showError = false
    @State private var showSignUpScreen = false

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            NavigationView {
                VStack {
                    Spacer()
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenWidth * 0.85, height: screenWidth * 0.85) // 40% szerokości ekranu
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: screenWidth * 0.005)) // Dynamiczna grubość linii
                        .shadow(radius: screenWidth * 0.015)
                        .accessibilityIdentifier("LoginScreenLogo")
                    Spacer()
                    
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
                    
                    if showError {
                        Text("Invalid email or password")
                            .foregroundColor(.red)
                            .font(.system(size: screenWidth * 0.035))
                            .padding(.top, screenHeight * 0.01)
                            .accessibilityIdentifier("LoginErrorLabel")
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: MenuScreen(), isActive: $isLoggedIn) {
                        Button(action: loginUser) {
                            Text("LOGIN")
                                .font(.system(size: screenWidth * 0.045, weight: .bold))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(screenWidth * 0.02)
                                .padding(.horizontal, screenWidth * 0.05)
                        }
                        .accessibilityIdentifier("LOGIN")
                    }
                    Button(action: {
                        showSignUpScreen = true
                    }) {
                        Text("Don't have an account yet?")
                            .foregroundColor(.gray)
                            .underline()
                            .font(.system(size: screenWidth * 0.04))
                            .padding(.top, screenHeight * 0.01)
                            .accessibilityIdentifier("GoToSignUpButton")
                    }
                    .fullScreenCover(isPresented: $showSignUpScreen) {
                        SignUpScreen()
                    }
                    
                    Spacer()
                }
                .padding(.top, screenHeight * 0.02)
            }
            //.edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
        }
    }

    private func loginUser() {
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            print("Logged in as \(user.username)")
            isLoggedIn = true
        } else {
            showError = true
        }
    }
}

// Podgląd dla SwiftUI
struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .previewDevice("iPhone 16 Pro")
    }
}
