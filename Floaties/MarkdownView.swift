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
        var result = AttributedString(text)
        
        // Process bold first: **text**
        var searchText = result.description
        let boldPattern = "\\*\\*([^*]+)\\*\\*"
        if let regex = try? NSRegularExpression(pattern: boldPattern) {
            let nsString = searchText as NSString
            let matches = regex.matches(in: searchText, range: NSRange(location: 0, length: nsString.length))
            
            // Process matches in reverse order to maintain indices
            for match in matches.reversed() {
                if let matchRange = Range(match.range, in: searchText),
                   let contentRange = Range(match.range(at: 1), in: searchText) {
                    let content = String(searchText[contentRange])
                    
                    // Calculate the position in AttributedString
                    if let startIndex = result.characters.index(result.startIndex, offsetBy: match.range.location, limitedBy: result.endIndex),
                       let endIndex = result.characters.index(result.startIndex, offsetBy: match.range.location + match.range.length, limitedBy: result.endIndex) {
                        let attrRange = startIndex..<endIndex
                        
                        // Replace with bold content
                        var boldContent = AttributedString(content)
                        boldContent.font = .system(size: 14, weight: .bold)
                        result.replaceSubrange(attrRange, with: boldContent)
                        
                        // Update searchText for next iteration
                        searchText = result.description
                    }
                }
            }
        }
        
        // Process italic: *text* or _text_ (but not **)
        searchText = result.description
        let italicPattern = "(?<!\\*)\\*([^*]+)\\*(?!\\*)|_([^_]+)_"
        if let regex = try? NSRegularExpression(pattern: italicPattern) {
            let nsString = searchText as NSString
            let matches = regex.matches(in: searchText, range: NSRange(location: 0, length: nsString.length))
            
            // Process matches in reverse order to maintain indices
            for match in matches.reversed() {
                if let matchRange = Range(match.range, in: searchText) {
                    let matchedText = String(searchText[matchRange])
                    let content = matchedText.trimmingCharacters(in: CharacterSet(charactersIn: "*_"))
                    
                    // Calculate the position in AttributedString
                    if let startIndex = result.characters.index(result.startIndex, offsetBy: match.range.location, limitedBy: result.endIndex),
                       let endIndex = result.characters.index(result.startIndex, offsetBy: match.range.location + match.range.length, limitedBy: result.endIndex) {
                        let attrRange = startIndex..<endIndex
                        
                        // Replace with italic content
                        var italicContent = AttributedString(content)
                        italicContent.font = .system(size: 14).italic()
                        result.replaceSubrange(attrRange, with: italicContent)
                        
                        // Update searchText for next iteration
                        searchText = result.description
                    }
                }
            }
        }
        
        return result
    }
}

enum MarkdownElement: Hashable {
    case heading1(String)
    case heading2(String)
    case heading3(String)
    case paragraph(String)
    case listItem(String)
}
