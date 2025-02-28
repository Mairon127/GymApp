import SwiftUI
import SwiftData

struct ExerciseScreen: View {
    var exercise: Exercise
    @State private var value: Int = 0
    @State private var currentDate = Date()
    @State private var showAlert = false

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            ScrollView {
                VStack(spacing: screenHeight * 0.02) {
                    // Header with exercise name
                    Text(exercise.name)
                        .font(.system(size: screenWidth * 0.07, weight: .bold))
                        .padding(.top, screenHeight * 0.01)
                        .frame(width: screenWidth * 0.9, alignment: .center)
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("ExerciseName")
                    
                    Image(exercise.detailedImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth * 0.85, height: screenHeight * 0.6)
                        .cornerRadius(screenWidth * 0.05)
                        .padding(.horizontal, screenWidth * 0.005)
                        .accessibilityIdentifier("ExerciseImage")

                    VStack(alignment: .leading, spacing: screenHeight * 0.001) {
                        Text("Exercise description:")
                            .font(.system(size: screenWidth * 0.05, weight: .semibold))
                        
                        Text(exercise.description)
                            .font(.system(size: screenWidth * 0.04))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(screenHeight * 0.005)
                            .accessibilityIdentifier("ExerciseDescription")
                    }
                    .padding(.horizontal, screenWidth * 0.08)

                    
                    VStack(spacing: screenHeight * 0.01) {
                        Text("Repetitions")
                            .font(.system(size: screenWidth * 0.05, weight: .semibold))
                        
                        HStack(spacing: screenWidth * 0.05) {
                            Button(action: {
                                if value > 0 {
                                    value -= 1
                                }
                            }) {
                                Text("−")
                                    .font(.system(size: screenWidth * 0.07))
                                    .frame(width: screenWidth * 0.12, height: screenWidth * 0.12)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(screenWidth * 0.03)
                            }
                            .accessibilityIdentifier("MinusButton")

                            Text("\(value)")
                                .font(.system(size: screenWidth * 0.05, weight: .medium))
                                .frame(width: screenWidth * 0.15)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("RepsCountLabel")

                            Button(action: {
                                value += 1
                            }) {
                                Text("+")
                                    .font(.system(size: screenWidth * 0.07))
                                    .frame(width: screenWidth * 0.12, height: screenWidth * 0.12)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(screenWidth * 0.03)
                            }
                            .accessibilityIdentifier("PlusButton")
                        }
                    }
                    .padding(.vertical, screenHeight * 0.02)

                    Button(action: {
                        let log = CompletedExercise(
                            exerciseName: exercise.name,
                            repetitions: value,
                            date: currentDate,
                            caloriesPerRep: exercise.caloriesPerRep
                        )
                        modelContext.insert(log)
                        do {
                            try modelContext.save()
                            print("Saved successfully!")

                            value = 0

                            showAlert = true
                        } catch {
                            print("Save error: \(error)")
                        }
                    }) {
                        Text("Send")
                            .font(.system(size: screenWidth * 0.05, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: screenWidth * 0.6)
                            .background(Color.green)
                            .cornerRadius(screenWidth * 0.04)
                    }
                    .accessibilityIdentifier("SendButton")
                    .padding(.top, screenHeight * 0.02)

                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text("Your exercise data has been sent successfully."),
                            dismissButton: .default(Text("OK"))
                        )
                    }

                    Spacer()
                }
                .frame(width: screenWidth, alignment: .center)
            }
            .padding(.bottom, screenHeight * 0.02)
            .navigationBarBackButtonHidden(true)
            
        }
        // .edgesIgnoringSafeArea(.all)
        BottomMenu()
    }
}
