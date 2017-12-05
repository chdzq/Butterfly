//
//  ExtensionUtils.swift
//  ImageIODecoderTests
//
//  Created by iOS on 2017/11/10.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func url(forResource fileName: String, withExtension ext: String) -> URL {
        let bundle = Bundle(for: type(of: self))
        return bundle.url(forResource: fileName, withExtension: ext)!
    }
    
}

