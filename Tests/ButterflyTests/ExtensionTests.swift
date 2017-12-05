//
//  ExtensionTests.swift
//  Butterfly
//
//  Created by 张奇 on 2017/12/5.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import XCTest
@testable import Butterfly

class ExtensionTests: XCTestCase {
    
    func testDigitalStringMD5() {
        //give
        let str = "12455"
        let result = "0dd4f2526c7c874d06f19523264f6552"

        //when
        let md5 = str.md5

        //then
        XCTAssertEqual(md5, result, "MD5加密方式不对")

    }
    
    func testChineseStringMD5() {
        //give
        let str = "MD5在线加密"
        let result = "2cb10c5adcd6cfd1f03e52fc3932625f"
        
        //when
        let md5 = str.md5

        //then
        XCTAssertEqual(md5, result, "MD5加密方式不对")
    }

}
