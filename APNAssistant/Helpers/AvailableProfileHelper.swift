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
    private var cacheCounter = 0

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
        //cacheCounter = targetProfileList.count
        for countries in targetProfileList {
            for country in countries {
                DispatchQueue.global(qos: .default).async(execute: {
                    let reqUrl = self.getUrlFromItem(item: country as! NSDictionary)
                    self.executeDownloadProfile(reqUrl: reqUrl, success: nil, fail: nil)
                })
            }
        }
    }
    
    func executeDownloadProfile(indexPath: IndexPath, success:((String) -> Void)?, fail:((Error?) -> Void)?) {
        let reqUrl = getTargetUrl(indexPath)
        executeDownloadProfile(reqUrl: reqUrl, success: success, fail: fail)
    }
    
    func executeDownloadProfile(reqUrl: URL, success:((String) -> Void)?, fail:((Error?) -> Void)?) {
        let config = URLSessionConfiguration.default
        let session = Foundation.URLSession(configuration: config)
        self.cacheCounter += 1
        let task = session.downloadTask(with: reqUrl, completionHandler: { (location, response, error) in
            self.cacheCounter -= 1
            if let thisResponse = response, let thisLocation = location {
                if let lastPathComponent = thisResponse.url?.lastPathComponent {
                    if lastPathComponent.contains(".mobileconfig") {
                        let filePath = self.generateProfilePath(lastPathComponent: lastPathComponent)
                        UtilFileManager.moveDownloadItemAtURL(filePath, location: thisLocation)
                        
                        if let success = success {
                            success(filePath)
                        } else {
                            if self.cacheCounter <= 0 {
                                self.showCompAlert()
                            }
                        }
                        return
                    }
                }
            }
            print(error as Any)
            DispatchQueue.main.async(execute: {
                fail?(error)
            })
        })
        
        task.resume()
    }
    
    func generateProfilePath(lastPathComponent: String) -> String {
        let utilHttpServer = UtilCocoaHTTPServer()
        let fileName = lastPathComponent.replacingOccurrences(of: ".mobileconfig", with: "")
        let filePath = utilHttpServer.getTargetFilePath(fileName, fileType: ".mobileconfig")
        
        return filePath
    }
    
    private func showCompAlert() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            if let controller = delegate.window?.rootViewController {
                UtilAlertSheet.showAlertController("OK", messagekey: "msg_complete", url: nil, vc: controller)
            }
        }
    }
}
