import SwiftUI

struct ProfileView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 70, height: 70)
                            .overlay {
                                Text(initials)
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(.black)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userName)
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text(userEmail)
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Preferences") {
                    NavigationLink(destination: Text("Style Preferences")) {
                        Label("Style Preferences", systemImage: "paintbrush")
                    }
                    
                    NavigationLink(destination: Text("Notification Settings")) {
                        Label("Notifications", systemImage: "bell")
                    }
                }
                
                Section("Wardrobe") {
                    NavigationLink(destination: Text("Wardrobe Statistics")) {
                        Label("Statistics", systemImage: "chart.bar")
                    }
                    
                    NavigationLink(destination: Text("Collections")) {
                        Label("Collections", systemImage: "square.grid.2x2")
                    }
                }
                
                Section("About") {
                    NavigationLink(destination: Text("Help & Support")) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink(destination: Text("Privacy Policy")) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button(action: {
                        coordinator.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                                .foregroundColor(.red)
                                .font(.system(size: 17, weight: .medium))
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
    
    private var userName: String {
        if let email = SupabaseService.shared.currentUser?.email {
            return email.components(separatedBy: "@").first?.capitalized ?? "User"
        }
        return "User"
    }
    
    private var userEmail: String {
        SupabaseService.shared.currentUser?.email ?? ""
    }
    
    private var initials: String {
        let name = userName
        let components = name.components(separatedBy: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1))
        } else {
            return String(name.prefix(2))
        }
    }
}
