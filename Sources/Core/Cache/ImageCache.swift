//
//  ImageCache.swift
//  Butterfly
//
//  Created by iOS on 2017/11/14.
//  Copyright © 2017年 chdzq.tech. All rights reserved.
//

import Foundation
import UIKit.UIImage

public class ImageCache {
    public enum CacheType {
        case none, memory, disk
        
        public var cached: Bool {
            switch self {
            case .memory, .disk: return true
            case .none: return false
            }
        }
    }
    
    
    private let memoryCache = NSCache<NSString, UIImage>()
    
    var maxMemoryCost: UInt = 0 {
        didSet {
            self.memoryCache.totalCostLimit = Int(maxMemoryCost)
        }
    }
    
    //Disk
    private let ioQueue: DispatchQueue
    private let processQueue: DispatchQueue

    private lazy var fileManager: FileManager = FileManager()
    
    open let diskCachePath: String

    public init(name: String = "Butterfly",
                path: String? = nil) {
        if name.isEmpty {
            fatalError("[Butterfly] You should specify a name for the cache. A cache with empty name is not permitted.")
        }
        
        let cacheName = "tech.chdzq.Butterfly.ImageCache.\(name)"
        memoryCache.name = cacheName
        let dstPath = path ?? NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!

        diskCachePath = (dstPath as NSString).appendingPathComponent(cacheName)
        
        let ioQueueName = "tech.chdzq.Butterfly.ImageCache.ioQueue.\(name)"
        ioQueue = DispatchQueue(label: ioQueueName)
        
        let processQueueName = "tech.chdzq.Butterfly.ImageCache.\(name)"
        processQueue = DispatchQueue(label: processQueueName, attributes: .concurrent)
    }
    
    
    open func cachePath(forKey key: String) -> String {
        let fileName = key.md5
        return (diskCachePath as NSString).appendingPathComponent(fileName)
    }
}

extension ImageCache {

    func storeInMemory(_ image: UIImage,
                       forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString, cost: image.imageCost)
    }
    
    open func store(_ image: UIImage,
                    data: Data,
                    forKey key: String,
                    toDisk: Bool = true,
                    completionHandler: (() -> Void)? = nil) {
        
        storeInMemory(image, forKey: key)
        func callHandlerInMainQueue() {
            if let handler = completionHandler {
                if Thread.isMainThread {
                    handler()
                } else {
                    DispatchQueue.main.async {
                        handler()
                    }
                }
            }
        }
        
        if toDisk {
            ioQueue.async {
                
                if !self.fileManager.fileExists(atPath: self.diskCachePath) {
                    do {
                        try self.fileManager.createDirectory(atPath: self.diskCachePath, withIntermediateDirectories: true, attributes: nil)
                    } catch _ {}
                }
                
                self.fileManager.createFile(atPath: self.cachePath(forKey: key), contents: data, attributes: nil)
                callHandlerInMainQueue()
            }
        } else {
            callHandlerInMainQueue()
        }
    }
}

extension ImageCache {
    
    open func queryImage(forKey key: String,
                         completionHandler: @escaping (UIImage?) -> Void)
    {
        
        func excuteHandleInMianThread(image: UIImage?) {
            if Thread.current.isMainThread {
                completionHandler(image)
            } else {
                DispatchQueue.main.async {
                    completionHandler(image)
                }
            }
        }
        if let image = self.queryImageInMemoryCache(forKey: key) {
            excuteHandleInMianThread(image: image)
        } else {
            self.ioQueue.async {
                if let data = self.diskImageData(forKey: key) {
                    self.processQueue.async {
                        if let image = Butterfly.shared.decodeImage(data: data) {
                            self.storeInMemory(image, forKey: key)
                            excuteHandleInMianThread(image: image)
                            
                        } else if let image = UIImage(data: data) {
                            self.storeInMemory(image, forKey: key)
                            excuteHandleInMianThread(image: image)
                        } else {
                            excuteHandleInMianThread(image: nil)
                        }
                    }
                } else {
                    excuteHandleInMianThread(image: nil)
                }
            }
        }
    }
    
    open func queryImageInMemoryCache(forKey key: String) -> UIImage? {
        return memoryCache.object(forKey: key as NSString)
    }
    
    open func queryImageInDiskCache(forKey key: String) -> UIImage? {
        return diskImage(forKey: key)
    }

}

extension ImageCache {
    
    open func removeImage(forKey key: String,
                          fromDisk: Bool = true,
                          completionHandler: (() -> Void)? = nil) {
        
        memoryCache.removeObject(forKey: key as NSString)
        
        func callHandlerInMainQueue() {
            if let handler = completionHandler {
                if Thread.current.isMainThread {
                    handler()
                } else {
                    DispatchQueue.main.async {
                        handler()
                    }
                }
            }
        }
        
        if fromDisk {
            ioQueue.async{
                do {
                    try self.fileManager.removeItem(atPath: self.cachePath(forKey: key))
                } catch _ {}
                callHandlerInMainQueue()
            }
        } else {
            callHandlerInMainQueue()
        }
    }
}

extension ImageCache {
    
    func diskImage(forKey key: String) -> UIImage? {
        if let data = diskImageData(forKey: key) {
            return Butterfly.shared.decodeImage(data: data)
        } else {
            return nil
        }
    }
    
    func diskImageData(forKey key: String) -> Data? {
        let filePath = cachePath(forKey: key)
        return (try? Data(contentsOf: URL(fileURLWithPath: filePath)))
    }
    
}

extension ImageCache {
    
    // MARK: - Clear & Clean
    public func clear() {
        clearMemoryCache()
        clearDiskCache()
    }
    
    public func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }
    
    public func clearDiskCache(completion handler: (()->Void)? = nil) {
        ioQueue.async {
            do {
                try self.fileManager.removeItem(atPath: self.diskCachePath)
                try self.fileManager.createDirectory(atPath: self.diskCachePath, withIntermediateDirectories: true, attributes: nil)
            } catch _ { }
            
            if let handler = handler {
                if Thread.current.isMainThread {
                    handler()
                } else {
                    DispatchQueue.main.async {
                        handler()
                    }
                }
            }
        }
    }

}
