import Foundation

@MainActor
final class NotesStore: ObservableObject {
    @Published private(set) var notes: [Note] = []

    private let fileName = "notes.json"

    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }

    init() {
        load()
        if notes.isEmpty, !FileManager.default.fileExists(atPath: fileURL.path) {
            // One welcome note, only on the very first launch.
            notes = [
                Note(
                    title: "به دفترچه یادداشت خوش آمدید",
                    body: "اینجا بنویسید…\n\n• برای یادداشت جدید، + را بزنید.\n• برای حذف، روی یادداشت به چپ بکشید.\n• همه‌ی یادداشت‌ها روی گوشی ذخیره می‌شوند."
                )
            ]
            save()
        }
    }

    func addNote() -> Note {
        let note = Note(title: "", body: "")
        notes.insert(note, at: 0)
        save()
        return note
    }

    func update(_ note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        var updated = note
        updated.updatedAt = Date()
        notes[index] = updated
        // Keep the most recently edited note on top.
        notes.sort { $0.updatedAt > $1.updatedAt }
        save()
    }

    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        save()
    }

    func delete(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let decoded = try? JSONDecoder().decode([Note].self, from: data) else { return }
        notes = decoded.sorted { $0.updatedAt > $1.updatedAt }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(notes) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }
}
