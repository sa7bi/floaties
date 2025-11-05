# Floaties Architecture

## Application Structure

```
Floaties (macOS App)
├── FloatiesApp.swift          # App entry point & AppDelegate
│   ├── Creates floating NSWindow
│   ├── Sets window properties (floating, transparent titlebar)
│   └── Manages app lifecycle
│
├── ContentView.swift           # Main UI component
│   ├── Header (title + edit/preview toggle)
│   ├── Editor/Preview area
│   └── Reminders section
│
├── MarkdownView.swift          # Markdown renderer
│   ├── Parses markdown text
│   ├── Supports headings, bold, italic, lists
│   └── Renders formatted output
│
├── Note.swift                  # Data models
│   ├── Note (id, content, dates, reminders)
│   └── Reminder (id, text, isCompleted, dueDate)
│
└── NoteStore.swift             # Data management
    ├── Manages notes collection
    ├── JSON persistence
    ├── Auto-save functionality
    └── CRUD operations for notes & reminders
```

## Data Flow

```
User Input → ContentView → NoteStore → JSON File
                ↓
         MarkdownView (for preview)
```

## Key Features

### Floating Window
- Uses NSWindow with `.floating` level
- Always stays on top of other windows
- Movable by dragging anywhere
- Transparent titlebar for minimal look

### Markdown Support
- Real-time parsing and rendering
- Toggle between edit and preview modes
- Custom parser for headings, bold, italic, lists

### Reminders
- Integrated into notes
- Persistent storage
- Toggle completion status
- Delete functionality

### Auto-save
- Saves on every content change
- JSON-based storage in user's Documents folder
- No manual save needed

## Technology Stack

- **SwiftUI**: Modern declarative UI framework
- **AppKit**: Native macOS window management
- **Foundation**: Core data types and JSON encoding/decoding
- **Combine**: Reactive data binding with @Published properties

## File Storage

```
~/Documents/floaties_notes.json
```

Format:
```json
[
  {
    "id": "uuid",
    "content": "markdown content",
    "createdAt": "timestamp",
    "modifiedAt": "timestamp",
    "reminders": [
      {
        "id": "uuid",
        "text": "reminder text",
        "isCompleted": false,
        "dueDate": null
      }
    ]
  }
]
```
