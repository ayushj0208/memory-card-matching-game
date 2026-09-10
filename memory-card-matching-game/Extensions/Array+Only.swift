// Importing the Foundation framework, which provides fundamental data types, collections, and operating system services.
import Foundation

// Extending the Array type to add a custom computed property.
extension Array {
    // A computed property `only` that returns the single element of the array if the array has exactly one element.
    // If the array has zero or more than one element, it returns nil.
    var only: Element? {
        count == 1 ? first : nil // Checks if the array has exactly one element. If true, returns the first element; otherwise, returns nil.
    }
}
