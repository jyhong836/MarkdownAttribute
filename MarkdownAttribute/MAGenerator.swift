//
//  MAGenerator.swift
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

import Cocoa

class MAGenerator {
    
    func generateAttributedString(document: MMDocument) -> NSAttributedString {
        
        let markdown = NSString(string: document.markdown!)
        var location = UInt(0)
        
        let astr = NSMutableAttributedString()
        
        for element in (document.elements as? [MMElement])! {
            if element.type == MMElementTypeHTML {
                astr.appendAttributedString(NSAttributedString(string: markdown.substringWithRange(element.range)))
            } else {
                generate(attributedString: astr, element: element, document: document, location: &location)
            }
        }
        
        return astr
    }
    
    private func generate(attributedString astr: NSMutableAttributedString, element: MMElement, document: MMDocument, inout location: UInt) {
        let (attribute, newLine) = attributesForElement(element)
        let startIdx = astr.length
        
        for child in element.children as! [MMElement] {
            if child.type == MMElementTypeNone {
                if document.markdown.isEmpty {
                    astr.appendAttributedString(NSAttributedString(string: "\n"))
                } else {
                    astr.appendAttributedString(NSAttributedString(string: NSString(string: document.markdown).substringWithRange(child.range)))
                }
            } else if (child.type == MMElementTypeHTML) {
                astr.appendAttributedString(NSAttributedString(string: NSString(string: document.markdown).substringWithRange(child.range)))
            } else {
                generate(attributedString: astr, element: child, document: document, location: &location)
            }
        }
        
        let endIdx = astr.length
        if let attr = attribute {
            astr.setAttributes(attr, range: NSMakeRange(startIdx, endIdx - startIdx))
        }
        if newLine {
            astr.appendAttributedString(NSAttributedString(string: "\n"))
        }
    }
    
    private let cmattributes = CMTextAttributes()
    
    private func attributesForElement(element: MMElement) -> ([String: AnyObject]?, newLine: Bool) {
        switch element.type.rawValue { // TODO: Remove `.rawValue` when Swift 2.1 available.
        case MMElementTypeHeader.rawValue:
            return (cmattributes.attributesForHeaderLevel(Int(element.level)), true)
        case MMElementTypeBulletedList.rawValue:
            return (cmattributes.unorderedListAttributes, true)
        case MMElementTypeNumberedList.rawValue:
            return (cmattributes.orderedListAttributes, true)
        case MMElementTypeListItem.rawValue:
            return (cmattributes.unorderedListItemAttributes, true)
        case MMElementTypeEm.rawValue:
            return (cmattributes.emphasisAttributes, false)
        case MMElementTypeLink.rawValue:
            return (cmattributes.linkAttributes, true)
        case MMElementTypeCodeBlock.rawValue:
            return (cmattributes.codeBlockAttributes, true)
        case MMElementTypeCodeSpan.rawValue:
            return (cmattributes.inlineCodeAttributes, false)
        case MMElementTypeBlockquote.rawValue:
            return (cmattributes.blockQuoteAttributes, true)
        case MMElementTypeLineBreak.rawValue:
            return (nil, true)
        default:
            return (nil, false)
        }
    }

}
