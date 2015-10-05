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
    
    private var attributeProvider: MATextAttributesProvider
    
    /// Create generator with MATextAttributesProvider.
    /// By default the provider is MATextAttributes.
    init(textAttributesProvider provider: MATextAttributesProvider = MATextAttributes()) {
        attributeProvider = provider
    }
    
    /// Temperate storage of document
    private var document: MMDocument?
    
    /// Generate NSAttributedString from MMDocument.
    func generateAttributedString(document: MMDocument) -> NSAttributedString {
        
        self.document = document
        
        let markdown = NSString(string: document.markdown!)
        
        let astr = NSMutableAttributedString()
        
        for element in (document.elements as? [MMElement])! {
            if element.type == MMElementTypeHTML {
                attributedStringFromHTML(markdown.substringWithRange(element.range))
            } else {
                generate(attributedString: astr, element: element, baseAttributes: nil)
            }
        }
        
        return astr
    }
    
    /// Using MMElement to generate NSAttributedString, and add to input string.
    /// Set the document of instance before invoke this method.
    ///
    /// - parameter attributedString: a mutable attributed string to store changes.
    /// - parameter element: a element which stored markdown string type.
    /// - parameter baseAttributes: the based attributes.
    private func generate(attributedString astr: NSMutableAttributedString, element: MMElement, baseAttributes: AttributeDict?) {
        let (elemAttrs, newLine) = attributesForElement(element)
        
        // Add some character for special element type
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
        
        for child in element.children as! [MMElement] {
            if child.type == MMElementTypeNone {
                if child.range.length == 0 {
                    astr.appendAttributedString(NSAttributedString(string: "\n"))
                    // TODO: apply attributes??
                } else {
                    var newAttributes = elemAttrs
                    if let baseAttr = baseAttributes {
                        for (key, value) in baseAttr {
                            if newAttributes[key] == nil {
                                newAttributes[key] = value
                            } // TODO: process font traits
                        }
                    }
                    let appendedString = NSAttributedString(string: NSString(string: document!.markdown).substringWithRange(child.range), attributes: newAttributes)
                    astr.appendAttributedString(appendedString)
                }
            } else if (child.type == MMElementTypeHTML) {
                attributedStringFromHTML(NSString(string: document!.markdown).substringWithRange(child.range))
                // TODO: apply attributes??
            } else {
                generate(attributedString: astr, element: child, baseAttributes: elemAttrs)
            }
        }
        
        if newLine {
            astr.appendAttributedString(NSAttributedString(string: "\n"))
        }
    }
    
    /// Use NSAttributedString initialzer to create string from HTML.
    /// If failed, a fatalError will occure.
    func attributedStringFromHTML(HTML: NSString) -> NSAttributedString {
        do {
            return try NSAttributedString(data: HTML.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
        } catch {
            fatalError("Fail to create attributed string from html: \(error)")
        }
    }
    
    /// Get attributes according to MMElement.
    private func attributesForElement(element: MMElement) -> ([String: AnyObject], newLine: Bool) {
        switch element.type.rawValue { // TODO: Remove `.rawValue` when Swift 2.1 available.
        case MMElementTypeHeader.rawValue:
            return (attributeProvider.header(Int(element.level)), true)
            
        case MMElementTypeBulletedList.rawValue:
            return (attributeProvider.unorderedList, true)
        case MMElementTypeNumberedList.rawValue:
            return (attributeProvider.orderedList, true)
        case MMElementTypeListItem.rawValue:
            return (attributeProvider.listItem, true)
            
        case MMElementTypeEm.rawValue:
            if attributeProvider.emphasis[NSFontAttributeName] != nil {
                return (attributeProvider.emphasis, false)
            }
            // TODO: add font trait
            else {
                return ([:], false)
//                return (NSFontItalicTrait, false)
            }
        case MMElementTypeStrong.rawValue:
            return (attributeProvider.strong, false)
            
        case MMElementTypeLink.rawValue:
            var attr = attributeProvider.link
            attr[NSLinkAttributeName] = NSURL(string: element.href)
            #if os(OSX)
                if let t = element.title {
                    attr[NSToolTipAttributeName] = t
                }
            #endif
            return (attr, true)
        // code
        case MMElementTypeCodeBlock.rawValue:
            return (attributeProvider.codeBlock, true)
        case MMElementTypeCodeSpan.rawValue:
            return (attributeProvider.inlineCode, false)
            
        case MMElementTypeBlockquote.rawValue:
            return (attributeProvider.blockQuote, true)
        // line break
        case MMElementTypeLineBreak.rawValue:
            return ([:], true)
        case MMElementTypeParagraph.rawValue:
            return (attributeProvider.paragraph, true)
            
        case MMElementTypeStrikethrough.rawValue:
            return ([:], false)
        case MMElementTypeHorizontalRule.rawValue:
            return ([:], false)
        case MMElementTypeImage.rawValue:
            return ([:], false)
        case MMElementTypeMailTo.rawValue:
            return ([:], false)
        case MMElementTypeDefinition.rawValue:
            return ([:], false)
        case MMElementTypeEntity.rawValue:
            return ([:], false)
        case MMElementTypeTable.rawValue:
            return ([:], false)
        case MMElementTypeTableHeader.rawValue:
            return ([:], false)
        case MMElementTypeTableHeaderCell.rawValue:
            return ([:], false)
        case MMElementTypeTableRow.rawValue:
            return ([:], false)
        case MMElementTypeTableRowCell.rawValue:
            return ([:], false)
        default:
            return ([:], false)
        }
    }

}
