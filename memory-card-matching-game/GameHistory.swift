import Foundation

// Struct to represent a single game record, conforming to Codable and Identifiable protocols
struct GameRecord: Codable, Identifiable {
    var id = UUID() // Unique identifier for each game record
    let date: Date // Date and time when the game was played
    let elapsedTime: Int // Elapsed time of the game in seconds
    let incorrectGuesses: Int // Number of incorrect guesses made during the game
    let score: Int // Final score of the game
}

// Class to manage the game history, observable for UI updates
class GameHistory: ObservableObject {
    @Published private(set) var records: [GameRecord] = [] { // Array of game records
        didSet {
            saveToUserDefaults() // Automatically save records when they are updated
        }
    }
    
    private let userDefaultsKey = "game_history" // Key used for saving and loading data from UserDefaults

    // Initializer that loads previously saved records from UserDefaults
    init() {
        loadFromUserDefaults()
    }
    
    // Function to add a new game record to the history
    func addRecord(elapsedTime: Int, incorrectGuesses: Int, score: Int) {
        let record = GameRecord(date: Date(), elapsedTime: elapsedTime, incorrectGuesses: incorrectGuesses, score: score)
        records.append(record) // Add the new record to the array
    }
    
    // Function to remove game records at specified offsets (used for UI delete operations)
    func removeRecord(at offsets: IndexSet) {
        records.remove(atOffsets: offsets) // Remove records at specified indices
    }
    
    // Function to clear all game records from the history
    func clearHistory() {
        print("Clear History button tapped") // Debugging message
        records = [] // Clear the records array
    }
    
    // Private function to save the records array to UserDefaults
    private func saveToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(records) { // Encode records to JSON
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey) // Save JSON data to UserDefaults
        }
    }
    
    // Private function to load the records array from UserDefaults
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey), // Retrieve JSON data from UserDefaults
           let decodedRecords = try? JSONDecoder().decode([GameRecord].self, from: data) { // Decode JSON data into records
            records = decodedRecords // Update the records array with the loaded data
        }
    }
    
    
}
