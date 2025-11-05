# Floaties

A minimal floating notes app for macOS with Markdown support and reminders - inspired by Raycast Notes.

## Features

- **Floating Window**: Always-on-top window that stays accessible
- **Markdown Support**: Write notes with Markdown formatting including:
  - Headings (# ## ###)
  - Bold text (\*\*bold\*\*)
  - Italic text (\*italic\* or \_italic\_)
  - Lists (- or \*)
- **Reminders**: Add, check off, and delete reminders within your notes
- **Auto-save**: Notes are automatically saved as you type
- **Minimal Design**: Clean, distraction-free interface
- **Edit/Preview Modes**: Toggle between editing and preview modes

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later

## Building

1. Clone the repository:
   ```bash
   git clone https://github.com/sa7bi/floaties.git
   cd floaties
   ```

2. Open the project in Xcode:
   ```bash
   open Floaties.xcodeproj
   ```

3. Build and run the project (⌘R)

## Usage

### Writing Notes

1. The app launches with a floating window
2. Start typing in the editor - notes are automatically saved
3. Use Markdown syntax for formatting:
   - `# Heading 1` for main headings
   - `## Heading 2` for subheadings
   - `**bold text**` for bold
   - `*italic text*` for italic
   - `- list item` for bullet lists

### Preview Mode

- Click the eye icon to preview your formatted Markdown
- Click the pencil icon to return to edit mode

### Reminders

1. Click the "+" icon in the Reminders section
2. Type your reminder text and press Enter
3. Click the circle to mark a reminder as complete
4. Click the trash icon to delete a reminder

### Window Behavior

- The window stays on top of other applications
- Drag anywhere in the window to reposition it
- The app runs without a dock icon for minimal distraction
- Closing the window hides the app (use ⌘Q to quit)

## Technical Details

The app is built with:
- SwiftUI for the user interface
- AppKit integration for window management
- JSON-based file storage for notes
- Custom Markdown parser for rendering

## License

MIT
