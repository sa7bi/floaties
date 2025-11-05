# UI Design Reference

## App Window Layout

```
┌─────────────────────────────────────────────┐
│  Floaties                          👁️ / ✏️   │  ← Header (transparent titlebar)
├─────────────────────────────────────────────┤
│                                             │
│  # Welcome to Floaties                      │  ← Content Area (Edit/Preview)
│                                             │
│  Start typing your notes here with          │     Edit mode: Monospace text editor
│  **Markdown** support!                      │     Preview mode: Rendered markdown
│                                             │
│  ## Features                                │
│  - Markdown formatting                      │
│  - Reminders                                │
│  - Floating window                          │
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│  Reminders                              ➕  │  ← Reminders Section
├─────────────────────────────────────────────┤
│  ○ Buy groceries                       🗑️   │
│  ✓ Review PR #42                       🗑️   │  ← Individual reminders
│  ○ Update documentation                🗑️   │     (toggle complete / delete)
│                                             │
└─────────────────────────────────────────────┘
      400 x 500 pixels (resizable)
```

## Color Scheme (Minimal)

- **Background**: System background color (adapts to light/dark mode)
- **Text**: System primary text color
- **Secondary**: System secondary text color
- **Accent**: System accent color
- **Success**: Green for completed reminders
- **Danger**: Red for delete actions

## Typography

- **App Title**: System font, 16pt, semibold
- **Headings**: System font, 24pt/20pt/18pt, bold/semibold/medium
- **Body**: System font, 14pt
- **Editor**: System monospace font, 14pt
- **Reminders**: System font, 13pt

## Icons

- 👁️ Eye: Preview mode button
- ✏️ Pencil: Edit mode button
- ➕ Plus: Add reminder button
- ○ Circle: Uncompleted reminder
- ✓ Checkmark: Completed reminder
- 🗑️ Trash: Delete reminder

## Interactions

### Window
- Drag anywhere to move
- Stays on top of other windows
- Resizable by dragging edges
- No minimize/maximize buttons

### Edit/Preview Toggle
- Click eye icon → Preview formatted markdown
- Click pencil icon → Return to edit mode
- Smooth transition between modes

### Reminders
1. Click ➕ to show input field
2. Type reminder text
3. Press Enter or click ✓ to save
4. Click ○ to mark complete (becomes ✓)
5. Click 🗑️ to delete

### Auto-save
- Saves automatically as you type
- No save button needed
- Persistent across app restarts

## Window Properties

- **Style**: Titled, closable, resizable, full-size content view
- **Titlebar**: Transparent, hidden title, movable by background
- **Level**: Floating (stays on top)
- **Default Size**: 400 x 500 pixels
- **Min Size**: None enforced (naturally constrained by content)
- **Position**: Centered on first launch

## State Management

```
User types → ContentView updates binding → NoteStore saves → JSON file
                                                ↓
                                    All changes propagate via @Published
```

## Example Note Content

```markdown
# Daily Notes

Today's tasks:
- Review the **floaties** project
- Add *italic* support to markdown
- Test reminders feature

## Ideas
- Add tags support
- Multiple notes
- Search functionality
```

## Accessibility

- Proper focus management
- Keyboard navigation support
- VoiceOver compatibility through native SwiftUI
- Respects system font sizes
- Adapts to dark/light mode

## Performance

- Lightweight: < 10MB app size
- Fast launch: < 1 second
- Instant saves: No perceived delay
- Smooth scrolling
- Efficient markdown parsing
