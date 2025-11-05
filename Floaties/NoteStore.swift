import Foundation

class NoteStore: ObservableObject {
    @Published var notes: [Note] = []
    @Published var currentNote: Note?
    
    private let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("floaties_notes.json")
    
    init() {
        loadNotes()
        if notes.isEmpty {
            let defaultNote = Note(content: "# Welcome to Floaties\n\nStart typing your notes here with **Markdown** support!\n\n## Features\n- Markdown formatting\n- Reminders\n- Floating window\n\n")
            notes.append(defaultNote)
            currentNote = defaultNote
            saveNotes()
        } else {
            currentNote = notes.first
        }
    }
    
    func saveNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save notes: \(error.localizedDescription)")
        }
    }
    
    func loadNotes() {
        do {
            let data = try Data(contentsOf: savePath)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("Failed to load notes: \(error.localizedDescription)")
            notes = []
        }
    }
    
    func updateCurrentNote(content: String) {
        guard var note = currentNote, let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        note.content = content
        note.modifiedAt = Date()
        notes[index] = note
        currentNote = note
        saveNotes()
    }
    
    func addReminder(text: String) {
        guard var note = currentNote, let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        let reminder = Reminder(text: text)
        note.reminders.append(reminder)
        note.modifiedAt = Date()
        notes[index] = note
        currentNote = note
        saveNotes()
    }
    
    func toggleReminder(reminderId: UUID) {
        guard var note = currentNote, let noteIndex = notes.firstIndex(where: { $0.id == note.id }) else { return }
        if let reminderIndex = note.reminders.firstIndex(where: { $0.id == reminderId }) {
            note.reminders[reminderIndex].isCompleted.toggle()
            note.modifiedAt = Date()
            notes[noteIndex] = note
            currentNote = note
            saveNotes()
        }
    }
    
    func deleteReminder(reminderId: UUID) {
        guard var note = currentNote, let noteIndex = notes.firstIndex(where: { $0.id == note.id }) else { return }
        note.reminders.removeAll { $0.id == reminderId }
        note.modifiedAt = Date()
        notes[noteIndex] = note
        currentNote = note
        saveNotes()
    }
}
