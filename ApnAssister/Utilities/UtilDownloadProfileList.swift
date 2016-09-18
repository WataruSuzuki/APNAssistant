//
//  UtilDownloadProfileList.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/09/12.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

struct DownloadProfiles {
    static let serverUrl = "https://watarusuzuki.github.io/"
    
    static let publicProfilesDir = "public-profiles/"
    static let customProfilesDir = "custom-profiles/"
    
    static let profileItems = "items"
    static let profileName = "name"
    static let profileUrl = "profile_url"
    static let ERROR_INDEX = (-1)
    
    enum json: Int {
        case japan = 0,
        usa,
        global,
        MAX
        
        init(fileName: String) {
            switch fileName {
            case json.japan.getFileName():  self = json.japan
            case json.usa.getFileName():    self = json.usa
            case json.global.getFileName(): self = json.global
            default:
                self = json.MAX
            }
        }
        
        func getFileName() -> String {
            return String(self) + ".json"
        }
        
        func toString() -> String {
            return String(self)
        }
    }
}

class UtilDownloadProfileList: NSObject {
    
    var publicProfileList = [NSArray](count: DownloadProfiles.json.MAX.rawValue, repeatedValue: [])
    var customProfileList = [NSArray](count: DownloadProfiles.json.MAX.rawValue, repeatedValue: [])
    
    func getOffsetSection(currentSection: Int) -> (Bool, Int) {
        if currentSection > (DownloadProfiles.json.MAX.rawValue - 1) {
            return (true, currentSection - DownloadProfiles.json.MAX.rawValue)
        } else {
            return (false, currentSection)
        }
    }
    
    func getUpdateIndexSection(downloadTask: NSURLSessionDownloadTask) -> Int {
        if let response = downloadTask.response {
            if let url = response.URL {
                if let fileName = url.lastPathComponent {
                    let country = DownloadProfiles.json.init(fileName: fileName)
                    if url.absoluteString.containsString(DownloadProfiles.publicProfilesDir) {
                        return country.rawValue
                    } else {
                        return country.rawValue + DownloadProfiles.json.MAX.rawValue
                    }
                }
            }
        }
        return DownloadProfiles.ERROR_INDEX
    }
    
    func moveJSONFilesFromURLSession(downloadTask: NSURLSessionDownloadTask, location: NSURL) {
        guard let response = downloadTask.response else { return }
        guard let responseUrl = response.URL else { return }
        guard let lastPathComponent = responseUrl.lastPathComponent else { return }
        
        let fileManager = NSFileManager.defaultManager()
        let fileName = (responseUrl.absoluteString.containsString(DownloadProfiles.publicProfilesDir)
            ? lastPathComponent.stringByReplacingOccurrencesOfString(".json", withString: "-" + DownloadProfiles.publicProfilesDir).stringByReplacingOccurrencesOfString("/", withString: "")
            : lastPathComponent.stringByReplacingOccurrencesOfString(".json", withString: "-" + DownloadProfiles.customProfilesDir).stringByReplacingOccurrencesOfString("/", withString: "")
        )
        let filePath = UtilCocoaHTTPServer().getTargetFilePath(fileName, fileType: ".json")
        if fileManager.fileExistsAtPath(filePath) {
            try! fileManager.removeItemAtPath(filePath)
        }
        
        let localUrl = NSURL.fileURLWithPath(filePath)
        do{
            try fileManager.moveItemAtURL(location, toURL: localUrl)
            let jsonData = NSData(contentsOfURL: localUrl)
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers) as! NSDictionary
            
            let items = json.objectForKey(DownloadProfiles.profileItems) as! NSArray
            for i in 0  ..< items.count  {
                print(items[i].objectForKey(DownloadProfiles.profileName) as! NSString)
            }
            let section = getUpdateIndexSection(downloadTask)
            if section != DownloadProfiles.ERROR_INDEX {
                let offset = getOffsetSection(section)
                if offset.0 {
                    customProfileList[offset.1] = items
                } else {
                    publicProfileList[offset.1] = items
                }
            }
            
        } catch {
            let nsError = error as NSError
            print(nsError.description)
        }
    }
    
    func startJsonFileDownload(delegate: NSURLSessionDownloadDelegate) {
        for index in 0..<(DownloadProfiles.json.MAX.rawValue * 2) {
            let url: NSURL!
            if 0 >= DownloadProfiles.json.MAX.rawValue - index {
                url = NSURL(string: DownloadProfiles.serverUrl + DownloadProfiles.customProfilesDir + DownloadProfiles.json(rawValue: index - DownloadProfiles.json.MAX.rawValue)!.getFileName())
            } else {
                url = NSURL(string: DownloadProfiles.serverUrl + DownloadProfiles.publicProfilesDir + DownloadProfiles.json(rawValue: index)!.getFileName())
            }
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config, delegate: delegate, delegateQueue: NSOperationQueue.mainQueue())
            
            session.downloadTaskWithURL(url!).resume()
        }
    }
}
