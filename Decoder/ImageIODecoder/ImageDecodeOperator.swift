//
//  ImageDecodeOperator.swift
//  Butterfly
//
//  Created by iOS on 2017/11/10.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import UIKit

struct ImageDecodeOperator: ImageIODecodeOperator {
    
    let source: CGImageSource
    let type: CFString

    func process() throws -> DecodedImageSource {

        guard let cgimage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            throw ImageIODecoder.DecodeError.unableCreateImage(at: 0, type: type)
        }

        var orientation: UInt32 = 0
        if let properties = CGImageSourceCopyProperties(source, nil), let orientationValue: CFNumber = properties[kCGImagePropertyOrientation] {
            CFNumberGetValue(orientationValue, CFNumberType.intType, &orientation)
        }
        
        let image = UIImage(cgImage: cgimage, scale: UIScreen.main.scale , orientation: (CGImagePropertyOrientation(rawValue: orientation) ?? .up).uiimageOrientation)
        let frame = ImageIODecoder.Frame(duration: 0, image:image)

        return ImageIODecoder.Source([frame], loopCount: 0)

    }

}
