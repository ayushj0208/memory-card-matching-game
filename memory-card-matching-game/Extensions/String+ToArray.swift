import Foundation

// Extension to the String type to provide additional functionality
extension String {
    // Splits the string into an array of individual characters, each as a string
    func splitIntoArrayOfString() -> Array<String> {
        // Convert the string into an array of characters
        let charArr: Array<Character> = Array(self)
        // Initialize an empty array to hold the resulting strings
        var strArr: Array<String> = []
        // Iterate over each character in the character array
        for char in charArr {
            // Convert the character to a string and append it to the array
            strArr.append(String(char))
        }
        // Return the resulting array of strings
        return strArr
    }
}

// Extension to Array where the elements are Strings
extension Array where Element == String {
    // Merges an array of strings into a single concatenated string
    func mergeIntoString() -> String {
        // Initialize an empty string to hold the result
        var str: String = ""
        // Iterate over each string in the array
        for singleChar in self {
            // Append the string to the result
            str += singleChar
        }
        // Return the concatenated string
        return str
    }
}
