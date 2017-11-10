//
//  ImageDecoder.swift
//  Butterfly
//
//  Created by iOS on 2017/11/9.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import UIKit.UIImage
import Foundation

public protocol DecodedImageFrame {
    
    ///  the frame's duration
    var duration: TimeInterval { get }
    
    var image: UIImage { get }
}

public typealias Index = Int

public protocol DecodedImageSource {
    
    /// Total animated frame count.
    /// if less than 1, the below methods will be ignored.
    var frameCount: UInt { get }
    
    /// Animation loop count, 0 means infinite looping.
    var loopCount: UInt { get }
    
    func imageFrame(at index: Index) -> DecodedImageFrame
}

public protocol ImageDecoder {
    
    func canDecode(data: Data) -> Bool
    
    func decode(data: Data, final: Bool) throws -> DecodedImageSource
    
}
