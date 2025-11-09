import SwiftUI

@main
struct AIWardrobeApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
        }
    }
}
