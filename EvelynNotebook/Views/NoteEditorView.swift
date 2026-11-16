import SwiftUI

struct NoteEditorView: View {
    @EnvironmentObject private var store: NotesStore
    @Environment(\.dismiss) private var dismiss

    let note: Note

    @State private var title: String
    @State private var bodyText: String

    init(note: Note) {
        self.note = note
        _title = State(initialValue: note.title)
        _bodyText = State(initialValue: note.body)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("عنوان یادداشت", text: $title)
                .font(.title3.bold())
                .textFieldStyle(.plain)
                .padding(.horizontal)
                .padding(.top, 12)

            Divider()
                .padding(.vertical, 8)

            TextEditor(text: $bodyText)
                .font(.body)
                .padding(.horizontal, 8)

            HStack {
                Text(note.persianDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(bodyText.count) کاراکتر")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .navigationTitle("ویرایش یادداشت")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("تمام") {
                    save()
                    dismiss()
                }
                .bold()
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(role: .destructive) {
                    store.delete(note)
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                }
                .accessibilityLabel("حذف یادداشت")
            }
        }
        .onChange(of: title) { _ in save() }
        .onChange(of: bodyText) { _ in save() }
        .onDisappear { save() }
    }

    private func save() {
        var updated = note
        updated.title = title
        updated.body = bodyText
        store.update(updated)
    }
}

#Preview {
    NoteEditorView(note: Note(title: "نمونه", body: "متن نمونه‌ی یادداشت"))
        .environmentObject(NotesStore())
}
