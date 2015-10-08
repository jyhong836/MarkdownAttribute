//
//  SimpleTests.swift
//  SimpleTests
//
//  File from Markingbird
//

//import Markingbird
@testable import MarkdownAttribute
import XCTest

class SimpleTests: XCTestCase {
    
    private let defaultEncoding = NSUTF8StringEncoding
//    private let defaultExtension = MMMarkdownExtensions.GitHubFlavored
    let mm = MAMarkdown(extensions: MMMarkdownExtensions.GitHubFlavored)
    
    override func setUp() {
        let ap = mm.textAttributesProvider as! MATextAttributes
        ap.defaultFont = NSFont(name: "Times-Roman", size: 12.0)!
        mm.textAttributesProvider = ap
    }
    
    func STAssertTransform(markdown: String, _ html: String, _ message: String = "fail to transform to expected") {
        do {
            let expected = try NSAttributedString(data: html.dataUsingEncoding(defaultEncoding)!, options: [NSDocumentTypeDocumentOption : NSHTMLTextDocumentType], documentAttributes: nil)
            let actual = try mm.attributedString(markdown: markdown)
            XCTAssert(actual.isEqualToAttributedString(expected), message)
            
            print(Colorfy.red(": actual"))
            print("\(actual)")
            print(Colorfy.red(": expected"))
            print("\(expected)")
            print(actual.prettyFirstDifferenceToSting(otherString: expected))
        } catch {
            XCTFail("\(message)\n====== ERROR =====\n\(error)")
        }
    }
    
    func testBare() {
        let input = "This bare input.\nsecond line"
        let expected = "This bare input.\n\nsecond line"
        
        STAssertTransform(input, expected)
    }
    
    func testBold()
    {
        let input = "This is **bold**. This is also __bold__."
        let expected = "<p>This is <strong>bold</strong>. This is also <strong>bold</strong>.</p>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testItalic()
    {
        let input = "This is *italic*. This is also _italic_."
        let expected = "<p>This is <em>italic</em>. This is also <em>italic</em>.</p>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testLink()
    {
        let input = "This is [a link][1].\n\n  [1]: http://www.example.com"
        let expected = "<p>This is <a href=\"http://www.example.com\">a link</a>.</p>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testLinkBracket()
    {
        let input = "Have you visited <http://www.example.com> before?"
        let expected = "<p>Have you visited <a href=\"http://www.example.com\">http://www.example.com</a> before?</p>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testLinkBare_withoutAutoHyperLink()
    {
        let input = "Have you visited http://www.example.com before?"
        let expected = "<p>Have you visited http://www.example.com before?</p>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testLinkBare_withAutoHyperLink()
    {
        //TODO: implement some way of setting AutoHyperLink programmatically
        //to run this test now, just change the _autoHyperlink constant in Markdown.cs
        let input = "Have you visited http://www.example.com before?"
        let expected = "<p>Have you visited <a href=\"http://www.example.com\">http://www.example.com</a> before?</p>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testLinkAlt()
    {
        let input = "Have you visited [example](http://www.example.com) before?"
        let expected = "<p>Have you visited <a href=\"http://www.example.com\">example</a> before?</p>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testImage()
    {
        let input = "An image goes here: ![alt text][1]\n\n  [1]: http://www.google.com/intl/en_ALL/images/logo.gif"
        let expected = "<p>An image goes here: <img src=\"http://www.google.com/intl/en_ALL/images/logo.gif\" alt=\"alt text\" /></p>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testBlockquote()
    {
        let input = "Here is a quote\n\n> Sample blockquote\n> Sample blockquote\n"
        let expected = "<p>Here is a quote</p>\n\n<blockquote>\n  <p>Sample blockquote</p>\n</blockquote>\n"
        
        STAssertTransform(input, expected)
    }

    #if true // This test leads to "fatal error: unexpectedly found nil while unwrapping an Optional value
    func testNumberList()
    {
        let input = "A numbered list:\n\n1. a\n2. b\n3. c\n";
        let expected = "<p>A numbered list:</p>\n\n<ol>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n</ol>\n";
        
        STAssertTransform(input, expected)
    }
    #endif
    
    func testBulletList()
    {
        let input = "A bulleted list:\n\n- a\n- b\n- c\n"
        let expected = "<p>A bulleted list:</p>\n\n<ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n</ul>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testHeader1()
    {
        let input = "#Header 1\nHeader 1\n========"
        let expected = "<h1>Header 1</h1>\n\n<h1>Header 1</h1>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testHeader2()
    {
        let input = "##Header 2\nHeader 2\n--------"
        let expected = "<h2>Header 2</h2>\n\n<h3>Header 3</h3>\n<h4>Header 4</h4>\n<h5>Header 5</h5>\n<h6>Header 6</h6>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testCodeBlock()
    {
        let input = "code sample:\n\n```\n<head>\n<title>page title</title>\n</head>\n```"
        let expected = "<p>code sample:</p>\n\n<pre><code>&lt;head&gt;\n&lt;title&gt;page title&lt;/title&gt;\n&lt;/head&gt;\n</code></pre>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testCodeSpan()
    {
        let input = "HTML contains the `<blink>` tag"
        let expected = "<p>HTML contains the <code>&lt;blink&gt;</code> tag</p>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testHtmlPassthrough()
    {
        let input = "<div>\nHello World!\n</div>\n"
        let expected = "<div>\nHello World!\n</div>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testEscaping()
    {
        let input = "\\`foo\\`";
        let expected = "<p>`foo`</p>\n"
        
        STAssertTransform(input, expected)
    }
    
    func testHorizontalRule()
    {
        let input = "* * *\n\n***\n\n*****\n\n- - -\n\n---------------------------------------\n\n"
        let expected = "<hr />\n\n<hr />\n\n<hr />\n\n<hr />\n\n<hr />\n"
        
        STAssertTransform(input, expected)
    }
    
    func testMailTo()
    {
        let input = "email: jyhong@mail.com"
        let expected = "email: <a href=\"mailto:jyhong@mail.com\">jyhong@mail.com</a>"
        
        STAssertTransform(input, expected)
    }
}
