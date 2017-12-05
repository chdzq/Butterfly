//
//  Butterfly.swift
//  Butterfly
//
//  Created by iOS on 2017/11/8.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import Foundation

final public class Butterfly {
    public let downloader: Downloader
    public let imageDecoders: [ImageDecoder]
    private static var butterfly: Butterfly!
    
    static var shared: Butterfly {
        if butterfly == nil {
            fatalError("[Butterfly] need build with Builder.")
        }
        
        return butterfly
    }
    
    private init(_ builder: Builder) {
        downloader = builder.downloader
        imageDecoders = builder.imageDecoders
    }
    
    func decodeImage(data: Data) -> UIImage? {
        for decoder in imageDecoders {
            if decoder.canDecode(data: data),
                let imageSource = try? decoder.decode(data: data, final: true),
                let image = imageSource.image {
                return image
            }
        }
        return nil
    }
}

extension Butterfly {
    
    public class Builder {
        
        let downloader: Downloader
        var imageDecoders: [ImageDecoder] = [ImageIODecoder()]
        
        public init(downloader: Downloader) {
            self.downloader = downloader
        }
        
        public func addImageDecoder(_ decoder: ImageDecoder) -> Self {
            imageDecoders.append(decoder)
            return self
        }
        
        public func build() {
            Butterfly.butterfly = Butterfly(self)
        }
    }
    
}


public struct ButterflySupport<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ButterflyCompatible {
    associatedtype CompatibleType
    var fly: CompatibleType { get }
}

public extension ButterflyCompatible {
    public var fly: ButterflySupport<Self> {
        get { return ButterflySupport(self) }
    }
}

extension UIImage: ButterflyCompatible { }
extension UIImageView: ButterflyCompatible { }
extension UIButton: ButterflyCompatible { }

