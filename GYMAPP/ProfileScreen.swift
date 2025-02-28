import SwiftUI
import SwiftData
import Charts

struct ProfileScreen: View {
    @Query private var users: [User]
    @Query private var completedExercises: [CompletedExercise]
    
    @State private var selectedWeekOffset = 0
    
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    private var shortDateFormatter: DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM/dd"
        return fmt
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
    
    private var totalCaloriesToday: Double {
        todayExercises.map { $0.totalCaloriesBurned }.reduce(0, +)
    }
    
    private func weeklyCalories(for offsetInWeeks: Int) -> [DailyReps] {
        let calendar = Calendar.current
        
        guard let todayMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else {
            return []
        }
        
        guard let endDay = calendar.date(byAdding: .day, value: -(offsetInWeeks * 7), to: todayMidnight) else {
            return []
        }
        
        guard let startDay = calendar.date(byAdding: .day, value: -6, to: endDay) else {
            return []
        }

        let filteredExercises = completedExercises.filter { exercise in
            let exerciseDay = calendar.startOfDay(for: exercise.date)
            return exerciseDay >= startDay && exerciseDay <= endDay
        }
        
        var dailySums: [Date: Double] = [:]
        for exercise in filteredExercises {
            let day = calendar.startOfDay(for: exercise.date)
            dailySums[day, default: 0] += exercise.totalCaloriesBurned
        }
        
        var result: [DailyReps] = []
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startDay) {
                let sum = dailySums[day, default: 0]
                result.append(DailyReps(day: day, value: sum))
            }
        }
        
        return result
    }
    
    private func weeklyReps(for offsetInWeeks: Int) -> [DailyReps] {
        let calendar = Calendar.current
        
        guard let todayMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else {
            return []
        }
        
        guard let endDay = calendar.date(byAdding: .day, value: -(offsetInWeeks * 7), to: todayMidnight) else {
            return []
        }
        
        guard let startDay = calendar.date(byAdding: .day, value: -6, to: endDay) else {
            return []
        }

        let filteredExercises = completedExercises.filter { exercise in
            let exerciseDay = calendar.startOfDay(for: exercise.date)
            return exerciseDay >= startDay && exerciseDay <= endDay
        }
        
        var dailySums: [Date: Int] = [:]
        for exercise in filteredExercises {
            let day = calendar.startOfDay(for: exercise.date)
            dailySums[day, default: 0] += exercise.repetitions
        }

        var result: [DailyReps] = []
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startDay) {
                let sum = Double(dailySums[day, default: 0]) 
                result.append(DailyReps(day: day, value: sum))
            }
        }
        
        return result
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: geometry.size.height * 0.02) {
                    
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.12,
                                   height: geometry.size.width * 0.12)
                            .padding(.trailing, geometry.size.width * 0.025)
                            .accessibilityIdentifier("ProfileIcon")
                        
                        if let user = users.first {
                            Text(user.username)
                                .font(.system(size: geometry.size.width * 0.06))
                                .bold()
                                .accessibilityIdentifier("ProfileUsername")

                        }
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.03)
                    
                    Divider()
                    
                    Text("Calories Burned")
                        .font(.headline)
                        .font(.system(size: geometry.size.width * 0.05))
                        .accessibilityIdentifier("CaloriesBurnedTitle")

                    
                    Chart {
                        ForEach(weeklyCalories(for: selectedWeekOffset)) { entry in
                            BarMark(
                                x: .value("Day", entry.day, unit: .day),
                                y: .value("Calories", entry.value)
                            )
                            .foregroundStyle(Color.orange)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { value in
                            AxisValueLabel {
                                if let dateValue = value.as(Date.self) {
                                    Text(shortDateFormatter.string(from: dateValue))
                                        .font(.system(size: geometry.size.width * 0.035))
                                }
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel {
                                if let val = value.as(Double.self) {
                                    Text(String(format: "%.0f", val))
                                        .font(.system(size: geometry.size.width * 0.035))
                                }
                            }
                        }
                    }
                    .frame(height: geometry.size.height * 0.3)
                    .padding(.horizontal, geometry.size.width * 0.02)
                    .accessibilityIdentifier("CaloriesChart")

                    Text("Reps")
                        .font(.headline)
                        .font(.system(size: geometry.size.width * 0.05))
                        .accessibilityIdentifier("RepsTitle")

                    
                    Chart {
                        ForEach(weeklyReps(for: selectedWeekOffset)) { entry in
                            BarMark(
                                x: .value("Day", entry.day, unit: .day),
                                y: .value("Reps", entry.value)
                            )
                            .foregroundStyle(Color.blue)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { value in
                            AxisValueLabel {
                                if let dateValue = value.as(Date.self) {
                                    Text(shortDateFormatter.string(from: dateValue))
                                        .font(.system(size: geometry.size.width * 0.035))
                                }
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel {
                                if let val = value.as(Double.self) {
                                    Text(String(format: "%.0f", val))
                                        .font(.system(size: geometry.size.width * 0.035))
                                }
                            }
                        }
                    }
                    .frame(height: geometry.size.height * 0.3)
                    .padding(.horizontal, geometry.size.width * 0.02)
                    .accessibilityIdentifier("RepsChart")

                    HStack {
                        Button {
                            selectedWeekOffset += 1
                        } label: {
                            Label("Preview", systemImage: "chevron.left")
                            
                        }
                        .accessibilityIdentifier("PrevWeekButton")
                        Spacer()
                        
                        Button {
                            if selectedWeekOffset > 0 {
                                selectedWeekOffset -= 1
                            }
                        } label: {
                            Label("Next", systemImage: "chevron.right")
                        }
                        .accessibilityIdentifier("NextWeekButton")
                        .disabled(selectedWeekOffset == 0)
                        
                    }
                    .padding(.horizontal)
                    .accentColor(.gray)
                    
                    Divider()

                    if let user = users.first {
                        
                        let tileData: [TileData] = [
                            TileData(iconName: "waveform.path.ecg",
                                     value: "\(totalRepsToday)",
                                     label: "Reps (Today)"),
                            TileData(iconName: "checkmark",
                                     value: "\(totalExerciseTypesToday)",
                                     label: "Exercise Types (Today)"),
                            TileData(iconName: "flame",
                                     value: String(format: "%.0f", totalCaloriesToday),
                                     label: "Calories (Today)"),
                            TileData(iconName: "person",
                                     value: "\(user.level)",
                                     label: "Level"),
                            TileData(iconName: "scalemass",
                                     value: String(format: "%.1f", user.weight),
                                     label: "Weight (kg)"),
                            TileData(iconName: "arrow.up.and.down",
                                     value: String(format: "%.1f", user.height),
                                     label: "Height (cm)"),
                            TileData(iconName: "heart.circle",
                                     value: String(format: "%.1f", user.bmi),
                                     label: "BMI"),
                            TileData(iconName: "star.circle",
                                     value: user.bmiCategory,
                                     label: "BMI Category")
                        ]
                        
                        let columns = [
                            GridItem(.flexible(), spacing: geometry.size.width * 0.04),
                            GridItem(.flexible(), spacing: geometry.size.width * 0.04)
                        ]
                        
                        LazyVGrid(columns: columns, spacing: geometry.size.height * 0.02) {
                            ForEach(tileData) { tile in
                                TileView(iconName: tile.iconName,
                                         value: tile.value,
                                         label: tile.label,
                                         geometry: geometry)
                            }
                        }
                        .padding(.vertical, geometry.size.height * 0.02)
                        
                    } else {
                        Text("No user data available.")
                            .font(.system(size: geometry.size.width * 0.045))
                            .accessibilityIdentifier("NoUserDataLabel")
                    }
                    
                    Divider()

                    Text("Last 3 Exercises")
                        .font(.headline)
                        .font(.system(size: geometry.size.width * 0.05))
                        .accessibilityIdentifier("Last3ExercisesTitle")
                    
                    let lastThree = completedExercises
                        .sorted(by: { $0.date > $1.date })
                        .prefix(3)
                    
                    if lastThree.isEmpty {
                        Text("No completed exercises.")
                            .font(.system(size: geometry.size.width * 0.045))
                    } else {
                        VStack(alignment: .leading, spacing: geometry.size.height * 0.015) {
                            ForEach(lastThree) { exercise in
                                VStack(alignment: .leading,
                                       spacing: geometry.size.height * 0.005) {
                                    Text("Exercise: \(exercise.exerciseName)")
                                        .fontWeight(.bold)
                                        .font(.system(size: geometry.size.width * 0.045))
                                    
                                    Text("Reps: \(exercise.repetitions)")
                                        .font(.system(size: geometry.size.width * 0.04))
                                    
                                    Text("Date: \(dateFormatter.string(from: exercise.date))")
                                        .font(.system(size: geometry.size.width * 0.04))
                                    
                                    Text("Calories Burned: \(exercise.totalCaloriesBurned, specifier: "%.2f") kcal")
                                        .font(.system(size: geometry.size.width * 0.04))
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, geometry.size.width * 0.02)
                    }
                    
                    Spacer().frame(height: geometry.size.height * 0.02)
                }
                .padding()
            }
        }
        BottomMenu()
            .navigationBarBackButtonHidden(true)
    }
}


struct DailyReps: Identifiable {
    let id = UUID()
    let day: Date
    let value: Double
}

struct TileData: Identifiable {
    let id = UUID()
    let iconName: String
    let value: String
    let label: String
}


struct TileView: View {
    let iconName: String
    let value: String
    let label: String
    let geometry: GeometryProxy
    
    var backgroundColor: Color {
        switch label {
        case "BMI Category":
            switch value {
            case "Underweight":
                return Color.blue.opacity(0.2)
            case "Normal weight":
                return Color.green.opacity(0.2)
            case "Overweight":
                return Color.yellow.opacity(0.2)
            case "Obese":
                return Color.red.opacity(0.2)
            default:
                return Color.gray.opacity(0.2)
            }
        default:
            return Color.gray.opacity(0.2)
        }
    }
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.01) {
            Image(systemName: iconName)
                .font(.system(size: geometry.size.width * 0.07))
                .foregroundColor(.black)
            
            Text(value)
                .font(.system(size: geometry.size.width * 0.05))
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(label)
                .font(.system(size: geometry.size.width * 0.035))
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
