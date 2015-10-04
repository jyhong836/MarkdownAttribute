//
//  MarkdownAttributeTests.swift
//  MarkdownAttributeTests
//
//  Created by Junyuan Hong on 10/3/15.
//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Junyuan Hong
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import XCTest
@testable import MarkdownAttribute

class MarkdownAttributeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
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
        } catch {
            NSLog("\(error)")
        }
        

    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
