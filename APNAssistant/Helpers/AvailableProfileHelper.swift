//
//  AvailableProfileHelper.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/12/16.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class AvailableProfileHelper: NSObject {
    
    private var targetProfileList: [NSArray]!

    required init(list: [NSArray]) {
        targetProfileList = list
    }
    
    func getTargetUrl(_ selectedIndexPath: IndexPath) -> URL {
        let profileData = targetProfileList[selectedIndexPath.section]
        let item = profileData[selectedIndexPath.row] as! NSDictionary
        return getUrlFromItem(item: item)
    }
    
    func getUrlFromItem(item: NSDictionary) -> URL {
        let urlPath = item.object(forKey: DownloadProfiles.profileUrl) as! String
        return URL(string: urlPath)!
    }
    
    func startDownloadAvailableProfiles() {
        
    }
    
    func executeDownloadProfile(indexPath: IndexPath, success:@escaping ((String) -> Void), fail:@escaping ((NSError) -> Void)) {
        let reqUrl = getTargetUrl(indexPath)
        let config = URLSessionConfiguration.default
        let session = Foundation.URLSession(configuration: config)
        let task = session.downloadTask(with: reqUrl, completionHandler: { (location, response, error) in
            if let thisResponse = response, let thisLocation = location {
                if let lastPathComponent = thisResponse.url?.lastPathComponent {
                    if lastPathComponent.contains(".mobileconfig") {
                        let utilHttpServer = UtilCocoaHTTPServer()
                        let fileName = lastPathComponent.replacingOccurrences(of: ".mobileconfig", with: "")
                        let filePath = utilHttpServer.getTargetFilePath(fileName, fileType: ".mobileconfig")
                        UtilFileManager.moveDownloadItemAtURL(filePath, location: thisLocation)
                        
                        success(filePath)
                        return
                    }
                }
            }
            print(error as Any)
            DispatchQueue.main.async(execute: {
                if let nsError = error as? NSError {
                    fail(nsError)
                }
            })
            
        })
        
        task.resume()
    }
}
