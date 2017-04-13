//
//  DataManager.swift
//  TwitterClient
//
//  Created by Wang, Tony on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import Foundation

struct DataManager {
    
    public static let shared = DataManager()
    
    private let dataFileName = "LocalData" // .plist
    
    fileprivate var docDirectory: String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = paths.first
        return docDir
    }
    
    private var dataFilePath: String? {
        guard let docPath = self.docDirectory else { return nil }
        return docPath.appending("/\(dataFileName).plist")
    }
    
    private var dict: NSMutableDictionary? {
        guard let filePath = self.dataFilePath else { return nil }
        return NSMutableDictionary(contentsOfFile: filePath)
    }
    
    private let fileManager = FileManager.default
    
    fileprivate init() {
        
        guard let path = dataFilePath else {
            return
        }
        
        guard fileManager.fileExists(atPath: path) else {
            
            if let bundlePath = Bundle.main.path(forResource: dataFileName, ofType: "plist") {
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                    //                    NSLog("Copied LocalData.plist to Document directory")
                } catch let error {
                    NSLog("Error in copying Data.plist: \(error)")
                }
            }
            return
        }
    }
    
    func save(_ value: Any, for key: DataKey) -> Bool {
        
        guard let dict = dict else { return false }
        
        dict.setObject(value, forKey: key.rawValue as NSCopying)
        dict.write(toFile: dataFilePath!, atomically: true)
        
        return true
    }
    
    func delete(key: DataKey) -> Bool {
        
        guard let dict = dict else { return false }
        dict.removeObject(forKey: key.rawValue)
        dict.write(toFile: dataFilePath!, atomically: true)
        return true
    }
    
    func retrieve(for key: DataKey) -> Any? {
        guard let dict = dict else { return nil }
        
        return dict.object(forKey: key.rawValue)
    }
}
