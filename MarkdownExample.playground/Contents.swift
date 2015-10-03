//: MarkdownExample - an example for usage of MarkdownAttribute

import Cocoa
import XCPlayground
import MarkdownAttribute

let mstring = ["## Playground",
    "+ hello, **world**",
    "",
    "[website](jyhong.com)",
    "",
    "```swift",
    "func swift_func()",
    "   print(\"hi\")",
    "```",
    "😄汉字, `inline code`, r",
    "",
    "end"
    ].joinWithSeparator("\n")

do {
    let astr = try MAMarkdown.attributedString(markdown: mstring, extensions: MMMarkdownExtensions.GitHubFlavored)
    var view = NSTextView(frame: NSRect(x: 0, y: 0, width: 300, height: 300))
    view.textStorage?.setAttributedString(astr)
    view
} catch {
    NSLog("\(error)")
}

