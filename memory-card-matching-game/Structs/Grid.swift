import SwiftUI

// A generic Grid view that takes an array of identifiable items and a view generator for each item.
struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    
    // The array of items to be displayed in the grid.
    private var items: [Item]
    
    // A closure that generates a view for a given item.
    private var viewForItem: (Item) -> ItemView
    
    // Initializer for the Grid, taking an array of items and a closure to generate item views.
    init(items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    // The body of the Grid view.
    var body: some View {
        GeometryReader { geometry in
            // Use GeometryReader to adapt the grid layout to the available space.
            ForEach(items) { item in
                // Render each item in the grid.
                self.body(for: item, in: GridLayout(itemCount: items.count, in: geometry.size))
            }
        }
    }
    
    // Helper function to generate the view for a specific item, positioned in the grid layout.
    private func body(for item: Item, in layout: GridLayout) -> some View {
        // Find the index of the current item in the array.
        let index = items.firstIndex(matching: item)
        
        return Group {
            // Ensure the index exists; otherwise, return an empty view.
            if index != nil {
                // Use the provided view generator for the item.
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height) // Set the frame size based on the layout.
                    .position(layout.location(ofItemAt: index!)) // Position the view within the grid layout.
            }
        }
    }
}
