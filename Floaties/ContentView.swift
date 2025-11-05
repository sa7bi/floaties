import SwiftUI

struct ContentView: View {
    @EnvironmentObject var noteStore: NoteStore
    @State private var isEditMode = true
    @State private var newReminderText = ""
    @State private var showReminderInput = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Floaties")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    isEditMode.toggle()
                }) {
                    Image(systemName: isEditMode ? "eye" : "pencil")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .help(isEditMode ? "Preview" : "Edit")
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Content area
            if isEditMode {
                // Edit mode
                TextEditor(text: Binding(
                    get: { noteStore.currentNote?.content ?? "" },
                    set: { noteStore.updateCurrentNote(content: $0) }
                ))
                .font(.system(size: 14, design: .monospaced))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Preview mode
                MarkdownView(markdown: noteStore.currentNote?.content ?? "")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Divider()
            
            // Reminders section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Reminders")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: {
                        showReminderInput.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                if showReminderInput {
                    HStack(spacing: 8) {
                        TextField("New reminder", text: $newReminderText, onCommit: {
                            if !newReminderText.isEmpty {
                                noteStore.addReminder(text: newReminderText)
                                newReminderText = ""
                                showReminderInput = false
                            }
                        })
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(6)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(4)
                        
                        Button(action: {
                            if !newReminderText.isEmpty {
                                noteStore.addReminder(text: newReminderText)
                                newReminderText = ""
                                showReminderInput = false
                            }
                        }) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                }
                
                if let reminders = noteStore.currentNote?.reminders, !reminders.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(reminders) { reminder in
                                HStack(spacing: 8) {
                                    Button(action: {
                                        noteStore.toggleReminder(reminderId: reminder.id)
                                    }) {
                                        Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(reminder.isCompleted ? .green : .secondary)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Text(reminder.text)
                                        .font(.system(size: 13))
                                        .strikethrough(reminder.isCompleted)
                                        .foregroundColor(reminder.isCompleted ? .secondary : .primary)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        noteStore.deleteReminder(reminderId: reminder.id)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .font(.system(size: 11))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .frame(maxHeight: 150)
                } else {
                    Text("No reminders yet")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
            .frame(height: showReminderInput ? 200 : (noteStore.currentNote?.reminders.isEmpty ?? true ? 80 : 200))
            .background(Color(NSColor.windowBackgroundColor).opacity(0.5))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NoteStore())
            .frame(width: 400, height: 500)
    }
}
