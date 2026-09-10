import SwiftUI
import Charts // Available for iOS 16 and later

// View to display game history with performance metrics
struct GameHistoryView: View {
    @ObservedObject var gameHistory: GameHistory // ObservedObject to track game history changes

    var body: some View {
        NavigationView { // Wraps the view in a navigation interface
            ScrollView { // Allows the content to scroll
                VStack {
                    // Explanation Text
                    Text("This chart visualizes your performance metrics across previous games.")
                        .font(.body)
                        .padding()

                    // Chart Section (Available for iOS 16 and later)
                    if #available(iOS 16.0, *) { // Ensures compatibility with older iOS versions
                        Chart { // Chart view to display performance data
                            ForEach(gameHistory.records) { record in
                                LineMark( // Line chart for visualizing score trends
                                    x: .value("Date", record.date), // X-axis: Date
                                    y: .value("Score", record.score) // Y-axis: Score
                                )
                                .foregroundStyle(.blue) // Line color
                                .symbol(.circle) // Adds circular symbols on data points
                            }
                        }
                        .padding() // Adds padding around the chart
                        .frame(height: 300) // Sets chart height
                    } else {
                        // Fallback message for devices with iOS below 16
                        Text("Charts are available on iOS 16 or later.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }

                    // List of Game Records
                    List {
                        ForEach(gameHistory.records) { record in
                            VStack(alignment: .leading) { // Aligns items to the left
                                Text("Date: \(formattedDate(record.date))") // Displays the record date
                                    .font(.headline)
                                Text("Time: \(record.elapsedTime) seconds") // Displays elapsed time
                                Text("Incorrect Guesses: \(record.incorrectGuesses)") // Displays incorrect guesses
                                Text("Score: \(record.score)") // Displays score
                            }
                            .padding() // Adds padding around each record
                        }
                        .onDelete { indexSet in // Enables deletion of records
                            gameHistory.removeRecord(at: indexSet) // Removes selected records
                        }
                    }
                    .frame(height: 300) // Sets a fixed height for the list

                    // Clear History Button
                    Button(action: { // Action triggered when button is pressed
                        gameHistory.clearHistory() // Clears all game history records
                    }) {
                        Text("Clear History") // Button label
                            .font(.headline)
                            .foregroundColor(.red) // Button text color
                            .padding() // Adds padding around the button
                            .frame(maxWidth: .infinity) // Expands button width
                            .background(Color(UIColor.systemGray6)) // Button background color
                            .cornerRadius(8) // Rounded corners for the button
                    }
                    .padding(.horizontal) // Adds horizontal padding
                }
            }
            .navigationTitle("Game History") // Title of the navigation view
        }
    }

    // Helper function to format Date objects into a readable string
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter() // DateFormatter instance
        formatter.dateStyle = .medium // Medium date style (e.g., Jan 1, 2024)
        formatter.timeStyle = .short // Short time style (e.g., 12:00 PM)
        return formatter.string(from: date) // Formats the date into a string
    }
}

// Preview provider for Xcode's canvas, showing the view with sample data
struct GameHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        GameHistoryView(gameHistory: GameHistory()) // Sample GameHistory instance
    }
}
