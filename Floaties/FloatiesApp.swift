import SwiftUI

@main
struct FloatiesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var noteStore = NoteStore()
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var noteStore = NoteStore()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create a floating window
        let contentView = ContentView()
            .environmentObject(noteStore)
        
        window = NSWindow(
            contentRect: NSRect(x: 100, y: 100, width: 400, height: 500),
            styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.isMovableByWindowBackground = true
        window?.level = .floating
        window?.contentView = NSHostingView(rootView: contentView)
        window?.makeKeyAndOrderFront(nil)
        window?.center()
        
        // Set activation policy to accessory to hide dock icon
        NSApp.setActivationPolicy(.accessory)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
