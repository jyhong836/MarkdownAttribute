//: MarkdownExample - an example for usage of MarkdownAttribute

import Cocoa
import XCPlayground
import MarkdownAttribute

let mstring = [
    "# Playground",
    "+ hello, **world**",
    "+ byebe, **world**",
    "",
    "1. this is numbered list item 1",
    "2. this is numbered list item 1, and a **em**, a *strong*",
    "",
    "link: [website](jyhong.com)",
    "",
    "1. ok",
    "   + hi",
    "   + hello",
    "1. fine",
    "",
    "```swift",
    "func swiftFunc()",
    "   print(\"hi\")",
    "```",
    "😄汉字, `inline code`, r",
    "",
    "<a href=\"jyhong.com\">jyho</a>",
    "end"
    ].joinWithSeparator("\n")

do {
    let astr = try MAMarkdown.attributedString(markdown: mstring, extensions: MMMarkdownExtensions.GitHubFlavored)
    NSLog("\(astr)")
    var view = NSTextView(frame: NSRect(x: 0, y: 0, width: 300, height: 300))
    view.textStorage?.setAttributedString(astr)
    view
} catch {
    NSLog("\(error)")
}

