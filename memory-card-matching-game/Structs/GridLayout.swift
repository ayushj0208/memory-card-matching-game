import SwiftUI

struct GridLayout {
    private(set) var size: CGSize // The overall size of the grid
    private(set) var rowCount: Int = 0 // The number of rows in the grid
    private(set) var columnCount: Int = 0 // The number of columns in the grid
    
    // Initializer that calculates the best layout for the given number of items
    init(itemCount: Int, nearAspectRatio desiredAspectRatio: Double = 1, in size: CGSize) {
        self.size = size
        
        // If the size has zero width or height, or if there are no items, no layout is needed
        guard size.width != 0, size.height != 0, itemCount > 0 else { return }
        
        // Variables to track the best layout and its aspect ratio variance
        var bestLayout: (rowCount: Int, columnCount: Int) = (1, itemCount)
        var smallestVariance: Double?
        
        // Calculate the aspect ratio of the size
        let sizeAspectRatio = abs(Double(size.width / size.height))
        
        // Iterate through possible row counts to find the optimal layout
        for rows in 1...itemCount {
            let columns = (itemCount / rows) + (itemCount % rows > 0 ? 1 : 0) // Calculate columns needed for this row count
            
            // Ensure the layout can fit all items
            if (rows - 1) * columns < itemCount {
                let itemAspectRatio = sizeAspectRatio * (Double(rows) / Double(columns))
                let variance = abs(itemAspectRatio - desiredAspectRatio) // Calculate the variance from the desired aspect ratio
                
                // Update the best layout if this one has a smaller variance
                if smallestVariance == nil || variance < smallestVariance! {
                    smallestVariance = variance
                    bestLayout = (rowCount: rows, columnCount: columns)
                }
            }
        }
        
        // Set the best layout's row and column counts
        rowCount = bestLayout.rowCount
        columnCount = bestLayout.columnCount
    }
    
    // Calculate the size of each item in the grid
    var itemSize: CGSize {
        if rowCount == 0 || columnCount == 0 {
            return CGSize.zero // Return zero size if no layout is determined
        } else {
            return CGSize(
                width: size.width / CGFloat(columnCount),
                height: size.height / CGFloat(rowCount)
            )
        }
    }
    
    // Calculate the location of a specific item based on its index
    func location(ofItemAt index: Int) -> CGPoint {
        if rowCount == 0 || columnCount == 0 {
            return CGPoint.zero // Return zero location if no layout is determined
        } else {
            return CGPoint(
                x: (CGFloat(index % columnCount) + 0.5) * itemSize.width, // X-coordinate based on column position
                y: (CGFloat(index / columnCount) + 0.5) * itemSize.height // Y-coordinate based on row position
            )
        }
    }
}
