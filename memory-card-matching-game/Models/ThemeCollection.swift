import SwiftUI

// Represents a collection of themes, conforming to Codable for JSON encoding/decoding.
struct ThemeCollection: Codable {
    // Array to hold the themes in the collection.
    var themes = [Theme]()
    
    // Nested struct representing an individual theme.
    struct Theme: Identifiable, Codable {
        var name: String // Name of the theme.
        var accentColor: UIColor.RGB // The accent color of the theme, stored as RGB.
        var emojiSet: [String] // Set of emojis associated with the theme.
        var id = UUID() // Unique identifier for each theme.
        
        // Initializer for Theme.
        init(name: String, accentColor: UIColor, emojiSet: [String]) {
            self.name = name
            self.accentColor = accentColor.rgb // Convert UIColor to RGB for encoding.
            self.emojiSet = emojiSet
        }
    }
    
    // Computed property to encode the theme collection to JSON.
    var json: Data? {
        return try? JSONEncoder().encode(self) // Attempts to encode `self` into JSON.
    }
    
    // Failable initializer to decode a ThemeCollection from JSON data.
    init?(json: Data?) {
        if json != nil, let newThemeCollection = try? JSONDecoder().decode(ThemeCollection.self, from: json!) {
            self = newThemeCollection // Decode successfully and assign.
        } else {
            return nil // Return nil if decoding fails.
        }
    }
    
    // Default initializer to populate with predefined themes.
    init() {
        self.themes = [
            DefaultThemes.theme0,
            DefaultThemes.theme1,
            DefaultThemes.theme2,
            DefaultThemes.theme3,
            DefaultThemes.theme4,
            DefaultThemes.theme5
        ]
    }
    
    // Method to add a new theme to the collection.
    mutating func addTheme(name: String, accentColor: UIColor, emojiSet: [String]) {
        themes.append(Theme(name: name, accentColor: accentColor, emojiSet: emojiSet))
    }
    
    // Method to reorder themes in the collection.
    mutating func moveTheme(fromOffsets: IndexSet, toOffset: Int) {
        themes.move(fromOffsets: fromOffsets, toOffset: toOffset)
    }
    
    // Method to edit an existing theme by its ID.
    mutating func editTheme(id: UUID, name: String, accentColor: UIColor, emojiSet: [String]) {
        for index in themes.indices {
            if themes[index].id == id {
                themes[index].name = name // Update name.
                themes[index].accentColor = accentColor.rgb // Update accent color.
                themes[index].emojiSet = emojiSet // Update emoji set.
            }
        }
    }
    
    // Method to reset the themes collection to default themes.
    mutating func resetThemes() {
        self.themes = [
            DefaultThemes.theme0,
            DefaultThemes.theme1,
            DefaultThemes.theme2,
            DefaultThemes.theme3,
            DefaultThemes.theme4,
            DefaultThemes.theme5
        ]
    }
    
    // Method to remove a theme at specific offsets.
    mutating func removeTheme(atOffsets: IndexSet) {
        themes.remove(atOffsets: atOffsets)
    }
}
