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
    
    init(_ builder: Builder) {
        downloader = builder.downloader
        imageDecoders = builder.imageDecoders
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
        
        public func build() -> Butterfly {
            return Butterfly(self)
        }
    }
    
}
