//
//  String+Butterfly.swift
//  Butterfly
//
//  Created by 张奇 on 2017/12/5.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    var md5: String {
        if let data = self.data(using: String.Encoding.utf8) {
            let str = cString(using: .utf8)
            let strLength = CUnsignedInt(lengthOfBytes(using: .utf8))
            let digestLen = Int(CC_MD5_DIGEST_LENGTH)
            let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
            defer {
                result.deallocate(capacity: digestLen)
            }
            CC_MD5(str, strLength, result)
            var hash = ""
            for i in 0 ..< digestLen {
                hash = hash.appendingFormat("%02x", result[i])
            }
            return hash
        }
        return self
    }

}
