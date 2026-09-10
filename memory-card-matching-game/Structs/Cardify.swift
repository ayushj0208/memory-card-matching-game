import SwiftUI

// A custom modifier to animate the flipping of a card
struct Cardify: AnimatableModifier { // AnimatableModifier combines ViewModifier with animation capabilities
    var rotation: Double // Rotation angle of the card in degrees
    
    // Initializer to determine the starting rotation based on whether the card is face up or face down
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180 // 0 degrees for face-up, 180 degrees for face-down
    }
    
    // Computed property to determine if the card is face up based on the rotation angle
    var isFaceUp: Bool {
        rotation < 90 // Less than 90 degrees means the front face is visible
    }
    
    // Conforming to AnimatableModifier by providing animatable data
    var animatableData: Double {
        get { return rotation } // The rotation angle will animate during state changes
        set { rotation = newValue } // Update rotation during animation
    }
    
    // Defines the appearance of the card based on its state
    func body(content: Content) -> some View {
        ZStack {
            Group { // Group contains elements that will only show when the card is face up
                RoundedRectangle(cornerRadius: CORNER_RADIUS)
                    .fill(Color.white) // Background of the face-up card
                RoundedRectangle(cornerRadius: CORNER_RADIUS)
                    .stroke(lineWidth: EDGE_LINE_WIDTH) // Border of the face-up card
                
                content // Content of the card (e.g., emoji or text)
            }
            .opacity(isFaceUp ? 1.0 : 0.0) // Fully visible when face up, invisible when face down
            
            // Back of the card when it's face down
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .opacity(isFaceUp ? 0.0 : 1.0) // Invisible when face up, visible when face down
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0)) // Applies a 3D flip effect along the Y-axis
    }
    
    // Constants for the card's appearance
    private let CORNER_RADIUS: CGFloat = 10.0 // Rounded corner radius
    private let EDGE_LINE_WIDTH: CGFloat = 3.0 // Border width
}

// View extension to make applying the Cardify modifier easier
extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp)) // Applies the Cardify modifier with the given state
    }
}
