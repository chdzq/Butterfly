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

public enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

public protocol Downloader {
    
    typealias ProgressHandler = (_ receiveData: Data, _ totalUnitCount: Int64, _ completedUnitCount: Int64) -> Void
    
    typealias CompletionHandler = (_ result: Result<Data>) -> Void

    func download(_ url: URL, progress: ProgressHandler, completion: CompletionHandler) -> Cancelable
}
