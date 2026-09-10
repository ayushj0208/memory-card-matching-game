import Foundation

// Extension of the Int type to add custom functionality
extension Int {
    // A static function that generates a random integer within a specified range,
    // excluding a specific value (x) from the possible results.
    static func random(in range: ClosedRange<Int>, excluding x: Int) -> Int {
        // Check if the excluded value (x) lies within the specified range
        if range.contains(x) {
            // Generate a random integer in the range, excluding the upper bound.
            let r = Int.random(in: Range(uncheckedBounds: (range.lowerBound, range.upperBound)))
            // If the generated value equals the excluded value (x),
            // return the upper bound of the range; otherwise, return the generated value.
            return r == x ? range.upperBound : r
        } else {
            // If the excluded value (x) is not in the range, simply return a random integer
            // within the specified range.
            return Int.random(in: range)
        }
    }
}
