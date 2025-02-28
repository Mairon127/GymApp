import SwiftUI
import SwiftData

struct SettingsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    
    @State private var selectedGender: String = "Men"
    @State private var selectedAge: Int = 18
    @State private var selectedHeight: Double = 170.0
    @State private var selectedWeight: Double = 70.0
    @State private var selectedLevel: String = "Beginner"
    @State private var showSuccessMessage = false
    
    let levels = ["Beginner", "Intermediate", "Advanced"]
    let genders = ["Men", "Women"]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: geometry.size.height * 0.02) {
                            Spacer().frame(height: geometry.size.height * 0.02)
                            
                            // Ikona i tytuł
                            VStack(spacing: geometry.size.height * 0.01) {
                                Image(systemName: "person.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                                    .accessibilityIdentifier("SettingsIcon")
                                
                                Text("Enter parameters")
                                    .font(.system(size: geometry.size.width * 0.06, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .accessibilityIdentifier("EnterParametersTitle")
                            }
                            
                            Spacer().frame(height: geometry.size.height * 0.02)

                            HStack(spacing: geometry.size.width * 0.05) {
                                GenderButton(title: "Men", selected: $selectedGender, color: Color.blue, geometry: geometry)
                                    .accessibilityIdentifier("Men")
                                GenderButton(title: "Women", selected: $selectedGender, color: Color.pink, geometry: geometry)
                                    .accessibilityIdentifier("Women")
                            }
                            
                            Spacer().frame(height: geometry.size.height * 0.02)

                            VStack(spacing: geometry.size.height * 0.015) {
                                ParameterTile(
                                    label: "Age",
                                    picker: AnyView(
                                        Picker("Age", selection: $selectedAge) {
                                            ForEach(16...100, id: \.self) { age in
                                                Text("\(age)").tag(age)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        .accentColor(.white)
                                        .foregroundColor(.white)
                                        .accessibilityIdentifier("AgePicker")
                                    ),
                                    geometry: geometry
                                )

                                ParameterSliderTile(
                                    label: "Height",
                                    value: Int(selectedHeight),
                                    range: 100...250,
                                    step: 1,
                                    bindingValue: $selectedHeight,
                                    unit: "cm",
                                    geometry: geometry
                                )
                                .accessibilityIdentifier("HeightSliderTile")

                                ParameterSliderTile(
                                    label: "Weight",
                                    value: Int(selectedWeight),
                                    range: 30...200,
                                    step: 1,
                                    bindingValue: $selectedWeight,
                                    unit: "kg",
                                    geometry: geometry
                                )
                                .accessibilityIdentifier("WeightSliderTile")

                                ParameterTile(
                                    label: "Level",
                                    picker: AnyView(
                                        Picker("Level", selection: $selectedLevel) {
                                            ForEach(levels, id: \.self) { level in
                                                Text(level).tag(level)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        .accentColor(.white)
                                        .foregroundColor(.white)
                                        .accessibilityIdentifier("LevelPicker")
                                    ),
                                    geometry: geometry
                                )
                            }
                            
                            Spacer().frame(height: geometry.size.height * 0.02)

                            Button(action: saveParameters) {
                                Text("Save Parameters")
                                    .font(.system(size: geometry.size.width * 0.05, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .cornerRadius(8)
                                    .padding(.horizontal, geometry.size.width * 0.08)
                            }
                            .accessibilityIdentifier("SaveParametersButton")
                            .alert(isPresented: $showSuccessMessage) {
                                Alert(
                                    title: Text("Success"),
                                    message: Text("Your parameters have been saved successfully."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                            
                            Spacer().frame(height: geometry.size.height * 0.02)
                        }
                        .padding(.top, geometry.size.height * 0.02)
                    }

                    BottomMenu()
                        .padding(.top, geometry.size.height * 0.01)
                }
                .onAppear {
                    loadUserData()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func loadUserData() {
        guard let currentUser = users.first else { return }
        selectedGender = currentUser.gender
        selectedAge = currentUser.age
        selectedHeight = currentUser.height
        selectedWeight = currentUser.weight
        selectedLevel = currentUser.level
    }
    
    private func saveParameters() {
        guard let currentUser = users.first else {
            print("No user found to update.")
            return
        }
        
        currentUser.gender = selectedGender
        currentUser.age = selectedAge
        currentUser.height = selectedHeight
        currentUser.weight = selectedWeight
        currentUser.level = selectedLevel
        
        do {
            try modelContext.save()
            showSuccessMessage = true
        } catch {
            print("Failed to save user data: \(error.localizedDescription)")
        }
    }
}

struct GenderButton: View {
    let title: String
    @Binding var selected: String
    let color: Color
    let geometry: GeometryProxy
    
    var body: some View {
        Button(action: {
            selected = title
        }) {
            HStack {
                Image(systemName: title == "Men" ? "figure.run" : "figure.walk")
                    .foregroundColor(.white)
                    .font(.system(size: geometry.size.width * 0.06))
                Text(title)
                    .font(.system(size: geometry.size.width * 0.045, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding()
            .frame(height: geometry.size.height * 0.07)
            .frame(minWidth: geometry.size.width * 0.35)
            .background(selected == title ? color : color.opacity(0.5))
            .cornerRadius(10)
        }
    }
}

struct ParameterTile: View {
    let label: String
    let picker: AnyView
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            BlackTileBackground()
            HStack {
                Text("\(label) :")
                    .font(.system(size: geometry.size.width * 0.045, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                picker
            }
            .padding(.horizontal, geometry.size.width * 0.04)
            .padding(.vertical, geometry.size.height * 0.01)
        }
        .padding(.horizontal, geometry.size.width * 0.07)
    }
}

struct ParameterSliderTile: View {
    let label: String
    let value: Int
    let range: ClosedRange<Double>
    let step: Double
    @Binding var bindingValue: Double
    let unit: String
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            BlackTileBackground()
            VStack(alignment: .leading, spacing: geometry.size.height * 0.005) {
                HStack {
                    Text("\(label) :")
                        .font(.system(size: geometry.size.width * 0.045, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(value) \(unit)")
                        .font(.system(size: geometry.size.width * 0.04, weight: .regular))
                        .foregroundColor(.white)
                }
                Slider(value: $bindingValue, in: range, step: step)
                    .accentColor(.white)
                    .accessibilityIdentifier("\(label)Slider")
            }
            .padding(.horizontal, geometry.size.width * 0.04)
            .padding(.vertical, geometry.size.height * 0.01)
        }
        .padding(.horizontal, geometry.size.width * 0.07)
    }
}

struct BlackTileBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray)
    }
}


struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .previewDevice("iPhone 16 Pro")
    }
}
