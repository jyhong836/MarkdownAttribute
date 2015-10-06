//
//  MATextAttribute.swift
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

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

class MATextAttributes: MATextAttributesProvider {
    
    let defaultFont = NSFont(name: "Times-Roman", size: 12.0)
    let defaultBoldFont = NSFont(name: "Times-Bold", size: 12.0)
    
    var text: AttributeDict {
        get {
            #if os(OSX)
                return [NSFontAttributeName : NSFont.userFontOfSize(12.0)!]
            #elseif os(iOS)
                return [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
            #endif
        }
    }
    
    var paragraph: AttributeDict {
        get {
            let ps = NSMutableParagraphStyle()
            ps.paragraphSpacing = 12.0
            ps.defaultTabInterval = 36
            return [NSParagraphStyleAttributeName : ps]
        }
    }

    var header1: AttributeDict {
        get {
            #if os(OSX)
                return [NSFontAttributeName : NSFont.userFontOfSize(24.0)!]
                #elseif os(iOS)
                return [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            #endif
        }
    }
    
    var header2: AttributeDict {
        get {
            #if os(OSX)
                return [NSFontAttributeName : NSFont.userFontOfSize(18.0)!]
                #elseif os(iOS)
                return [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            #endif
        }
    }
    
    var header3: AttributeDict {
        get {
            #if os(OSX)
                return [NSFontAttributeName : NSFont.userFontOfSize(14.0)!]
                #elseif os(iOS)
                return [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            #endif
        }
    }
    
    var header4: AttributeDict {
        get {
            #if os(OSX)
                return [NSFontAttributeName : NSFont.userFontOfSize(12.0)!]
                #elseif os(iOS)
                return [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            #endif
        }
    }
    
    var header5: AttributeDict {
        get {
            #if os(OSX)
                return [NSFontAttributeName : NSFont.userFontOfSize(10.0)!]
                #elseif os(iOS)
                return [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            #endif
        }
    }
    
    var header6: AttributeDict {
        get {
            #if os(OSX)
                return [NSFontAttributeName : NSFont.userFontOfSize(8.0)!]
                #elseif os(iOS)
                return [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            #endif
        }
    }
    
    func header(level: Int) -> AttributeDict {
        switch (level) {
        case 1: return header1
        case 2: return header2
        case 3: return header3
        case 4: return header4
        case 5: return header5
        case 6: fallthrough
        default: return header6
        }
    }
    
    var emphasis: AttributeDict {
        get {
            return [NSFontAttributeName : defaultBoldFont!]
        }
    }
    var strong: AttributeDict {
        get {
            return [NSFontAttributeName : defaultBoldFont!]
        }
    }
    
    var link: AttributeDict {
        get {
            #if os(OSX)
                return [NSForegroundColorAttributeName : NSColor.blueColor(),
                        NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
                #elseif os(iOS)
                return [NSForegroundColorAttributeName : UIColor.blueColor(),
                        NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
            #endif
        }
    }
    
    var indentedPraragraphStyle: NSParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.firstLineHeadIndent = 30
            style.headIndent = 30
            return style
        }
    }
    
    #if os(iOS)
    var MonospaceFont: UIFont {
        get {
            let size = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).pointSize
            if let mfont = UIFont(name: "Menlo", size: size) {
                return mfont
            } else {
                return UIFont(name: "Courier", size: size)!
            }
        }
    }
    #endif
    
    var codeBlock: AttributeDict {
        get {
            #if os(OSX)
                return [NSFontAttributeName : NSFont.userFixedPitchFontOfSize(12.0)!, NSParagraphStyleAttributeName : indentedPraragraphStyle]
                #elseif os(iOS)
                return [NSFontAttributeName : MonospaceFont, NSParagraphStyleAttributeName : indentedPraragraphStyle]
            #endif
        }
    }
    var inlineCode: AttributeDict {
        get {
            #if os(OSX)
                return [NSFontAttributeName : NSFont.userFixedPitchFontOfSize(12.0)!]
                #elseif os(iOS)
                return [NSFontAttributeName : MonospaceFont]
            #endif
        }
    }
    
    var blockQuote: AttributeDict {
        get {
            return [NSParagraphStyleAttributeName : indentedPraragraphStyle]
        }
    }
    
    var orderedList: AttributeDict {
        get {
            return [NSParagraphStyleAttributeName : indentedPraragraphStyle]
        }
    }
    var unorderedList: AttributeDict {
        get {
            return [NSParagraphStyleAttributeName : indentedPraragraphStyle]
        }
    }
    var listItem: AttributeDict {
        get {
            return [ : ]
        }
    }
    
}