import SwiftUI

// A structure to define the default themes for the memory card matching game.
struct DefaultThemes {

    // Theme 0: Fruits in Basket
    // This theme uses a pink accent color and contains fruit emojis.
    static let theme0 = ThemeCollection.Theme (
        name: "Fruits in Basket", // Theme name
        accentColor: UIColor(Color.pink), // Accent color: pink
        emojiSet: ["🍎", "🍊", "🍋", "🍌", "🍉", "🍇"] // Emojis representing fruits
    )
    
    // Theme 1: Animals in Zoo
    // This theme uses an orange accent color and contains animal emojis.
    static let theme1 = ThemeCollection.Theme (
        name: "Animals in Zoo", // Theme name
        accentColor: UIColor(Color.orange), // Accent color: orange
        emojiSet: ["🦊", "🐻", "🐼", "🐨", "🐯", "🦁"] // Emojis representing zoo animals
    )
    
    // Theme 2: Balls on Playground
    // This theme uses a yellow accent color and contains ball-related emojis.
    static let theme2 = ThemeCollection.Theme (
        name: "Balls on Playground", // Theme name
        accentColor: UIColor(Color.yellow), // Accent color: yellow
        emojiSet: ["⚽️", "🏀", "🏈", "🎾", "🏐", "🎱"] // Emojis representing different balls
    )
    
    // Theme 3: Vegetables on Farm
    // This theme uses a green accent color and contains vegetable emojis.
    static let theme3 = ThemeCollection.Theme (
        name: "Vegetables on Farm", // Theme name
        accentColor: UIColor(Color.green), // Accent color: green
        emojiSet: ["🥦","🥬","🥒","🫑","🌽","🍆"] // Emojis representing farm vegetables
    )
    
    // Theme 4: Countries in World
    // This theme uses a blue accent color and contains flag emojis of various countries.
    static let theme4 = ThemeCollection.Theme (
        name: "Countries in World", // Theme name
        accentColor: UIColor(Color.blue), // Accent color: blue
        emojiSet: ["🇨🇦", "🇺🇸", "🇨🇳", "🇫🇷", "🇷🇺", "🇬🇧"] // Emojis representing flags of different countries
    )
    
    // Theme 5: Vehicles on Road
    // This theme uses a purple accent color and contains vehicle emojis.
    static let theme5 = ThemeCollection.Theme (
        name: "Vehicles on Road", // Theme name
        accentColor: UIColor(Color.purple), // Accent color: purple
        emojiSet: ["🚎","🛵","🚕","🚓","🚑","🚚","🚒"] // Emojis representing various vehicles
    )
}
