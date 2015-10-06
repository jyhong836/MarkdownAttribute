//
//  MDTestTests.swift
//  MDTestTests
//
//  File from Markingbird
//

import Cocoa
import XCTest
//import Markingbird
@testable import MarkdownAttribute

class MDTestTests: XCTestCase {

    let folder = "testfiles/mdtest-1.1"
    
    /// For each .text file in testfiles/mdtest-1.1, invoke the Markdown transformation
    /// and then compare the result with the corresponding .html file
    func testTests() {
        for test in getTests() {
            
            // If there is a difference, print it in a more readable way than
            // XCTest does
            let prettyDiff = test.actualResult.prettyFirstDifferenceToSting(otherString: test.expectedResult)
            print("\n====\n\(test.actualName): \(prettyDiff)\n====\n")
            
            XCTAssertEqual(test.actualResult, test.expectedResult,
                "Mismatch between '\(test.actualName)' and the transformed '\(test.expectedName)'")
        }
    }

    struct TestCaseData {
        var actualName: String
        var expectedName: String
        var actualResult: NSAttributedString
        var expectedResult: NSAttributedString
        
        init(actualName: String, expectedName: String, actualResult: NSAttributedString, expectedResult: NSAttributedString) {
            self.actualName = actualName
            self.expectedName = expectedName
            self.actualResult = actualResult
            self.expectedResult = expectedResult
        }
    }
    
    func getTests() -> [TestCaseData] {
        let mm = MAMarkdown(extensions: MMMarkdownExtensions.GitHubFlavored)
        var tests = Array<TestCaseData>()
        
        let bundle = NSBundle(forClass: MDTestTests.self)
        let resourceURL = bundle.resourceURL!
        let folderURL = resourceURL.URLByAppendingPathComponent(folder)
        
        let folderContents: [AnyObject]?
        do {
            folderContents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(folderURL.path!)
        } catch {
            XCTAssertNil(error)
            folderContents = nil
        }
        XCTAssertNotNil(folderContents)
        XCTAssertEqual(49, folderContents!.count, "should find 49 files in the testfiles/mdtest-1.1 directory")
        
        for object in folderContents! {
            if let filename = object as? String {
                if filename.hasSuffix(".html") {
                    // Load the expected result content
                    let expectedName = filename
                    
                    let expectedURL = folderURL.URLByAppendingPathComponent(expectedName)
                    let expectedContent: NSAttributedString?
                    do {
                        expectedContent = try NSAttributedString(URL: expectedURL, options: [NSDocumentTypeDocumentOption : NSHTMLTextDocumentType], documentAttributes: nil)
                    } catch {
                        XCTFail("\(error)")
                        expectedContent = nil
                    }
                    
                    // Load the source content
                    let actualName = NSURL(string: expectedName)!.URLByDeletingPathExtension?.URLByAppendingPathExtension("text").path
                    let sourceURL = folderURL.URLByAppendingPathComponent(actualName!)
                    let sourceContent: String?
                    do {
                        sourceContent = try String(contentsOfURL: sourceURL, encoding: NSUTF8StringEncoding)
                    } catch {
                        XCTAssertNil(error)
                        sourceContent = nil
                    }
                    
                    if sourceContent != nil {
                        // Transform the source into the actual result, and
                        // normalize both the actual and expected results
                        do {
                            let actualResult = try mm.attributedString(markdown: sourceContent)
//                            let expectedResult = removeWhitespace(expectedContent!)
                            let expectedResult = expectedContent!
                            
                            let testCaseData = TestCaseData(
                                actualName: actualName!,
                                expectedName: expectedName,
                                actualResult: actualResult,
                                expectedResult: expectedResult)
                            tests.append(testCaseData)
                        } catch {
                            XCTFail("\(error)")
                        }
                    }
                }
            }
        }
        
        return tests
    }
    
    /// Removes any empty newlines and any leading spaces at the start of lines
    /// all tabs, and all carriage returns
    func removeWhitespace(s: String) -> String {
        var str = s as NSString
        
        // Standardize line endings
        str = str.stringByReplacingOccurrencesOfString("\r\n", withString: "\n")    // DOS to Unix
        str = str.stringByReplacingOccurrencesOfString("\r", withString:"\n")       // Mac to Unix
    
        // remove any tabs entirely
        str = str.stringByReplacingOccurrencesOfString("\t", withString: "")
    
        // remove empty newlines
        let newlineRegex: NSRegularExpression?
        do {
            newlineRegex = try NSRegularExpression(
                        pattern: "^\\n",
                        options: NSRegularExpressionOptions.AnchorsMatchLines)
        } catch {
            XCTAssertNil(error)
            newlineRegex = nil
        }
        str = newlineRegex!.stringByReplacingMatchesInString(str as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.length), withTemplate: "")
    
        // remove leading space at the start of lines
        let leadingSpaceRegex: NSRegularExpression?
        do {
            leadingSpaceRegex = try NSRegularExpression(
                        pattern: "^\\s+",
                        options: NSRegularExpressionOptions.AnchorsMatchLines)
        } catch {
            XCTAssertNil(error)
            leadingSpaceRegex = nil
        };
        str = leadingSpaceRegex!.stringByReplacingMatchesInString(str as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.length), withTemplate: "")
    
        // remove all newlines
        str = str.stringByReplacingOccurrencesOfString("\n", withString: "")
    
        return str as String
    }
}
