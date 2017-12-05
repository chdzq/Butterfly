//
//  UIImage+Butterfly.swift
//  Butterfly
//
//  Created by 张奇 on 2017/12/5.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import UIKit

extension UIImage {
    var imageCost: Int {
       return (images?.isEmpty ?? true) ?
        Int(size.height * size.width * scale * scale) :
        Int(size.height * size.width * scale * scale) * images!.count

    }
}
