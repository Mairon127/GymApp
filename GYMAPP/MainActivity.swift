import SwiftUI
import SwiftData

@main
struct GYMAPP: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, CompletedExercise.self]) 
        
        
    }
}
