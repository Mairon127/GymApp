import SwiftUI
import SwiftData

struct NotificationsScreen: View {
    @Query private var completedExercises: [CompletedExercise]
    
    private var challenges: [Challenge] {
        [
            Challenge(name: "Burn 300 kcal in 24h",
                      goal: 300,
                      progress: totalCaloriesToday,
                      unit: "kcal"),
            Challenge(name: "Complete 50 repetitions",
                      goal: 50,
                      progress: totalRepsToday,
                      unit: "reps"),
            Challenge(name: "Perform 10 types of exercises",
                      goal: 10,
                      progress: totalExerciseTypesToday,
                      unit: "types")
        ]
    }
    
    
    private var todayExercises: [CompletedExercise] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        return completedExercises.filter { $0.date >= startOfDay }
    }
    
    private var totalRepsToday: Int {
        todayExercises.map { $0.repetitions }.reduce(0, +)
    }
    
    private var totalExerciseTypesToday: Int {
        let uniqueExercises = Set(todayExercises.map { $0.exerciseName })
        return uniqueExercises.count
    }
    
    private var totalCaloriesToday: Int {
        Int(todayExercises.map { $0.totalCaloriesBurned }.reduce(0, +))
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            NavigationView {
                VStack(spacing: screenHeight * 0.02) {
                
                    Text("Notifications")
                        .font(.system(size: screenWidth * 0.07, weight: .bold))
                        .padding(.top, screenHeight * 0.02)
                        .frame(width: screenWidth * 0.9, alignment: .center)
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("NotificationsTitle")

                    ScrollView {
                        VStack(spacing: screenHeight * 0.015) {
                            
                            
                            Image("notification")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: screenWidth * 0.9, height: screenHeight * 0.5)
                                .cornerRadius(screenWidth * 0.02)
                                .padding(.horizontal, screenWidth * 0.05)
                                .padding(.bottom, screenHeight * 0.02)
                                .accessibilityIdentifier("NotificationsImage")
                            
                            // Karty wyzwań
                            ForEach(challenges) { challenge in
                                NotificationCard(challenge: challenge, screenWidth: screenWidth, screenHeight: screenHeight)
                                    .padding(.horizontal, screenWidth * 0.05)
                            }
                        }
                        .padding(.vertical, screenHeight * 0.02)
                    }
                    
                    Spacer()
                    
                    BottomMenu()
                        .frame(width: screenWidth, height: screenHeight * 0.07, alignment: .bottom)
                }
                .background(Color.gray.opacity(0.1))
                .frame(width: screenWidth, height: screenHeight)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct NotificationCard: View {
    let challenge: Challenge
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    var progressFraction: CGFloat {
        min(CGFloat(challenge.progress) / CGFloat(challenge.goal), 1.0)
    }
    
    var progressColor: Color {
        progressFraction >= 1.0 ? .green : .blue
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            Text(challenge.name)
                .font(.system(size: screenWidth * 0.05, weight: .semibold))
                .accessibilityIdentifier("ChallengeName-\(challenge.name)")
            
            Text("Goal: \(challenge.goal) \(challenge.unit)")
                .font(.system(size: screenWidth * 0.04))
                .foregroundColor(.gray)
                .accessibilityIdentifier("ChallengeGoal-\(challenge.name)")
            
            ProgressView(value: progressFraction)
                .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                .frame(height: screenHeight * 0.01) 
                .accessibilityIdentifier("ChallengeProgress-\(challenge.name)")
            
            HStack {
                Text("Progress: \(challenge.progress)/\(challenge.goal) \(challenge.unit)")
                    .font(.system(size: screenWidth * 0.035))
                    .foregroundColor(progressColor)
                    .accessibilityIdentifier("ChallengeProgressLabel-\(challenge.name)")
                
                Spacer()
                
                if progressFraction >= 1.0 {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: screenWidth * 0.05))
                        .accessibilityIdentifier("ChallengeCompleted-\(challenge.name)")
                }
            }
        }
        .padding(screenWidth * 0.04)
        .background(
            RoundedRectangle(cornerRadius: screenWidth * 0.02)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
        )
    }
}

struct Challenge: Identifiable {
    let id = UUID()
    let name: String
    let goal: Int
    let progress: Int
    let unit: String
}

struct NotificationsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsScreen()
            .previewDevice("iPhone 16 Pro")
    }
}
