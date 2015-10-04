//
//  NSAttributedString+Diff.swift
//  NSAttributedString+Diff
//
//  File from Markingbird
//

import Foundation

extension NSAttributedString {

    /// Find first different range between two strings.
    ///
    /// - parameter otherString: The NSAttributedString to be compared
    ///
    /// - returns: .DifferenceAtIndex(i), .DifferenceInRange(range),
    /// or .NoDifference
    func firstDifferenceToString(otherString as2: NSAttributedString) -> FirstDifferenceResult {
        let len1 = self.length
        let len2 = as2.length
        
        let compareLen = min(len1, len2)
        
        var diffRange: NSRange?
        self.enumerateAttributesInRange(NSMakeRange(0, compareLen), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (attrs, range, stop) -> Void in
            if !self.attributedSubstringFromRange(range).isEqualToAttributedString(as2.attributedSubstringFromRange(range)) {
                diffRange = range
                stop.memory = true
            }
        }
        if let dr = diffRange {
            return .DifferenceInRange(dr)
        }
        if len1 == len2 {
            return .NoDifference
        } else if len1 < len2 {
            return .DifferenceAtIndex(len1)
        } else {
            return .DifferenceAtIndex(len2)
        }
    }


    /// Create a formatted String representation of difference between strings
    ///
    /// - parameter otherString: The NSAttributedString to be compared
    ///
    /// - returns: a string, possibly containing significant whitespace and newlines
    public func prettyFirstDifferenceToSting(otherString s2: NSAttributedString) -> NSString {
        let firstDifferenceResult = self.firstDifferenceToString(otherString: s2)
        return prettyDescriptionOfFirstDifferenceResult(firstDifferenceResult, otherString: s2)
    }
    
    func prettyDiffAttributes(inRange range: NSRange, otherString s2: NSAttributedString) -> String {
        var effRange1 = range
        var effRange2 = range
        let attrs1 = self.attributesAtIndex(range.location, longestEffectiveRange: &effRange1, inRange: range)
        let attrs2 = s2.attributesAtIndex(range.location, longestEffectiveRange: &effRange2, inRange: range)
        
//        let len1 = attrs1.count
//        let len2 = attrs2.count
        
//        let (attrs, comparedAttrs) = (len1 > len2) ? (attrs1, attrs2) : (attrs2, attrs1)
        
        var diffDescription = "Attributes:\n"
        
        // TODO: print the value different
        diffDescription += "\(attrs1.count) attrs:"
        for (name, val) in attrs1 {
            diffDescription += " \(name) "
        }
        diffDescription += "\n"
        diffDescription += "\(attrs2.count) attrs:"
        for (name, val) in attrs2 {
            diffDescription += " \(name) "
        }
        diffDescription += "\n"
        
        return diffDescription
    }


    /// Create a formatted String representation of a FirstDifferenceResult for two strings
    ///
    /// - parameter firstDifferenceResult: FirstDifferenceResult
    /// - parameter s1: First string used in generation of firstDifferenceResult
    /// - parameter s2: Second string used in generation of firstDifferenceResult
    ///
    /// - returns: a printable string, possibly containing significant whitespace and newlines
    public func prettyDescriptionOfFirstDifferenceResult(firstDifferenceResult: FirstDifferenceResult, otherString s2: NSAttributedString) -> NSString {

        func diffString(index: Int, s1: NSAttributedString, s2: NSAttributedString) -> String {
            let markerArrow = "\u{2b06}"  // "⬆"
            let ellipsis    = "\u{2026}"  // "…"

            /// Given a string and a range, return a string representing that substring.
            ///
            /// If the range starts at a position other than 0, an ellipsis
            /// will be included at the beginning.
            ///
            /// If the range ends before the actual end of the string,
            /// an ellipsis is added at the end.
            func windowSubstring(s: NSAttributedString, range: NSRange) -> String {
                let validRange = NSMakeRange(range.location, min(range.length, s.length - range.location))
                let substring = s.attributedSubstringFromRange(validRange).string

                let prefix = range.location > 0 ? ellipsis : ""
                let suffix = (s.length - range.location > range.length) ? ellipsis : ""

                return "\(prefix)\(substring)\(suffix)"
            }

            // Show this many characters before and after the first difference
            let windowPrefixLength = 10
            let windowSuffixLength = 10
            let windowLength = windowPrefixLength + 1 + windowSuffixLength

            let windowIndex = max(index - windowPrefixLength, 0)
            let windowRange = NSMakeRange(windowIndex, windowLength)

            let sub1 = windowSubstring(s1, range: windowRange)
            let sub2 = windowSubstring(s2, range: windowRange)

            let markerPosition = min(windowSuffixLength, index) + (windowIndex > 0 ? 1 : 0)

            let markerPrefix = String(count: markerPosition, repeatedValue: " " as Character)
            let markerLine = "\(markerPrefix)\(markerArrow)"

            return "Difference at index \(index):\n\(sub1)\n\(sub2)\n\(markerLine)"
        }

        switch firstDifferenceResult {
        case .NoDifference:                 return "No difference"
        case .DifferenceAtIndex(let index): return diffString(index, s1: self, s2: s2)
        case .DifferenceInRange(let range):
            return ["Difference(maybe attribute) in range: \(range.location) \u{2026} \(range.location+range.length - 1)",
                "",
                diffString(range.location, s1: self, s2: s2),
                self.prettyDiffAttributes(inRange: range, otherString: s2)].joinWithSeparator("\n")
        }
    }
}


/// Result type for firstDifferenceBetweenStrings()
public enum FirstDifferenceResult {
    /// Strings are identical
    case NoDifference

    /// Strings differ at the specified index.
    ///
    /// This could mean that characters at the specified index are different,
    /// or that one string is longer than the other
    case DifferenceAtIndex(Int)
    
    /// NSAttributedString differ in specified range.
    ///
    /// This means that characters and corresponding attributes in the
    /// specified range are different.
    case DifferenceInRange(NSRange)
}

extension FirstDifferenceResult: CustomStringConvertible, CustomDebugStringConvertible {
    /// Textual representation of a FirstDifferenceResult
    public var description: String {
        switch self {
        case .NoDifference:
            return "NoDifference"
        case .DifferenceInRange(let range):
            return "DifferenceInRange(\(range))"
        case .DifferenceAtIndex(let index):
            return "DifferenceAtIndex(\(index))"
        }
    }

    /// Textual representation of a FirstDifferenceResult for debugging purposes
    public var debugDescription: String {
        return self.description
    }
}
