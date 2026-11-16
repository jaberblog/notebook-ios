import SwiftUI

@main
struct EvelynNotebookApp: App {
    @StateObject private var store = NotesStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                // Persian UI, right-to-left
                .environment(\.locale, Locale(identifier: "fa_IR"))
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
