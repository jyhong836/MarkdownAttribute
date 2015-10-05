//
//  Colorfy.swift
//
//  Install XcodeColors plugin to view console color.
//

import Foundation

/** Colorfy Struct

*/
struct Colorfy {
    static let ESCAPE = "\u{001b}["
    
    static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    static let RESET_BG = ESCAPE + "bg;" // Clear any background color
    static let RESET = ESCAPE + ";"   // Clear any foreground or background color
    
    static func color<T>(object: T, r: UInt8, g: UInt8, b: UInt8) -> String {
        return "\(ESCAPE)fg\(r),\(g),\(b);\(object)\(RESET)"
    }
    
    static func red<T>(object: T) -> String {
        return "\(ESCAPE)fg255,0,0;\(object)\(RESET)"
    }
    
    static func green<T>(object:T) -> String {
        return "\(ESCAPE)fg0,255,0;\(object)\(RESET)"
    }
    
    static func blue<T>(object:T) -> String {
        return "\(ESCAPE)fg0,0,255;\(object)\(RESET)"
    }
    
    static func yellow<T>(object:T) -> String {
        return "\(ESCAPE)fg255,255,0;\(object)\(RESET)"
    }
    
    static func purple<T>(object:T) -> String {
        return "\(ESCAPE)fg255,0,255;\(object)\(RESET)"
    }
    
    static func cyan<T>(object:T) -> String {
        return "\(ESCAPE)fg0,255,255;\(object)\(RESET)"
    }
}
