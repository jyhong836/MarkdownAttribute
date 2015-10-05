//
//  MATextAttribute.swift
//  MarkdownAttribute
//
//  Created by Junyuan Hong on 10/5/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

class MATextAttribute: MATextAttributeProtocol {

    var header1: AttributeDict {
        get {
            return [NSFontAttributeName : NSFont.userFontOfSize(24.0)!]
        }
    }
    
    var header2: AttributeDict {
        get {
            return [NSFontAttributeName : NSFont.userFontOfSize(18.0)!]
        }
    }
    
    var header3: AttributeDict {
        get {
            return [NSFontAttributeName : NSFont.userFontOfSize(14.0)!]
        }
    }
    
    var header4: AttributeDict {
        get {
            return [NSFontAttributeName : NSFont.userFontOfSize(12.0)!]
        }
    }
    
    var header5: AttributeDict {
        get {
            return [NSFontAttributeName : NSFont.userFontOfSize(10.0)!]
        }
    }
    
    var header6: AttributeDict {
        get {
            return [NSFontAttributeName : NSFont.userFontOfSize(8.0)!]
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
            return [NSForegroundColorAttributeName : NSColor.blueColor(), NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
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
    
    var codeBlock: AttributeDict {
        get {
            return [NSFontAttributeName : NSFont.userFixedPitchFontOfSize(12.0)!, NSParagraphStyleAttributeName : indentedPraragraphStyle]
        }
    }
    var inlineCode: AttributeDict {
        get {
            return [NSFontAttributeName : NSFont.userFixedPitchFontOfSize(12.0)!]
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
