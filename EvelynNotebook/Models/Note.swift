import Foundation

struct Note: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var body: String
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    var displayTitle: String {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        let firstLine = body
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .first ?? ""
        return firstLine.isEmpty ? "یادداشت جدید" : firstLine
    }

    var preview: String {
        body.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var persianDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fa_IR")
        formatter.calendar = Calendar(identifier: .persian)
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: updatedAt)
    }
}
