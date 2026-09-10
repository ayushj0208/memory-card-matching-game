import SwiftUI

// Main view for selecting and managing themes
struct ThemeSelectionView: View {
    @ObservedObject var tcManager: ThemeCollectionManager // Manages the collection of themes
    @Environment(\.presentationMode) var presentation // Environment variable for dismissing views
    @State private var editMode = EditMode.inactive // Tracks whether the view is in edit mode
    @State private var showingSheet = false // Controls the display of the sheet for editing/adding themes
    @State private var selectedTheme: ThemeCollection.Theme? = nil // Tracks the currently selected theme for editing
    
    var body: some View {
        return NavigationView { // Provides a navigation structure
            VStack { // Vertical stack layout
                List { // Displays a list of themes
                    ForEach(tcManager.themes) { theme in // Iterates through themes
                        NavigationLink(destination: DestinationPageView(theme: theme)) { // Links to the detail page for a theme
                            HStack { // Horizontal layout for theme row
                                displayCircularEditButton(theme: theme) // Displays an edit or navigation button
                                VStack(alignment: .leading, spacing: 8) { // Layout for theme details
                                    Text(theme.name) // Displays the theme's name
                                    Text(theme.emojiSet.joined(separator: " ")) // Displays the emojis in the theme
                                }.font(.headline).padding() // Style adjustments
                            }
                        }
                    }
                    .onDelete(perform: onDelete) // Enables swipe-to-delete functionality
                    .onMove(perform: onMove) // Enables drag-and-drop reordering
                }
                .listStyle(InsetGroupedListStyle()) // Style for the list
                .toolbar { // Toolbar with edit and add buttons
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton() // Enables toggling edit mode
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { // Action to show the sheet for adding a new theme
                            selectedTheme = nil
                            self.showingSheet = true
                        }, label: {
                            Image(systemName: "plus") // Add button icon
                                .imageScale(.large)
                        })
                    }
                }
                .environment(\.editMode, $editMode) // Passes the edit mode state to the environment
                .navigationTitle("Themes") // Title of the navigation view
                
                Button("Reset") { // Button to reset themes to defaults
                    tcManager.resetThemes()
                }
            }
            DestinationPageView(theme: DefaultThemes.theme1) // Default destination for the split view
        }
        .sheet(isPresented: $showingSheet) { // Displays the sheet for editing/adding themes
            if selectedTheme != nil { // Checks if a theme is selected
                ThemeEditorView(theme: selectedTheme!) // Passes the selected theme to the editor
            } else {
                ThemeEditorView() // Opens a blank editor for creating a new theme
            }
        }
        .environmentObject(tcManager) // Passes the theme manager to the environment
    }
    
    // Deletes themes from the manager at specified offsets
    private func onDelete(atOffsets: IndexSet) {
        tcManager.removeTheme(atOffsets: atOffsets)
    }
    
    // Moves themes in the list from source to destination offsets
    private func onMove(source: IndexSet, destination: Int) {
        tcManager.moveTheme(fromOffsets: source, toOffset: destination)
    }
    
    // Displays a circular button for editing or navigation, depending on edit mode
    @ViewBuilder
    private func displayCircularEditButton(theme: ThemeCollection.Theme) -> some View {
        withAnimation(.easeIn) { // Animates the transition between states
            ZStack { // Overlay layout for buttons
                Image(systemName: "pencil.circle.fill") // Edit icon
                    .foregroundColor(.blue) // Icon color
                    .imageScale(.large) // Icon size
                    .opacity(editMode.isEditing ? 1 : 0) // Only visible in edit mode
                    .onTapGesture { // Opens the editor when tapped
                        selectedTheme = theme
                        showingSheet = true
                    }
                Image(systemName: "chevron.right.circle.fill") // Navigation icon
                    .opacity(editMode.isEditing ? 0 : 1) // Hidden in edit mode
                    .foregroundColor(Color(theme.accentColor)) // Matches theme accent color
            }
        }
    }
}

// View for navigating to and interacting with a specific theme
struct DestinationPageView: View {
    var theme: ThemeCollection.Theme // The theme associated with this view
    var viewModel: EmojiMemoryGameViewModel // View model for the memory game
    
    init(theme: ThemeCollection.Theme) {
        self.theme = theme // Initializes with the provided theme
        self.viewModel = EmojiMemoryGameViewModel(theme: theme) // Creates a view model for the theme
    }

    var body: some View {
        viewModel.resetGame() // Resets the game whenever this view is loaded
        return EmojiMemoryGameView(viewModel: viewModel) // Displays the game view
    }
}

// Preview provider for testing the ThemeSelectionView
struct ThemeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelectionView(tcManager: ThemeCollectionManager()) // Uses a mock manager for previews
    }
}
