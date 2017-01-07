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
    
    static func getProfilesAppGroupPath() -> String {
        let fileManager = FileManager.default
        let targetDirectory = UtilFileManager.getAppGroupPathURL()?.appendingPathComponent("apnassistant")
        if nil == targetDirectory?.path
            || !fileManager.fileExists(atPath: targetDirectory!.path)
        {
            try! fileManager.createDirectory(at: targetDirectory!, withIntermediateDirectories: true, attributes: nil)
        }
        
        return targetDirectory!.path + "/"
    }
    
    static func getAppGroupPathURL() -> URL? {
        let path = "group.jp.co.JchanKchan.ApnAssister"
        //let path = "group." + NSBundle.mainBundle().bundleIdentifier!.stringByReplacingOccurrencesOfString(".TodayWidget", withString: "")
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: path)
    }
    
}
