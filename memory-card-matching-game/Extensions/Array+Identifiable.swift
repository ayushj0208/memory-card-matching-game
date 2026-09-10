import Foundation

// Extend the Array type where the elements conform to the Identifiable protocol
extension Array where Element: Identifiable {

    // A function to find the first index of an element in the array that matches the given element
    // The matching element is identified by its 'id' property
    func firstIndex(matching: Element) -> Int? { // The return value is an optional Int (can be nil if no match is found)
        
        // Loop through the array's indices
        for index in 0 ..< self.count {
            
            // Check if the id of the element at the current index matches the id of the given element
            if self[index].id == matching.id {
                
                // If a match is found, return the index
                return index
            }
        }
        
        // If no match is found, return nil
        return nil
    }
}
