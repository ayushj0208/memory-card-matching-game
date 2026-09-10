import Foundation

// A generic MemoryGame structure where CardContent must be equatable to compare card contents
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card> // Array to hold all cards in the game
    private(set) var score: Int = 0 // Tracks the player's score
    private(set) var incorrectGuesses: Int = 0 // Tracks the number of incorrect guesses

    // Index of the single face-up card, if there is only one face-up card
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set {
            // Flip all cards face down except the one at the given index
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }

    // Handles logic for choosing a card
    mutating func choose(card: Card) {
        // Find the index of the chosen card and ensure it can be flipped
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {

            // Check if there is another face-up card for a potential match
            if let potentialMatchIndex = cards.indices.first(where: { cards[$0].isFaceUp && !cards[$0].isMatched }) {
                if cards[potentialMatchIndex].content == cards[chosenIndex].content {
                    // Cards match: mark both as matched
                    cards[potentialMatchIndex].isMatched = true
                    cards[chosenIndex].isMatched = true
                } else {
                    // Cards don't match: flip the other card face down
                    cards[potentialMatchIndex].isFaceUp = false
                }
            }

            // Flip the chosen card face up
            cards[chosenIndex].isFaceUp = true
        }
    }

    // Initialize the game with a specified number of pairs of cards
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        // Create pairs of cards with unique content
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2)) // Add the first card
            cards.append(Card(content: content, id: pairIndex * 2 + 1)) // Add the matching card
        }
        cards.shuffle() // Shuffle the cards for randomness
    }

    // Reset the count of incorrect guesses
    mutating func resetIncorrectGuesses() {
        incorrectGuesses = 0
    }

    // Accessor for retrieving the number of incorrect guesses
    func getIncorrectGuesses() -> Int {
        return incorrectGuesses
    }

    // Nested structure to represent a single card in the game
    struct Card: Identifiable {
        var isFaceUp: Bool = false { // Track if the card is face up
            didSet {
                if isFaceUp {
                    startUsingBonusTime() // Start tracking bonus time if face up
                } else {
                    stopUsingBonusTime() // Stop tracking bonus time if face down
                }
            }
        }

        var isMatched: Bool = false { // Track if the card has been matched
            didSet {
                stopUsingBonusTime() // Stop tracking bonus time if matched
            }
        }

        var content: CardContent // The content of the card (e.g., emoji, number)
        var id: Int // Unique identifier for the card

        // Bonus time-related properties
        var bonusTimeLimit: TimeInterval = 3 // Limit for bonus time

        private var faceUpTime: TimeInterval { // Total time the card has been face up
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        var lastFaceUpDate: Date? // Last time the card was flipped face up
        var pastFaceUpTime: TimeInterval = 0 // Cumulative face-up time

        var bonusTimeRemaining: TimeInterval { // Remaining bonus time
            max(0, bonusTimeLimit - faceUpTime)
        }

        var bonusRemaining: Double { // Fraction of bonus time remaining
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }

        var hasEarnedBonus: Bool { // Check if bonus points can be awarded
            isMatched && bonusTimeRemaining > 0
        }

        var isConsumingBonusTime: Bool { // Check if bonus time is currently being used
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // Start tracking bonus time
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        // Stop tracking bonus time
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }

    // MARK: - Constants
    let MATCH_POINT_CHANGE = 4 // Points awarded for a match
    let MISMATCH_POINT_CHANGE = -1 // Points deducted for a mismatch
}
