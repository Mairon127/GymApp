import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            VStack {
                Spacer()

                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.85, height: screenWidth * 0.85)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: screenWidth * 0.005)
                    )
                    .shadow(radius: screenWidth * 0.02)
                    .accessibilityIdentifier("Logo")

                Spacer()

                NavigationLink(destination: SignUpScreen()) {
                    Text("SIGN UP")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, screenWidth * 0.06)
                }
                .accessibilityIdentifier("SIGN UP")
                .padding(.bottom, screenHeight * 0.005)

                NavigationLink(destination: LoginScreen()) {
                    Text("LOGIN")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, screenWidth * 0.06)
                }
                .accessibilityIdentifier("LOGIN")
                Spacer()
            }
            .frame(width: screenWidth, height: screenHeight)
        }
        //.edgesIgnoringSafeArea(.all)
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
