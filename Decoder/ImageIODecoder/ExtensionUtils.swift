//
//  ExtensionUtils.swift
//  Butterfly
//
//  Created by iOS on 2017/11/10.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import CoreFoundation.CFString
import ImageIO.CGImageProperties
import UIKit.UIImage

extension CFDictionary {
    
    subscript<T>(key: CFString) -> T? {
        
        let  keyRawPointer = unsafeBitCast(key, to: UnsafeRawPointer.self)
        guard let rawPointer = CFDictionaryGetValue(self, keyRawPointer) else {
            return nil
        }
        
        return unsafeBitCast(rawPointer, to: T.self)
    }
}

extension CGImagePropertyOrientation {
    var uiimageOrientation: UIImageOrientation {
        switch self {
        case .down:
            return .down
        case .downMirrored:
            return .downMirrored
        case .up:
            return .up
        case .upMirrored:
            return .upMirrored
        case .left:
            return .left
        case .leftMirrored:
            return .leftMirrored
        case .right:
            return .right
        case .rightMirrored:
            return .rightMirrored
        }
    }
}

