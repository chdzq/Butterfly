//
//  ImageIODecoderTests.swift
//  ImageIODecoderTests
//
//  Created by iOS on 2017/11/10.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import XCTest
@testable import Butterfly

class ImageIODecoderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecodeGif() {
        
        //give
        let decoder: ImageIODecoder = ImageIODecoder()
        let data = try! Data(contentsOf: url(forResource: "niconiconi@2x", withExtension: "gif"))
        
        //when
        let source = try! decoder.decode(data: data, final: true)
        
        //Then
        XCTAssertEqual(source.frameCount, 97)

    }
    
    func testDecodePNG_APNG() {
        
        //give
        let decoder: ImageIODecoder = ImageIODecoder()
        let data = try! Data(contentsOf: url(forResource: "pia@2x", withExtension: "png"))
        
        //when
        let source = try! decoder.decode(data: data, final: true)
        
        //Then
        XCTAssertEqual(source.frameCount, 6)
        
    }
    
    func testDecodeProgerss() {
        
        //give
        let decoder: ImageIODecoder = ImageIODecoder()
        var data = try! Data(contentsOf: url(forResource: "mew_progressive", withExtension: "jpg"))
        let max = Int(Double(data.count) * 0.8)
        data = data.subdata(in: 0 ..< max)
        
        //when
        let source = try! decoder.decode(data: data, final: true)
        
        //Then
        XCTAssertNotNil(source.imageFrame(at: 0).image)

    }
    
}
