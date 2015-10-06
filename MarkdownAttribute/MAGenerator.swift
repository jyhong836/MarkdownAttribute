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
    
    typealias MAFontSymbolicTraits = NSFontSymbolicTraits
    typealias MAFont = NSFont
    typealias CMUnderlineStyle = NSInteger
    
    let CMFontTraitItalic = UInt32(NSFontItalicTrait)
    let CMFontTraitBold = UInt32(NSFontBoldTrait)
#elseif os(iOS)
    import UIKit
    
    typealias MAFontSymbolicTraits = UIFontDescriptorSymbolicTraits
    typealias MAFont = UIFont
    typealias CMUnderlineStyle = NSUnderlineStyle
    
    let CMFontTraitItalic = UIFontDescriptorSymbolicTraits.TraitItalic
    let CMFontTraitBold = UIFontDescriptorSymbolicTraits.TraitBold
#endif

/// A generator is used to generate NSAttributedString according to given MMDocument.
class MAGenerator {
    
    private var attributeProvider: MATextAttributesProvider
    
    /// Create generator with MATextAttributesProvider.
    /// By default the provider is MATextAttributes.
    init(textAttributesProvider provider: MATextAttributesProvider) {
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
                generate(attributedString: astr, element: element, baseAttributes: attributeProvider.text)
            }
        }
        
        return astr
    }
    
    // MARK: - Private generate method
    
    /// New attributes will be added to base attributes. 
    /// If there are duplicated attributes, the new one will be used.
    private func combineAttributes(new new: AttributeDict, base: AttributeDict?) -> AttributeDict {
        if new.count == 0 {
            return (base != nil) ? base! : new
        }
        var combined = new
        if let baseAttr = base {
            for (key, value) in baseAttr {
                if combined[key] == nil {
                    combined[key] = value
                } else { // TODO: process font traits
                    // conflict keys
                    #if os(OSX)
                        if key == NSParagraphStyleAttributeName {
                            // Combine text lists.
                            let baseLists = (value as! NSParagraphStyle).textLists
                            let newPS = combined[key] as! NSMutableParagraphStyle
                            newPS.textLists = baseLists + newPS.textLists
                            combined[key] = newPS
                        }
                    #endif
                }
            }
        }
        return combined
    }
    
    #if os(OSX)
        /// Get list item marker and relevant characters in string, which
        /// will be added to the header of item line. The count of lists 
        /// must larger than 0.
        private func listItemMarkerFromTextLists(lists: [NSTextList], number: UInt) -> String {
            return "".stringByPaddingToLength(lists.count, withString: "\t", startingAtIndex: 0) +
                "\(lists.last!.markerForItemNumber(Int(number))) "
        }
    #endif
    
    /// Using MMElement to generate NSAttributedString, and add to input string.
    /// Set the document of instance before invoke this method.
    ///
    /// - parameter attributedString: a mutable attributed string to store changes.
    /// - parameter element: a element which stored markdown string type.
    /// - parameter baseAttributes: the based attributes.
    private func generate(attributedString astr: NSMutableAttributedString, element: MMElement, baseAttributes: AttributeDict?) {
        let (elemAttrs, newLine) = attributesForElement(element)
        let newAttributes = combineAttributes(new: elemAttrs, base: baseAttributes)
        
        // Add some character for special element type
        switch element.type.rawValue {
        case MMElementTypeBulletedList.rawValue:
            fallthrough
        case MMElementTypeNumberedList.rawValue:
            element.level = 0 // FIXME: This is a workaround, fix it in future
            // TODO: add NSTextList to paragraphStyle array
        case MMElementTypeListItem.rawValue:
            let ps = newAttributes[NSParagraphStyleAttributeName] as! NSParagraphStyle
            #if os(OSX)
                element.parent.level++
                astr.appendAttributedString(NSAttributedString(string: listItemMarkerFromTextLists(ps.textLists, number: element.parent.level)))
            #elseif os(iOS)
                switch element.parent.type.rawValue {
                case MMElementTypeBulletedList.rawValue:
                    astr.appendAttributedString(NSAttributedString(string: "\t\u{2022}\t"))
                case MMElementTypeNumberedList.rawValue:
                    element.parent.level++
                    astr.appendAttributedString(NSAttributedString(string: "\t\(element.parent.level).\t"))
                default:
                    fatalError("Parent of list item must be list")
                }
            #endif
//        case MMElementTypeCodeBlock.rawValue:
//            break
        case MMElementTypeEntity.rawValue:
            astr.appendAttributedString(NSAttributedString(string: element.stringValue))
        default: break
        }
        
        for child in element.children as! [MMElement] {
            if child.type == MMElementTypeNone {
                if child.range.length == 0 {
                    astr.appendAttributedString(NSAttributedString(string: "\n"))
                    // TODO: apply attributes??
                } else {
                    let appendedString = NSAttributedString(string: NSString(string: document!.markdown).substringWithRange(child.range), attributes: newAttributes)
                    astr.appendAttributedString(appendedString)
                }
            } else if (child.type == MMElementTypeHTML) {
                attributedStringFromHTML(NSString(string: document!.markdown).substringWithRange(child.range))
                // TODO: apply attributes??
            } else {
                generate(attributedString: astr, element: child, baseAttributes: newAttributes)
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
//        case MMElementTypeEntity.rawValue: // no attributes
//            return ([:], false)
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
