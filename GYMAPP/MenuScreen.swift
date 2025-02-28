import SwiftUI
import SwiftData

struct MenuScreen: View {
    @State private var selectedBodyPart = "Full Body"
    
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    
    let bodyParts = ["Full Body", "Upper Body", "Lower Body", "Core"]
    
    //parametr caloriesPerRep do każdego ćwiczenia
    let exercises: [String: [Exercise]] = [
        "Upper Body": [
            Exercise(imageName: "Weightlifting", detailedImageName: "Weightlifting-1", name: "WEIGHTLIFTING", description: """
Weightlifting is a strength-training exercise that uses weights, such as barbells or dumbbells, to build muscle and improve overall strength.
**How to Perform:**
1. Choose the appropriate weight and a barbell or dumbbells.
2. Stand with your feet shoulder-width apart.
3. Engage your core, maintain a straight back, and lift the weight using your legs and hips.
4. Lower the weight slowly and under control.
**Tips:** Start with light weights and focus on form before progressing to heavier loads.
""", difficulty: "Advanced", caloriesPerRep: 0.6),
            Exercise(imageName: "Pull-Up", detailedImageName: "Pull-Up-1", name: "PULL-UPS", description: """
Pull-Up is a bodyweight exercise that primarily targets the upper body muscles, including the back, shoulders, and biceps, to build strength and enhance muscle definition.
**How to Perform:**
1. Grip a pull-up bar with your palms facing away from you and hands slightly wider than shoulder-width apart.
2. Hang with your arms fully extended and legs off the ground.
3. Engage your core and pull your body upward until your chin is above the bar.
4. Lower yourself back down slowly and under control to the starting position.
**Tips:** If you're unable to perform a full pull-up, use an assisted pull-up machine or resistance bands to help support your weight.
""", difficulty: "Intermediate", caloriesPerRep: 0.5),
            Exercise(imageName: "Push-Up", detailedImageName: "Push-Up-1", name: "PUSH-UPS", description: """
Push-Up is a fundamental bodyweight exercise that targets the chest, shoulders, triceps, and core muscles to build upper body strength and improve muscular endurance.
**How to Perform:**
1. Start in a high plank position with your hands placed slightly wider than shoulder-width apart.
2. Keep your body in a straight line from head to heels, engaging your core.
3. Lower your body by bending your elbows until your chest nearly touches the floor.
4. Push back up to the starting position, fully extending your arms.
**Tips:** Maintain a straight back and avoid sagging your hips. If a full push-up is too challenging, perform knee push-ups or incline push-ups to build strength.
""", difficulty: "Beginner", caloriesPerRep: 0.4),
            Exercise(imageName: "Battle_Rope", detailedImageName: "Battle-Rope-1", name: "BATTLE ROPE", description: """
Battle Rope is a dynamic strength and conditioning exercise that uses heavy ropes to improve muscular endurance, cardiovascular fitness, and coordination.
**How to Perform:**
1. Anchor a battle rope to a secure point and stand with your feet shoulder-width apart, holding one end of the rope in each hand.
2. Engage your core and maintain a slight bend in your knees.
3. Create waves by rapidly moving your arms up and down, keeping your shoulders relaxed.
4. Continue the motion for the desired duration, maintaining consistent speed and intensity.
**Tips:** Focus on generating power from your shoulders and core rather than just your arms. Start with shorter intervals and gradually increase the duration as your endurance improves.
""", difficulty: "Intermediate", caloriesPerRep: 0.3),
        ],
        "Lower Body": [
            Exercise(imageName: "Squats", detailedImageName: "Squats-1", name: "SQUATS", description: """
Squats are a fundamental lower body exercise that targets the quadriceps, hamstrings, glutes, and core muscles to build leg strength and improve overall stability.
**How to Perform:**
1. Stand with your feet shoulder-width apart, toes pointing slightly outward.
2. Engage your core and keep your chest up, maintaining a straight back.
3. Bend your knees and hips to lower your body as if sitting back into a chair, keeping your weight on your heels.
4. Lower down until your thighs are parallel to the ground, then push through your heels to return to the starting position.
**Tips:** Ensure your knees track over your toes and do not extend past them. Start with bodyweight squats to master the form before adding weights.
""", difficulty: "Beginner", caloriesPerRep: 0.3),
            Exercise(imageName: "Lunges", detailedImageName: "Lunges-1", name: "LUNGES", description: """
Lunges are an effective lower body exercise that targets the quadriceps, hamstrings, glutes, and calves, enhancing balance and leg strength.
**How to Perform:**
1. Stand upright with your feet hip-width apart and hands on your hips or holding weights at your sides.
2. Take a step forward with one foot, lowering your hips until both knees are bent at about a 90-degree angle.
3. Ensure your front knee is directly above your ankle and does not extend past your toes.
4. Push through the heel of your front foot to return to the starting position.
5. Repeat on the other leg, alternating sides for each rep.
**Tips:** Keep your torso upright and engage your core to maintain balance. Start with bodyweight lunges and add weights as you become more comfortable.
""", difficulty: "Intermediate", caloriesPerRep: 0.4),
            Exercise(imageName: "Deadlift", detailedImageName: "Deadlift-1", name: "DEADLIFT", description: """
Deadlift is a compound strength-training exercise that targets the entire posterior chain, including the hamstrings, glutes, lower back, and traps, to build overall strength and muscle mass.
**How to Perform:**
1. Stand with your feet hip-width apart, with a barbell positioned over the mid-foot.
2. Bend at your hips and knees to grip the barbell with hands shoulder-width apart, using an overhand or mixed grip.
3. Engage your core, keep your back straight, and lift the bar by extending your hips and knees simultaneously.
4. Stand upright with shoulders back and hips fully extended.
5. Lower the bar back to the ground by hinging at the hips and bending the knees, maintaining control.
**Tips:** Keep the bar close to your body throughout the movement to reduce strain on your lower back. Start with lighter weights to perfect your form before increasing the load.
""", difficulty: "Advanced", caloriesPerRep: 0.7),
        ],
        "Core": [
            Exercise(imageName: "Russian_Twist", detailedImageName: "Russian-Twist-1", name: "RUSSIAN TWIST", description: """
Russian Twist is a core exercise that targets the obliques and enhances rotational strength and stability.
**How to Perform:**
1. Sit on the ground with your knees bent and feet flat, holding a weight or medicine ball in front of your chest.
2. Lean back slightly, keeping your back straight and engaging your core.
3. Rotate your torso to the right, bringing the weight beside your hip.
4. Return to the center and then rotate to the left side.
5. Continue alternating sides for the desired number of reps.
**Tips:** Keep your movements controlled and avoid using momentum. For added difficulty, lift your feet off the ground or use a heavier weight.
""", difficulty: "Intermediate", caloriesPerRep: 0.25),
            Exercise(imageName: "Plank", detailedImageName: "Plank-1", name: "PLANK", description: """
Plank is a fundamental core stabilization exercise that targets the abdominal muscles, lower back, and shoulders to improve overall core strength and endurance.
**How to Perform:**
1. Start in a forearm plank position with your elbows directly under your shoulders and forearms flat on the ground.
2. Extend your legs behind you, balancing on your toes, and keep your body in a straight line from head to heels.
3. Engage your core and hold the position for the desired duration, maintaining steady breathing.
4. Avoid letting your hips sag or rise; keep your body aligned throughout.
**Tips:** Focus on maintaining proper form rather than holding the position for extended periods. If needed, perform the plank on your knees to reduce intensity.
""", difficulty: "Beginner", caloriesPerRep: 0.1),
            Exercise(imageName: "Mountain_Climbers", detailedImageName: "Mountain-Climbers-1", name: "MOUNTAIN CLIMBERS", description: """
Mountain Climbers are a high-intensity core exercise that also engages the shoulders, chest, and legs, enhancing cardiovascular endurance and muscular strength.
**How to Perform:**
1. Start in a high plank position with your hands directly under your shoulders and body in a straight line.
2. Bring one knee toward your chest, keeping your core engaged and hips level.
3. Quickly switch legs, extending one leg back while bringing the other knee forward.
4. Continue alternating legs at a rapid pace, maintaining a steady rhythm.
**Tips:** Keep your core tight and avoid letting your hips drop. Focus on maintaining a consistent speed while controlling your movements.
""", difficulty: "Advanced", caloriesPerRep: 0.3),
        ]
    ]
    
