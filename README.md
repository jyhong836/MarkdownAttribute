# MarkdownAttribute
A Markdown parser for converting Markdown string to NSAttributedString. The target is to create an pretty and customizable parser.

This project uses [MMMarkdown](https://github.com/mdiep/MMMarkdown) to parse markdown string, and use some code from [CocoaMarkdown](https://github.com/indragiek/CocoaMarkdown) to convert them to NSAttributedString. For testing, the test codes from [Markingbird](https://github.com/kristopherjohnson/Markingbird) is used, which are translated from [MarkingSharp](https://code.google.com/p/markdownsharp/). The test benchmarks are original from website, which have been illustrated in `!readme.txt` file in test folders. The license of them have been included in 'LICENSE' file.

### Intention
By using MMMarkdown, you can convert markdown string to NSAttributedString with a workaround: (Markdown → HTML → NSAttributedString)

```swift
let html = try MMMarkdown.HTMLStringWithMarkdown(markdownString)
let astr = NSAttributedString(HTML: html.dataUsingEncoding(NSUnicodeStringEncoding)!, documentAttributes: nil)
```

Abviously, it's more efficient to convert NSAttributedString directly (Markdown → ~~HTML~~ → NSAttributedString).

And the workaround presented above would be unable to convert image or table(not beatiful at least), which is possible when transform directly.

### TODO

- [ ] Complete basic markdown syntax
- [ ] Complete extensions
- [ ] Enable to custom style
