//
//  ImageCacheTests.swift
//  ButterflyTests
//
//  Created by 张奇 on 2017/12/5.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import XCTest
@testable import Butterfly

class ImageCacheTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testCustomCachePath() {
        // give
        let customPath = "/path/to/image/cache"
        
        // when
        let cache = ImageCache(name: "test", path: customPath)
        
        // then
        XCTAssertEqual(cache.diskCachePath, customPath + "/tech.chdzq.Butterfly.ImageCache.test", "Custom disk cache path set correctly")
    }
    
    func testMemoryImageCache() {
        // give
        let key = "niconiconi@2x"
        let data = try! Data(contentsOf: url(forResource: key, withExtension: "gif"))
        let image = UIImage.init(data: data)
        let cache = ImageCache(name: "test")

        // when
        cache.storeInMemory(image!, forKey: key)
        
        // then
        let a = cache.queryImageInMemoryCache(forKey: key)
        
        XCTAssertEqual(image, a, "cache image in memory is correctly")
    }
    
    func testDiskImageCache() {
        // give
        let key = "niconiconi@2x"
        let data = try! Data(contentsOf: url(forResource: key, withExtension: "gif"))
        let image = UIImage.init(data: data)!
        let cache = ImageCache(name: "test")

        let expectation = self.expectation(description: "cache image in disk should query success")
        
        // when
        cache.store(image, data: data, forKey: key) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
        
        // then
        let imageData = cache.diskImageData(forKey: key)
        XCTAssertNotNil(imageData, "cache image in disk query success")

    }
    
    func testRemoveImage() {
        // give
        let key = "niconiconi@2x"
        let data = try! Data(contentsOf: url(forResource: key, withExtension: "gif"))
        let image = UIImage.init(data: data)!
        let cache = ImageCache(name: "test")
        cache.store(image, data: data, forKey: key)
        let expectation = self.expectation(description: "remove a image for key should success")

        // when
        cache.removeImage(forKey: key) {
            expectation.fulfill()
        }
        // then
        waitForExpectations(timeout: 60, handler: nil)
        let memoryImage = cache.queryImageInMemoryCache(forKey: key)
        let diskImageData = cache.diskImageData(forKey: key)
        XCTAssertNil(memoryImage, "remove a image for key success")
        XCTAssertNil(diskImageData, "remove a image for key success")
    }

}
