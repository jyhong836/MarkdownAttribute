//: MarkdownExample - an example for usage of MarkdownAttribute
// Extension: GitHubFlavored

import Cocoa
import XCPlayground
import MarkdownAttribute

let mstring = [
    "# header level 1",
    "## header level 2",
    "### header level 3",
    "#### header level 4",
    "##### header level 5",
    "###### header level 6",
    "This is **strong**, and *emphasis*",
    "+ this is bullet list item 1",
    "+ this is bullet list item 2",
    "",
    "1. this is numbered list item 1",
    "2. this is numbered list item 1, and a **em**, a *strong*",
    "",
    "link: [website](jyhong.com)",
    "ordered list:",
    "1. first level list: item 1",
    "   + second level list: item 1",
    "   + second level list: item 2",
    "1. first level list: item 2",
    "",
    "```swift",
    "func swiftFunc()",
    "   print(\"hi\")",
    "```",
    "Unicode tests: 😄汉字",
    "This is `inline code`.",
    "",
    "This is a HTML link: <a href=\"jyhong.com\">jyhong</a>",
    "end"
    ].joinWithSeparator("\n")

do {
//: Let's have a look at the effect
    let astr = try MAMarkdown.attributedString(markdown: mstring, extensions: MMMarkdownExtensions.GitHubFlavored)
//    NSLog("\(astr)")
    var view = NSTextView(frame: NSRect(x: 0, y: 0, width: 300, height: 700))
    view.textStorage?.setAttributedString(astr)
//: Let's view them in a NSTextView
    view
} catch {
    NSLog("\(error)")
}