    func filteredExercises(for bodyPart: String, userLevel: String?) -> [Exercise] {
        let selectedExercises = bodyPart == "Full Body" ? exercises.values.flatMap { $0 } : exercises[bodyPart] ?? []
        guard let level = userLevel else { return [] }
        return selectedExercises.filter { $0.difficulty == level }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            NavigationStack {
                VStack {
                    let user = users.first
                    Picker("Select Body Part", selection: $selectedBodyPart) {
                        ForEach(bodyParts, id: \.self) { part in
                            Text(part)
                                .accessibilityIdentifier("BodyPart-\(part)")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.gray)
                    .padding(screenWidth * 0.05)
                    .font(.system(size: screenWidth * 0.045))
                    .accessibilityIdentifier("PickerBodyPart")
                    
                    ScrollView {
                        VStack(spacing: screenHeight * 0.02) {
                            let displayedExercises = filteredExercises(for: selectedBodyPart, userLevel: user?.level)
                            
                            if displayedExercises.isEmpty {
                                Text("No exercises available for your level.")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(screenWidth * 0.05)
                                    .font(.system(size: screenWidth * 0.04))
                                    .accessibilityIdentifier("NoExercisesLabel")
                            } else {
                                ForEach(displayedExercises, id: \.id) { exercise in
                                    NavigationLink(destination: ExerciseScreen(exercise: exercise)) {
                                        ExerciseRow(imageName: exercise.imageName, exerciseName: exercise.name, difficulty: exercise.difficulty)
                                            .frame(width: screenWidth * 0.9)
                                    }
                                    .accessibilityIdentifier(exercise.name)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    BottomMenu()
                        .frame(width: screenWidth, height: screenHeight * 0.07, alignment: .bottom)
                }
                .padding(.top, screenHeight * 0.02)

            }
            //.edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .accessibilityIdentifier("MenuScreenContainer")

        }
    }
}

struct Exercise: Identifiable {
    let id = UUID()
    let imageName: String
    let detailedImageName: String
    let name: String
    let description: String
    let difficulty: String
    let caloriesPerRep: Double
}

struct ExerciseRow: View {
    var imageName: String
    var exerciseName: String
    var difficulty: String
    
    private func difficultyStars(for difficulty: String) -> String {
        switch difficulty {
        case "Beginner":
            return "★☆☆"
        case "Intermediate":
            return "★★☆"
        case "Advanced":
            return "★★★"
        default:
            return "☆☆☆"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fill)
                    .frame(height: screenHeight * 0.95)
                    .clipped()
                    .accessibilityIdentifier("ExerciseRowImage-\(exerciseName)")
                
                VStack {
                    HStack {
                        Spacer()
                        Text(difficultyStars(for: difficulty))
                            .font(.system(size: screenWidth * 0.06))
                            .foregroundColor(.yellow)
                            .padding(screenWidth * 0.02)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(5)
                            .padding([.top, .trailing], screenWidth * 0.02)
                            .accessibilityIdentifier("DifficultyStars-\(exerciseName)")
                    }
                    Spacer()
                    HStack {
                        Text(exerciseName)
                            .font(.system(size: screenWidth * 0.06, weight: .bold))
                            .foregroundColor(.white)
                            .padding(screenWidth * 0.02)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(5)
                            .padding([.leading, .bottom], screenWidth * 0.02)
                            .accessibilityIdentifier("ExerciseRowName-\(exerciseName)")

                        Spacer()
                    }
                }
            }
            .cornerRadius(screenWidth * 0.03)
            .shadow(radius: screenWidth * 0.02)
        }
        .frame(height: 200)
    }
}

struct MenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        MenuScreen()
            .modelContainer(for: User.self)
    }
}

