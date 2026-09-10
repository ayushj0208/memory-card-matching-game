import SwiftUI

// A custom shape that represents a Pie chart or a slice of a circle.
struct Pie: Shape {
    // The starting angle of the pie slice in radians.
    var startAngle: Angle
    // The ending angle of the pie slice in radians.
    var endAngle: Angle
    // Determines the direction of the arc: clockwise or counterclockwise. Default is counterclockwise.
    var clockwise: Bool = false

    // Animatable data allows smooth transitions between the start and end angles during animations.
    var animatableData: AnimatablePair<Double, Double> {
        get {
            // Returns the start and end angles as a pair of animatable values (in radians).
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            // Updates the start and end angles when animation values change.
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    // Creates the path for the pie slice based on the provided angles and rectangle bounds.
    func path(in rect: CGRect) -> Path {
        
        // Calculate the center point of the rectangle (the origin of the pie).
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // Calculate the radius as half the smaller dimension of the rectangle.
        let radius = min(rect.width, rect.height) / 2
        
        // Calculate the starting point of the arc based on the start angle.
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        
        // Create a new path to represent the pie slice.
        var p = Path()
        // Move to the center point of the rectangle.
        p.move(to: center)
        // Draw a line from the center to the starting point of the arc.
        p.addLine(to: start)
        // Draw the arc from the start angle to the end angle.
        p.addArc(
            center: center, // The center point of the arc.
            radius: radius, // The radius of the arc.
            startAngle: startAngle, // The starting angle of the arc.
            endAngle: endAngle, // The ending angle of the arc.
            clockwise: clockwise // The direction of the arc.
        )
        // Draw a line from the end of the arc back to the center.
        p.addLine(to: center)
        
        // Return the completed pie slice path.
        return p
    }
}
