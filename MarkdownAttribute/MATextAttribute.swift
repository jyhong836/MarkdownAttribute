//
//  MATextAttribute.swift
//  MarkdownAttribute
//
//  Created by Junyuan Hong on 10/5/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

class MATextAttribute: MATextAttributeProtocol {

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
    
    var emphasis: AttributeDict {
        get {
            return [ : ]
        }
    }
    var strong: AttributeDict {
        get {
            return [ : ]
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
