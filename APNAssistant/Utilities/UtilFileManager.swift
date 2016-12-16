//
//  UtilFileManager.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/12/16.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilFileManager: FileManager {

    static func moveDownloadItemAtURL(_ filePath: String, location: URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            try! fileManager.removeItem(atPath: filePath)
        }
        
        let localUrl = URL(fileURLWithPath: filePath)
        do {
            try fileManager.moveItem(at: location, to: localUrl)
        } catch {
            let nsError = error as NSError
            print(nsError.description)
        }
    }
    
}
