//
//  SplitterTests.swift
//  TweeterTests
//
//  Created by Ngo Thang Loi on 10/19/18.
//  Copyright © 2018 kthangtd. All rights reserved.
//

import XCTest
@testable import Tweeter

class SplitterTests: XCTestCase {

    var mBundle: Bundle!
    var mSplitter: Splitter!
    
    override func setUp() {
        super.setUp()
        mBundle = Bundle.init(for: SplitterTests.self)
        mSplitter = Splitter() 
    }

    override func tearDown() {
        mSplitter = nil
        mBundle = nil
        super.tearDown()
    }
    
    func loadResource(_ inCase: String) -> (String, [String])? {
        guard let pathInput = mBundle.path(forResource: "Input\(inCase)", ofType: "txt"),
            let input = try? String(contentsOfFile: pathInput) else {
                XCTAssertFalse(true, "Input file at case \(inCase) not found!")
                return nil
        }
        guard let pathOutput = mBundle.path(forResource: "Output\(inCase)", ofType: "txt"),
            let output = try? String(contentsOfFile: pathOutput) else {
                XCTAssertFalse(true, "Output file at case \(inCase) not found!")
                return nil
        }
        return (String(input.dropLast()), output.dropLast().components(separatedBy: .newlines))
    }
    
    func compareResult(_ result: [String]?, _ output: [String], _ msg: String) {
        if result == nil {
            XCTAssert(output.count == 1, msg)
        } else {
            XCTAssertEqual(result, output, msg)
        }
    }
    
    func processTest(inCase: String, msg: String) {
        if let (input, output) = loadResource(inCase) {
            let result = mSplitter.splitMessage(msg: input)
            compareResult(result, output, msg)
        }
    }

    func test01() {
        processTest(inCase: "01", msg: "case word less than 50 chars")
    }
    
    func test02() {
        processTest(inCase: "02", msg: "case paragraph more than 50 chars and less than 100 chars")
    }
    
    func test03() {
        processTest(inCase: "03", msg: "case contains a word more than 50 chars")
    }
    
    func test04() {
        processTest(inCase: "04", msg: "case paragraph")
    }

}
