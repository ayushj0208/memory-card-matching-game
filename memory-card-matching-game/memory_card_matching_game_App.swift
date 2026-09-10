import SwiftUI

// Entry point of the SwiftUI application
@main
struct memory_card_matching_game_App: App {
    var body: some Scene {
        // Defines the main scene of the application
        WindowGroup {
            // Launches the ThemeSelectionView as the initial view
            // and injects a ThemeCollectionManager instance
            ThemeSelectionView(tcManager: ThemeCollectionManager())
        }
    }
}
