import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var content: String
    var createdAt: Date
    var modifiedAt: Date
    var reminders: [Reminder]
    
    init(id: UUID = UUID(), content: String = "", reminders: [Reminder] = []) {
        self.id = id
        self.content = content
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.reminders = reminders
    }
}

struct Reminder: Identifiable, Codable {
    let id: UUID
    var text: String
    var isCompleted: Bool
    var dueDate: Date?
    
    init(id: UUID = UUID(), text: String, isCompleted: Bool = false, dueDate: Date? = nil) {
        self.id = id
        self.text = text
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
}
