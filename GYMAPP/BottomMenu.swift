import SwiftUI

struct BottomMenu: View {
    var body: some View {
        HStack {
            Spacer()
            NavigationLink(destination: MenuScreen()) {
                VStack {
                    Image(systemName: "house")
                        .font(.largeTitle)
                    Text("Home")
                        .font(.caption)
                }
            }
            .accessibilityIdentifier("HomeButton")
            Spacer()
            NavigationLink(destination: NotificationsScreen()) {
                VStack {
                    Image(systemName: "bell")
                        .font(.largeTitle)
                    Text("Notification")
                        .font(.caption)
                }
            }
            .accessibilityIdentifier("NotificationButton")
            Spacer()
            NavigationLink(destination: SettingsScreen()) {
                VStack {
                    Image(systemName: "gearshape")
                        .font(.largeTitle)
                    Text("Settings")
                        .font(.caption)
                }
            }
            .accessibilityIdentifier("SettingsButton")
            Spacer()
            NavigationLink(destination: ProfileScreen()) {
                VStack {
                    Image(systemName: "person.crop.circle")
                        .font(.largeTitle)
                    Text("Profile")
                        .font(.caption)
                }
            }
            .accessibilityIdentifier("ProfileButton")
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .accentColor(.gray)
    }
}

