//
//  Butterfly.swift
//  Butterfly
//
//  Created by iOS on 2017/11/8.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import Foundation

final public class Butterfly {
    let downloader: Downloader
    
    init(_ builder: Builder) {
        downloader = builder.downloader
    }

}

extension Butterfly {
    open class Builder {
        let downloader: Downloader
        
        public
        init(downloader: Downloader) {
            self.downloader = downloader
        }
        
        open
        func build() -> Butterfly {
            return Butterfly(self)
        }
    }
}
