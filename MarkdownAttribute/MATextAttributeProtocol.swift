//
//  MATextAttributeProtocol.swift
//  MarkdownAttribute
//
//  Created by Junyuan Hong on 10/5/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

typealias AttributeDict = [String : AnyObject]

/// Provide text attributes for markdown.
protocol MATextAttributeProtocol {
    
    var text: AttributeDict { get }
    
    var paragraph: AttributeDict { get }
    
    var header1: AttributeDict { get }
    var header2: AttributeDict { get }
    var header3: AttributeDict { get }
    var header4: AttributeDict { get }
    var header5: AttributeDict { get }
    var header6: AttributeDict { get }
    
    var emphasis: AttributeDict { get }
    var strong: AttributeDict { get }
    
    var link: AttributeDict { get }
    
    var codeBlock: AttributeDict { get }
    var inlineCode: AttributeDict { get }
    
    var blockQuote: AttributeDict { get }
    
    var orderedList: AttributeDict { get }
    var unorderedList: AttributeDict { get }
    var listItem: AttributeDict { get }

}
