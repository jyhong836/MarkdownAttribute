//
//  MAMarkdown.swift
//  MarkdownAttribute
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

public class MAMarkdown {
    
    public var textAttributesProvider: MATextAttributesProvider {
        didSet {
            generator = MAGenerator(textAttributesProvider: textAttributesProvider)
        }
    }
    public var extensions: MMMarkdownExtensions {
        didSet {
            parser = MMParser(extensions: extensions)
        }
    }
    
    private var parser: MMParser
    private var generator: MAGenerator
    
    public init(textAttributesProvider: MATextAttributesProvider = MATextAttributes(), extensions: MMMarkdownExtensions = .None) {
        self.textAttributesProvider = textAttributesProvider
        self.extensions = extensions
        
        generator = MAGenerator(textAttributesProvider: textAttributesProvider)
        parser = MMParser(extensions: extensions)
    }
    
    /// Convert Markdown string to NSAttributedString.
    public func attributedString(markdown mstring: String?) throws -> NSAttributedString {
        if mstring == nil || mstring!.isEmpty {
            return NSAttributedString()
        }
        
        let document = try parser.parseMarkdown(mstring) // would return nil?
        
        return generator.generateAttributedString(document)
    }
    
}
