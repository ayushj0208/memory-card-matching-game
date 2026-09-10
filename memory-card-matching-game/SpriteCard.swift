import SpriteKit

// Class definition for SpriteCard, which is a subclass of SKSpriteNode.
class SpriteCard: SKSpriteNode {
    
    // Method to animate the removal of a card from the scene.
    func animateCardRemoval() {
        // Create an action to move the card upwards by 500 points over 0.5 seconds.
        let moveUp = SKAction.moveBy(x: 0, y: 500, duration: 0.5)
        
        // Create an action to gradually fade the card out over 0.5 seconds.
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        
        // Combine the move and fade actions into a sequence and remove the node from its parent after execution.
        let sequence = SKAction.sequence([moveUp, fadeOut, .removeFromParent()])
        
        // Run the combined sequence of actions on the current SpriteCard instance.
        self.run(sequence)
    }
}
