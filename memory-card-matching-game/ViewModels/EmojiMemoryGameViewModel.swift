import SwiftUI
import Combine


// ViewModel for EmojiMemoryGame
class EmojiMemoryGameViewModel: ObservableObject {
    // Published properties to notify views of changes
    @Published private var model: GameModel.MemoryGame<String> // Reference to the MemoryGame model
    var theme: ThemeCollection.Theme // The current theme for the game
    @Published var elapsedTime: Int = 0 // Tracks the elapsed time of the game
    @Published var gameHistory = GameHistory() // Tracks the history of completed games

    // Timer properties
    private var timer: AnyCancellable? // Handles periodic time updates
    
    // Initializer that sets the theme and initializes the game model
    init(theme: ThemeCollection.Theme) {
        self.theme = theme
        model = EmojiMemoryGameViewModel.createMemoryGame(theme: theme)
    }
    
    // Static method to create a new MemoryGame model with the given theme
    private static func createMemoryGame(theme: ThemeCollection.Theme) -> GameModel.MemoryGame<String> {
        GameModel.MemoryGame<String>(numberOfPairsOfCards: theme.emojiSet.count) { pairIndex in
            theme.emojiSet[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: Array<GameModel.MemoryGame<String>.Card> {
        model.cards // Returns the cards from the model
    }
    
    var score: Int {
        model.score // Returns the current score
    }
    
    var incorrectGuesses: Int {
        model.incorrectGuesses // Returns the count of incorrect guesses
    }
    
    // MARK: - Intent
    
    // Handles card selection and game state updates
    func choose(card: GameModel.MemoryGame<String>.Card) {
        // Start the timer if it's not already running
        if timer == nil {
            startTimer()
        }
        // Pass the chosen card to the model
        model.choose(card: card)
        // If all cards are matched, stop the timer and save the game metrics
        if cards.allSatisfy({ $0.isMatched }) {
            stopTimer()
            saveCurrentGameToHistory()
        }
    }
    
    // Resets the game to its initial state
    func resetGame() {
        stopTimer() // Stop the timer
        elapsedTime = 0 // Reset elapsed time
        // Reinitialize the model with the current theme
        model = EmojiMemoryGameViewModel.createMemoryGame(theme: theme)
        objectWillChange.send() // Notify the views of the change
    }
    
    // Saves the current game metrics to the game history
    private func saveCurrentGameToHistory() {
        gameHistory.addRecord(elapsedTime: elapsedTime, incorrectGuesses: incorrectGuesses, score: score)
    }

    // Timer handling
    
    // Starts a timer to increment elapsed time every second
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.elapsedTime += 1
            }
    }

    // Stops the timer
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

// MemoryGame model implementation
enum GameModel {
    struct MemoryGame<CardContent> where CardContent: Equatable {
        private(set) var cards: [Card] // Array of cards in the game
        private(set) var score: Int = 0 // Tracks the player's score
        private(set) var incorrectGuesses: Int = 0 // Tracks the count of incorrect guesses

        // Constants for scoring
        private let INCORRECT_GUESS_PENALTY = 1 // Penalty for incorrect guesses

        // Handles card selection and scoring logic
        mutating func choose(card: Card) {
            // Find the index of the selected card
            if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
               !cards[chosenIndex].isFaceUp,
               !cards[chosenIndex].isMatched {

                // Check if there's already a face-up card to match against
                if let potentialMatchIndex = cards.indices.first(where: { cards[$0].isFaceUp && !cards[$0].isMatched }) {
                    if cards[potentialMatchIndex].content == card.content {
                        // Match found
                        cards[potentialMatchIndex].isMatched = true
                        cards[chosenIndex].isMatched = true
                        score += 4 // Award points for a correct match
                    } else {
                        // No match
                        incorrectGuesses += 1
                        score -= INCORRECT_GUESS_PENALTY // Deduct points for incorrect guess
                    }
                    // Flip down the previously selected card
                    cards[potentialMatchIndex].isFaceUp = false
                }

                // Flip the selected card
                cards[chosenIndex].isFaceUp = true
            }
        }

        // Initializes the MemoryGame with pairs of cards
        init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
            cards = [] // Start with an empty array of cards
            // Generate pairs of cards with unique content
            for pairIndex in 0..<numberOfPairsOfCards {
                let content = cardContentFactory(pairIndex)
                cards.append(Card(content: content, id: pairIndex * 2))
                cards.append(Card(content: content, id: pairIndex * 2 + 1))
            }
            cards.shuffle() // Shuffle the cards
        }

        // Represents a single card in the game
        struct Card: Identifiable {
            var isFaceUp = false // Indicates whether the card is face-up
            var isMatched = false // Indicates whether the card is matched
            let content: CardContent // The content of the card
            let id: Int // Unique identifier for the card
        }
    }
}
