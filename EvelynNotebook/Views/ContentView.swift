import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: NotesStore
    @State private var searchText = ""
    @State private var editingNote: Note?

    private var filteredNotes: [Note] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return store.notes }
        return store.notes.filter {
            $0.title.localizedCaseInsensitiveContains(query)
                || $0.body.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.notes.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "note.text")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("هنوز یادداشتی ندارید")
                            .font(.headline)
                        Text("دکمه + را بزنید و اولین یادداشت را بنویسید.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredNotes.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                        Text("چیزی پیدا نشد")
                            .font(.headline)
                        Text("عبارت دیگری را جستجو کنید.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filteredNotes) { note in
                            NavigationLink {
                                NoteEditorView(note: note)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(note.displayTitle)
                                        .font(.headline)
                                        .lineLimit(1)
                                    if !note.preview.isEmpty {
                                        Text(note.preview)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                    }
                                    Text(note.persianDate)
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete { offsets in
                            let toDelete = offsets.map { filteredNotes[$0] }
                            for note in toDelete { store.delete(note) }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("دفترچه یادداشت")
            .searchable(text: $searchText, prompt: "جستجو در یادداشت‌ها")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editingNote = store.addNote()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("یادداشت جدید")
                }
            }
            .sheet(item: $editingNote) { note in
                NavigationStack {
                    NoteEditorView(note: note)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NotesStore())
}
