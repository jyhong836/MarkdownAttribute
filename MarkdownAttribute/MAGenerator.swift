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

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

class MAGenerator {
    
    func generateAttributedString(document: MMDocument) -> NSAttributedString {
        
        let markdown = NSString(string: document.markdown!)
        var location = UInt(0)
        
        let astr = NSMutableAttributedString()
        
        for element in (document.elements as? [MMElement])! {
            if element.type == MMElementTypeHTML {
                attributedStringFromHTML(markdown.substringWithRange(element.range))
            } else {
                generate(attributedString: astr, element: element, document: document, location: &location)
            }
        }
        
        return astr
    }
    
    private func generate(attributedString astr: NSMutableAttributedString, element: MMElement, document: MMDocument, inout location: UInt) {
        let (attribute, newLine) = attributesForElement(element)
        
        switch element.type.rawValue {
        case MMElementTypeNumberedList.rawValue:
            element.level = 0 // FIXME: This is a workaround, fix it in future
        case MMElementTypeListItem.rawValue:
            switch element.parent.type.rawValue {
            case MMElementTypeBulletedList.rawValue:
                astr.appendAttributedString(NSAttributedString(string: "\u{2022} "))
            case MMElementTypeNumberedList.rawValue:
                element.parent.level++
                astr.appendAttributedString(NSAttributedString(string: "\(element.parent.level). "))
            default:
                fatalError("Parent of list item must be list")
            }
        case MMElementTypeCodeBlock.rawValue:
            break
        default: break
        }
        
        let startIdx = astr.length
        
        for child in element.children as! [MMElement] {
            if child.type == MMElementTypeNone {
                if child.range.length == 0 {
                    astr.appendAttributedString(NSAttributedString(string: "\n"))
                } else {
                    astr.appendAttributedString(NSAttributedString(string: NSString(string: document.markdown).substringWithRange(child.range)))
                }
            } else if (child.type == MMElementTypeHTML) {
                attributedStringFromHTML(NSString(string: document.markdown).substringWithRange(child.range))
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
    
    func attributedStringFromHTML(HTML: NSString) -> NSAttributedString {
        do {
            return try NSAttributedString(data: HTML.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
        } catch {
            fatalError("Fail to create attributed string from html.")
        }
    }
    
    private let cmattributes = MATextAttribute()
    
    private func attributesForElement(element: MMElement) -> ([String: AnyObject]?, newLine: Bool) {
        switch element.type.rawValue { // TODO: Remove `.rawValue` when Swift 2.1 available.
        case MMElementTypeHeader.rawValue:
            return (cmattributes.header(Int(element.level)), true)
            
        case MMElementTypeBulletedList.rawValue:
            return (cmattributes.unorderedList, true)
        case MMElementTypeNumberedList.rawValue:
            return (cmattributes.orderedList, true)
        case MMElementTypeListItem.rawValue:
            return (cmattributes.listItem, true)
            
        case MMElementTypeEm.rawValue:
            if cmattributes.emphasis[NSFontAttributeName] != nil {
                return (cmattributes.emphasis, false)
            }
            // TODO: add font trait
            else {
                return (nil, false)
//                return (NSFontItalicTrait, false)
            }
            
        case MMElementTypeLink.rawValue:
            var attr = cmattributes.link
            attr[NSLinkAttributeName] = NSURL(string: element.href)
            #if os(OSX)
                if let t = element.title {
                    attr[NSToolTipAttributeName] = t
                }
            #endif
            return (attr, true)
        // code
        case MMElementTypeCodeBlock.rawValue:
            return (cmattributes.codeBlock, true)
        case MMElementTypeCodeSpan.rawValue:
            return (cmattributes.inlineCode, false)
            
        case MMElementTypeBlockquote.rawValue:
            return (cmattributes.blockQuote, true)
        // line break
        case MMElementTypeLineBreak.rawValue:
            return (nil, true)
        case MMElementTypeParagraph.rawValue:
            return (nil, true)
            
        default:
            return (nil, false)
        }
    }

}
