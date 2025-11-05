import SwiftUI

struct MarkdownView: View {
    let markdown: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(parseMarkdown(markdown), id: \.self) { element in
                    renderElement(element)
                }
            }
            .padding()
        }
    }
    
    private func parseMarkdown(_ text: String) -> [MarkdownElement] {
        var elements: [MarkdownElement] = []
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            if line.hasPrefix("# ") {
                elements.append(.heading1(String(line.dropFirst(2))))
            } else if line.hasPrefix("## ") {
                elements.append(.heading2(String(line.dropFirst(3))))
            } else if line.hasPrefix("### ") {
                elements.append(.heading3(String(line.dropFirst(4))))
            } else if line.hasPrefix("- ") || line.hasPrefix("* ") {
                elements.append(.listItem(String(line.dropFirst(2))))
            } else if !line.isEmpty {
                elements.append(.paragraph(line))
            }
        }
        
        return elements
    }
    
    @ViewBuilder
    private func renderElement(_ element: MarkdownElement) -> some View {
        switch element {
        case .heading1(let text):
            Text(formatInlineMarkdown(text))
                .font(.system(size: 24, weight: .bold))
                .padding(.bottom, 4)
        case .heading2(let text):
            Text(formatInlineMarkdown(text))
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 3)
        case .heading3(let text):
            Text(formatInlineMarkdown(text))
                .font(.system(size: 18, weight: .medium))
                .padding(.bottom, 2)
        case .paragraph(let text):
            Text(formatInlineMarkdown(text))
                .font(.system(size: 14))
        case .listItem(let text):
            HStack(alignment: .top, spacing: 8) {
                Text("•")
                    .font(.system(size: 14))
                Text(formatInlineMarkdown(text))
                    .font(.system(size: 14))
            }
            .padding(.leading, 8)
        }
    }
    
    private func formatInlineMarkdown(_ text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        // Bold: **text**
        let boldPattern = "\\*\\*([^*]+)\\*\\*"
        if let regex = try? NSRegularExpression(pattern: boldPattern) {
            let nsString = text as NSString
            let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            
            for match in matches.reversed() {
                if let range = Range(match.range, in: text),
                   let contentRange = Range(match.range(at: 1), in: text) {
                    let content = String(text[contentRange])
                    if let attrRange = Range(range, in: attributedString) {
                        attributedString.replaceSubrange(attrRange, with: AttributedString(content))
                        if let boldRange = attributedString.range(of: content) {
                            attributedString[boldRange].font = .system(size: 14, weight: .bold)
                        }
                    }
                }
            }
        }
        
        // Italic: *text* or _text_
        let italicPattern = "(?<!\\*)\\*([^*]+)\\*(?!\\*)|_([^_]+)_"
        if let regex = try? NSRegularExpression(pattern: italicPattern) {
            let nsString = attributedString.description as NSString
            let matches = regex.matches(in: attributedString.description, range: NSRange(location: 0, length: nsString.length))
            
            for match in matches.reversed() {
                let matchRange = match.range
                if let range = Range(matchRange, in: attributedString.description) {
                    let matchedText = String(attributedString.description[range])
                    let content = matchedText.trimmingCharacters(in: CharacterSet(charactersIn: "*_"))
                    if let attrRange = attributedString.range(of: matchedText) {
                        attributedString.replaceSubrange(attrRange, with: AttributedString(content))
                        if let italicRange = attributedString.range(of: content) {
                            attributedString[italicRange].font = .system(size: 14).italic()
                        }
                    }
                }
            }
        }
        
        return attributedString
    }
}

enum MarkdownElement: Hashable {
    case heading1(String)
    case heading2(String)
    case heading3(String)
    case paragraph(String)
    case listItem(String)
}
