import SwiftUI

struct MainTabView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WardrobeView(coordinator: coordinator)
                .tabItem {
                    Label("Wardrobe", systemImage: "tshirt")
                }
                .tag(0)
            
            OutfitsView(coordinator: coordinator)
                .tabItem {
                    Label("Outfits", systemImage: "sparkles")
                }
                .tag(1)
            
            ProfileView(coordinator: coordinator)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(2)
        }
        .accentColor(.black)
    }
}
