import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationView {
            WelcomeScreen()
                .accessibilityIdentifier("WelcomeScreen")
            ProfileScreen()
                .accentColor(.gray)
            
        }
        
        
    }
}
