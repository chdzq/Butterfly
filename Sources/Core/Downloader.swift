//
//  Downloader.swift
//  Butterfly
//
//  Created by iOS on 2017/11/8.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import Foundation

public protocol Cancelable {
    func cancel()
}

public protocol Request {
    typealias ProgressHandler = (_ receiveData: Data, _ totalUnitCount: Int64, _ completedUnitCount: Int64) -> Void
    
    typealias CompletionHandler = (_ totalData: Data?, _ error: Error?) -> Void
    
    func downloadProgress(_ closure: ProgressHandler) -> Self
    
    func completionHandler(_ closer: CompletionHandler) -> Self
    
}

public protocol Downloader {
    
    func download(_ url: URL) -> Cancelable & Request
}
