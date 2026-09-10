import SwiftUI

// ObservableObject class to manage a collection of themes
class ThemeCollectionManager: ObservableObject {
    
    // Published property to notify the SwiftUI view of changes to the theme collection
    @Published private var themeCollection: ThemeCollection {
        // Persist the theme collection to UserDefaults whenever it changes
        didSet {
            UserDefaults.standard.set(themeCollection.json, forKey: "theme-collection")
        }
    }

    // Initialize the theme collection by attempting to load it from UserDefaults.
    // If no saved data exists, initialize with a default ThemeCollection.
    init() {
        themeCollection = ThemeCollection(json: UserDefaults.standard.data(forKey: "theme-collection")) ?? ThemeCollection()
    }
    
    // Computed property to expose the list of themes to the SwiftUI views
    var themes: [ThemeCollection.Theme] { themeCollection.themes }
    
    // MARK: - Intents (User Actions)

    // Add a new theme to the collection
    func addTheme(name: String, accentColor: UIColor, emojiSet: [String]) {
        themeCollection.addTheme(name: name, accentColor: accentColor, emojiSet: emojiSet)
    }

    // Move a theme from one position to another within the collection
    func moveTheme(fromOffsets: IndexSet, toOffset: Int) {
        themeCollection.moveTheme(fromOffsets: fromOffsets, toOffset: toOffset)
    }

    // Edit an existing theme by its unique identifier (UUID)
    func editTheme(id: UUID, name: String, accentColor: UIColor, emojiSet: [String]) {
        themeCollection.editTheme(id: id, name: name, accentColor: accentColor, emojiSet: emojiSet)
    }

    // Reset the collection to its default themes
    func resetThemes() {
        themeCollection.resetThemes()
    }

    // Remove one or more themes from the collection at the specified offsets
    func removeTheme(atOffsets: IndexSet) {
        themeCollection.removeTheme(atOffsets: atOffsets)
    }
}
