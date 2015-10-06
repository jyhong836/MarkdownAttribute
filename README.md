# MarkdownAttribute

A Markdown parser for converting Markdown string to NSAttributedString. The target is to create an pretty and customizable Markdown-NSAttributedString parser. You can open `MarkdownExample.playground` to view the effect and example.

This project uses [MMMarkdown](https://github.com/mdiep/MMMarkdown) to parse markdown string, and use some code from [CocoaMarkdown](https://github.com/indragiek/CocoaMarkdown) to convert them to NSAttributedString. For testing, the test codes from [Markingbird](https://github.com/kristopherjohnson/Markingbird) is used, which are translated from [MarkingSharp](https://code.google.com/p/markdownsharp/). The test benchmarks are original from website, which have been illustrated in `!readme.txt` file in test folders. The license of them have been included in 'LICENSE' file.

### Intention

By using MMMarkdown, you can convert markdown string to NSAttributedString with a workaround: (Markdown → HTML → NSAttributedString)

```swift
let html = try MMMarkdown.HTMLStringWithMarkdown(markdownString)
let astr = NSAttributedString(HTML: html.dataUsingEncoding(NSUnicodeStringEncoding)!, documentAttributes: nil)
```

Abviously, it's more efficient to convert NSAttributedString directly (Markdown → ~~HTML~~ → NSAttributedString).

And the workaround presented above would be unable to convert image or table(not beatiful at least), which is possible when transform directly.

### How to use and make customize

You can open `MarkdownExample.playground` to view the **example**. Or just try yourself:

```swift
let mm = MAMarkdown()
let astr = try mm.attributedString(markdown: yourMarkdownString)
mm.extensions = MMMarkdownExtensions.GitHubFlavored // Use GFM extension.
let astr = try MAMarkdown.attributedString(markdown: yourMarkdownString)
```

And it's convenient to apply your text style by create a class that conforms to `MATextAttributesProvider` to provide your attributes.

```swift
class YourTextAttributesProvider : MATextAttributesProvider { ... }
let mm = MAMarkdown(textAttributesProvider: YourTextAttributesProvider())
let astr = try mm.attributedString(markdown: yourMarkdownString)
```

### TODO

- [ ] Complete basic markdown syntax
- [ ] Complete extensions
- [ ] Enable to custom style

### Setup

As moset framework projects, you just need add them to your project or workspace and link them.

0. Add MarkdownAttribute as a git submodule. (`git submodule add https://github.com/jyhong836/MarkdownAttribute.git <path>`)

0. Add `MarkdownAttribute.xcodeproj` to your project or workspace

0. Add `MarkdownAttribute.framework` to the ”Link Binary with Libraries" section of your project's “Build Phases”.

0. Add `MarkdownAttribute.framework` to a ”Copy Files” build phase that copies it to the `Frameworks` destination.

### License

MarkdownAttribute is available under the [MIT License][].
