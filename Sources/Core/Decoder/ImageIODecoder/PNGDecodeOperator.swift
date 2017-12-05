//
//  PNGDecodeOperator.swift
//  Butterfly
//
//  Created by iOS on 2017/11/10.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import Foundation

struct PNGDecodeOperator: ImageIODecodeOperator {
    
    let source: CGImageSource
    let type: CFString

    func process() throws -> DecodedImageSource {
        let frameCount = CGImageSourceGetCount(source)
        var frames: [DecodedImageFrame] = []
        for i in 0 ..< frameCount {
        
            guard let cgimage = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                throw ImageIODecoder.DecodeError.unableCreateImage(at: Index(i), type: type)
            }
            
            var duration: TimeInterval = 0
            var delay: TimeInterval = 0
            var orientation: UInt32 = 0
            
            defer {
                let image = UIImage(cgImage: cgimage, scale: UIScreen.main.scale , orientation: (CGImagePropertyOrientation(rawValue: orientation) ?? .up).uiimageOrientation)
                let frame = ImageIODecoder.Frame(duration: duration, image:image)
                frames.append(frame)
            }
            
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) else {
                continue
            }
            
            guard let pngProperties: CFDictionary = properties[kCGImagePropertyPNGDictionary] else {
                continue
            }
            
            if let delayValue: CFNumber = pngProperties[kCGImagePropertyAPNGDelayTime] {
                CFNumberGetValue(delayValue, CFNumberType.doubleType, &delay)
            }
            
            if let durationValue: CFNumber = pngProperties[kCGImagePropertyAPNGUnclampedDelayTime] {
                CFNumberGetValue(durationValue, CFNumberType.doubleType, &duration)
            }
            
            if let orientationValue: CFNumber = pngProperties[kCGImagePropertyOrientation] {
                CFNumberGetValue(orientationValue, CFNumberType.intType, &orientation)
            }
        }
        
        var loopCount: UInt = 0
        
        if let properties = CGImageSourceCopyProperties(source, nil),
            let loopCountValue: CFNumber = properties[kCGImagePropertyAPNGLoopCount] {
            CFNumberGetValue(loopCountValue, CFNumberType.intType, &loopCount)
        }

        return ImageIODecoder.Source.init(frames, loopCount: loopCount)
    }
    
}
