import SwiftUI

struct ThemeEditorView: View {
    @EnvironmentObject private var tcManager: ThemeCollectionManager // Access ThemeCollectionManager as an environment object
    @Environment(\.presentationMode) var presentation // Access the presentation mode to dismiss the view
    private var isEditing: Bool // Indicates if the view is in editing mode
    private var selectedTheme: ThemeCollection.Theme? // The theme being edited, if any
    @State private var name: String // State variable for the theme's name
    @State private var emojiText: String // State variable for the emoji text input
    @State private var color: Color // State variable for the theme's color
    
    // Initializer for editing an existing theme
    init(theme: ThemeCollection.Theme) {
        self.isEditing = true
        self.selectedTheme = theme
        self._name = State(wrappedValue: theme.name) // Initialize the name with the existing theme's name
        self._color = State(wrappedValue: Color(theme.accentColor)) // Initialize the color with the existing theme's color
        self._emojiText = State(wrappedValue: theme.emojiSet.mergeIntoString()) // Initialize the emoji text with the existing theme's emoji set
    }
    
    // Initializer for creating a new theme
    init() {
        self.isEditing = false
        self._name = State(initialValue: "") // Default name for a new theme
        self._color = State(initialValue: Color.blue) // Default color for a new theme
        self._emojiText = State(initialValue: "") // Default emoji text for a new theme
    }
    
    var body: some View {
        NavigationView {
            List {
                // Section for selecting a color
                Section {
                    ColorPicker("Color", selection: $color)
                }
                // Section for entering the theme name and emojis
                Section {
                    HStack {
                        Text("Name\t") // Label for the name input
                        TextField("New Theme", text: $name) // Text field for entering the theme name
                    }
                    HStack {
                        Text("Emojis\t") // Label for the emoji input
                        TextField("Enter your Emojis", text: $emojiText) // Text field for entering emojis
                    }
                }
            }
            .listStyle(InsetGroupedListStyle()) // Use an inset grouped list style
            .toolbar {
                // Toolbar item for confirming the action
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Done" : "Add") {
                        presentation.wrappedValue.dismiss() // Dismiss the view
                        if isEditing {
                            // Update the existing theme
                            tcManager.editTheme(
                                id: selectedTheme!.id, // Use the ID of the theme being edited
                                name: name, // Updated name
                                accentColor: UIColor(color), // Updated color
                                emojiSet: emojiText.splitIntoArrayOfString() // Updated emoji set
                            )
                        } else {
                            // Add a new theme
                            tcManager.addTheme(
                                name: name, // New theme name
                                accentColor: UIColor(color), // New theme color
                                emojiSet: emojiText.splitIntoArrayOfString() // New emoji set
                            )
                        }
                    }
                    .disabled(name == "" || emojiText.count < 2) // Disable the button if input is invalid
                }
                // Toolbar item for canceling the action
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentation.wrappedValue.dismiss() } // Dismiss the view without saving
                }
            }
        }
    }
}

struct ThemeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditorView() // Preview the ThemeEditorView
    }
}
