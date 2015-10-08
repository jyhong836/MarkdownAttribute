//
//  MATextAttributesProtocol.swift
//  MarkdownAttribute
//
//  Created by Junyuan Hong on 10/5/15.
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

public typealias AttributeDict = [String : AnyObject]

/// Provide text attributes for markdown.
public protocol MATextAttributesProvider {
    
    var text: AttributeDict { get }
    
    var paragraph: AttributeDict { get }
    
    func header(level: Int) -> AttributeDict
    var header1: AttributeDict { get }
    var header2: AttributeDict { get }
    var header3: AttributeDict { get }
    var header4: AttributeDict { get }
    var header5: AttributeDict { get }
    var header6: AttributeDict { get }
    
    var emphasis: AttributeDict { get }
    var strong: AttributeDict { get }
    
    var link: AttributeDict { get }
    var strikethrough: AttributeDict { get }
    
    var codeBlock: AttributeDict { get }
    var inlineCode: AttributeDict { get }
    
    var blockQuote: AttributeDict { get }
    
    func orderedList(paraentIsList: Bool) -> AttributeDict
    func unorderedList(paraentIsList: Bool) -> AttributeDict
    var listItem: AttributeDict { get }

}
