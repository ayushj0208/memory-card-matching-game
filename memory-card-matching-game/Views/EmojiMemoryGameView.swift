import SwiftUI
import CoreMotion
import SpriteKit

// Main view for the Emoji Memory Game
struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGameViewModel // Observed object to bind view with the ViewModel
    @Environment(\.colorScheme) var colorScheme // Detect system's light or dark mode
    @State private var motionManager = CMMotionManager() // CoreMotion manager to handle accelerometer updates
    @State private var resetTriggered = false // Flag to prevent multiple resets in quick succession

    var body: some View {
        VStack {
            // Display time elapsed and incorrect guesses
            HStack {
                Text("Time: \(viewModel.elapsedTime) seconds")
                    .font(.headline)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Text("Incorrect Guesses: \(viewModel.incorrectGuesses)")
                    .font(.headline)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? .red : .black)
            }

            // Grid layout to display cards
            Grid(items: viewModel.cards) { card in
                CardView(card: card)
                    .padding(5)
                    .onTapGesture {
                        // Handle card selection with animation
                        withAnimation(.easeInOut(duration: 0.5)) {
                            viewModel.choose(card: card)
                        }
                    }
            }
            .padding()
            .foregroundColor(Color(viewModel.theme.accentColor))

            // Button to start a new game
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.resetGame()
                }
            }, label: {
                Text("New Game")
                    .font(.headline)
            })
            
            // Navigation link to view game history
            NavigationLink(destination: GameHistoryView(gameHistory: viewModel.gameHistory)) {
                Text("Game History")
                    .font(.headline)
            }
        }
        .navigationTitle(viewModel.theme.name) // Display theme name as the navigation title
        .navigationBarItems(trailing: Group {
            Text("Score: \(viewModel.score)")
                .font(.headline)
        })
        .accentColor(Color(viewModel.theme.accentColor)) // Set accent color based on theme
        .onAppear {
            startMotionDetection() // Start accelerometer updates on view load
        }
    }

    // Function to handle motion detection for accelerometer-triggered game reset
    private func startMotionDetection() {
        motionManager.accelerometerUpdateInterval = 0.2 // Set update interval for accelerometer
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let accelerometerData = data else { return } // Ensure valid data
            let acceleration = accelerometerData.acceleration
            
            // Trigger game reset if acceleration threshold is exceeded
            if abs(acceleration.x) > 2.0 || abs(acceleration.y) > 2.0 || abs(acceleration.z) > 2.0 {
                if !resetTriggered {
                    resetTriggered = true
                    withAnimation {
                        viewModel.resetGame()
                    }
                    // Prevent multiple resets within a short time frame
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        resetTriggered = false
                    }
                }
            }
        }
    }

    // View for an individual card
    struct CardView: View {
        var card: GameModel.MemoryGame<String>.Card // Card data
        @State private var showAnimation = false // State to control the animation

        var body: some View {
            GeometryReader { geometry in
                if card.isFaceUp || !card.isMatched {
                    ZStack {
                        if showAnimation {
                            // Animation for matched cards: Scale down and spin
                            Text(card.content)
                                .font(Font.system(size: fontSize(for: geometry.size)))
                                .rotationEffect(.degrees(360))
                                .scaleEffect(0.1)
                                .animation(.easeInOut(duration: 0.6), value: showAnimation)
                                .onAppear {
                                    // Reset animation state after a delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        showAnimation = false
                                    }
                                }
                        } else {
                            // Default card appearance
                            Text(card.content)
                                .font(Font.system(size: fontSize(for: geometry.size)))
                                .cardify(isFaceUp: card.isFaceUp)
                                .onChange(of: card.isMatched) { isMatched in
                                    if isMatched {
                                        // Trigger animation for matched cards
                                        withAnimation {
                                            showAnimation = true
                                        }
                                    }
                                }
                        }
                    }
                }
            }
            .id(card.id) // Reset the view state for each new card
        }

        // Function to calculate font size based on card size
        private func fontSize(for size: CGSize) -> CGFloat {
            return min(size.width, size.height) * 0.7
        }
    }

    // SpriteKit view to display additional visual elements
    struct SpriteKitView: UIViewRepresentable {
        func makeUIView(context: Context) -> SKView {
            let skView = SKView()
            let scene = SKScene(size: CGSize(width: 300, height: 400))
            scene.backgroundColor = .clear

            // Create and animate a blue rectangle
            let spriteNode = SKSpriteNode(color: .blue, size: CGSize(width: 100, height: 150))
            spriteNode.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
            scene.addChild(spriteNode)

            // Animation sequence: Move up, fade out, and remove from parent
            let moveUp = SKAction.moveBy(x: 0, y: 300, duration: 0.5)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let sequence = SKAction.sequence([moveUp, fadeOut, .removeFromParent()])
            spriteNode.run(sequence)

            skView.presentScene(scene)
            return skView
        }

        func updateUIView(_ uiView: SKView, context: Context) {}
    }
}

// Preview for the ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGameViewModel(theme: DefaultThemes.theme1) // Example ViewModel
        game.choose(card: game.cards[0]) // Simulate a card choice
        return EmojiMemoryGameView(viewModel: game) // Preview the main view
    }
}
