//
//  ImageIODecoder.swift
//  Butterfly
//
//  Created by iOS on 2017/11/9.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

/**
 ImageIO解码步骤：
     1. 创建 CGImageSource
         CGImageSourceCreateWithData 和 CGImageSourceCreateIncremental(渐进式的)
     2. 读取图像格式数据
         CGImageSourceCopyPropertiesAtIndex
     3. 解码图像
         CGImageSourceCreateImageAtIndex
     4. 生成UIImage
 
     5. 遍历所有图片，重复 2， 3， 4
*/

import MobileCoreServices
import ImageIO

protocol ImageIODecodeOperator {
    var source: CGImageSource { get }
    func process() throws -> DecodedImageSource
}

public class ImageIODecoder {

    private let lock = NSLock()
    private var source: CGImageSource!
    
    private func processDecode(data: Data, final: Bool) throws -> DecodedImageSource {
        lock.lock()
        if (nil == source) {
            source = final ? CGImageSourceCreateWithData(data as CFData, nil) : CGImageSourceCreateIncremental(nil)
        }
        
        if !final {
            CGImageSourceUpdateData(source, data as CFData, false)
        }
        
        guard let source = self.source else {
            lock.unlock()
            throw DecodeError.imageSourceNil
        }
        lock.unlock()

        guard let type = CGImageSourceGetType(source) else {
            throw DecodeError.unableDecodeTheType
        }
        
        let decodeOperator: ImageIODecodeOperator
        if final {
            switch type {
            case kUTTypeGIF:
                decodeOperator = GIFDecodeOperator(source: source, type: type)
            case kUTTypePNG:
                decodeOperator = PNGDecodeOperator(source: source, type: type)
            default:
                decodeOperator = ImageDecodeOperator(source: source, type: type)
            }
        } else {
            decodeOperator = ImageDecodeOperator(source: source, type: type)
        }
        
        return try decodeOperator.process()
        
    }

}

extension ImageIODecoder {
    
    enum DecodeError: Error {
        case imageSourceNil
        case unableCreateImage(at: Index, type: CFString?)
        case unableDecodeTheType
    }

    struct Frame: DecodedImageFrame {
        let duration: TimeInterval
        let image: UIImage
    }
    
    struct Source: DecodedImageSource {
        let frames: [DecodedImageFrame]
        let loopCount: UInt
        let frameCount: Int
        
        init(_ frames: [DecodedImageFrame], loopCount: UInt) {
            self.frames = frames
            self.loopCount = loopCount
            self.frameCount = frames.count
        }
        
        func imageFrame(at index: Index) -> DecodedImageFrame {
            return frames[index]
        }
    }
}

extension ImageIODecoder: ImageDecoder {
    
    public func decode(data: Data, final: Bool) throws -> DecodedImageSource {
        let source =  try processDecode(data: data, final: final)
        return source
    }
    
    public func canDecode(data: Data) -> Bool {
        return CGImageSourceCreateWithData(data as CFData, nil).flatMap({CGImageSourceGetType($0) != nil}) ?? false
    }
        
}
