import SwiftUI

// Extension to UIColor to add support for working with RGB values and serialization
extension UIColor {
    
    // A nested struct to represent the RGBA components of a color in a hashable and codable format
    public struct RGB: Hashable, Codable {
        var red: CGFloat       // Red component of the color (0.0 - 1.0)
        var green: CGFloat     // Green component of the color (0.0 - 1.0)
        var blue: CGFloat      // Blue component of the color (0.0 - 1.0)
        var alpha: CGFloat     // Alpha (transparency) component of the color (0.0 - 1.0)
    }
    
    // Convenience initializer to create a UIColor from an RGB struct
    convenience init(_ rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }
    
    // Static method to retrieve an RGB representation from a UIColor
    static func getRGB(_ uiColor: UIColor) -> UIColor.RGB {
        return RGB(red: uiColor.rgb.red, green: uiColor.rgb.green, blue: uiColor.rgb.blue, alpha: uiColor.rgb.alpha)
    }
    
    // Computed property to extract the RGB components of the UIColor as an RGB struct
    public var rgb: RGB {
        var red: CGFloat = 0    // Red component
        var green: CGFloat = 0  // Green component
        var blue: CGFloat = 0   // Blue component
        var alpha: CGFloat = 0  // Alpha component
        // Extracts the RGBA values of the UIColor
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGB(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// Extension to SwiftUI's Color struct to initialize it from a UIColor.RGB struct
extension Color {
    // Initializer to create a SwiftUI Color from a UIColor.RGB struct
    init(_ rgb: UIColor.RGB) {
        self.init(UIColor(rgb))  // Convert UIColor.RGB to UIColor, then to Color
    }
}
