//
//  UtilCocoaHTTPServer.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/08/04.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilCocoaHTTPServer: NSObject {

    let cocoaHTTPServer = HTTPServer()
    
    func startCocoaHTTPServer() {
        cocoaHTTPServer.setType("_http._tcp.")
        cocoaHTTPServer.setPort(8080)
        
        cocoaHTTPServer.setDocumentRoot(getProfilesAppGroupPath())
        do {
            try cocoaHTTPServer.start()
        } catch  _ as NSError{
            //(・A・)!!
        }
    }
    
    func getProfileUrl(rlmObject: UtilHandleRLMObject) -> NSURL {
        writeMobileConfigProfile(rlmObject)
        return NSURL(fileURLWithPath: getConfigProfileFilePath())
    }
    
    func getConfigProfileFilePath() -> String {
        return getTargetFilePath("profile", fileType: ".mobileconfig")
    }
    
    func getTargetFilePath(fileName: String, fileType: String) -> String {
        let filePath = getProfilesAppGroupPath() + fileName + fileType
        print(filePath)
        
        return filePath
    }
    
    func getProfilesAppGroupPath() -> String {
        let fileManager = NSFileManager.defaultManager()
        let targetDirectory = UtilHandleRLMObject.getAppGroupPathURL()?.URLByAppendingPathComponent("apnassistant")
        if nil == targetDirectory?.path
            || !fileManager.fileExistsAtPath(targetDirectory!.path!)
        {
            try! fileManager.createDirectoryAtURL(targetDirectory!, withIntermediateDirectories: true, attributes: nil)
        }
        
        return targetDirectory!.path! + "/"
    }
    
    func writeMobileConfigProfile(rlmObject: UtilHandleRLMObject) {
        let payloadDisplayName = NSLocalizedString("payloadDisplayName", comment: "")
        let bundleID = NSBundle.mainBundle().bundleIdentifier!
        let UUID_forIdentifier = "f9dbd18b-90ff-58c1-8605-5abae9c50691"
        let UUID_forDescription = "4be0643f-1d98-573b-97cd-ca98a65347dd"
        
        // build the Configuration Profile
        var profileXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist version=\"1.0\"><dict><key>PayloadContent</key><array><dict>"
        
        //APNs
        profileXml += "<key>APNs</key><array><dict><key>AuthenticationType</key><string>CHAP</string>"
        profileXml += "<key>Name</key><string>" + rlmObject.apnProfileObj.apnsName + "</string>"
        if !rlmObject.apnProfileObj.apnsPassword.isEmpty {
            profileXml += "<key>Password</key><string>" + rlmObject.apnProfileObj.apnsPassword + "</string>"
        }
        
        if !rlmObject.apnProfileObj.apnsProxyServer.isEmpty
            && !rlmObject.apnProfileObj.apnsProxyServerPort.isEmpty {
            profileXml += "<key>ProxyPort</key><integer>" + rlmObject.apnProfileObj.apnsProxyServerPort + "</integer>"
            profileXml += "<key>ProxyServer</key><string>" + rlmObject.apnProfileObj.apnsProxyServer + "</string>"
        }
        if !rlmObject.apnProfileObj.apnsUserName.isEmpty {
            profileXml += "<key>Username</key><string>" + rlmObject.apnProfileObj.apnsUserName + "</string>"
        }
        profileXml += "</dict></array>"
        
        //AttachAPN
        profileXml += "<key>AttachAPN</key><dict><key>AuthenticationType</key><string>CHAP</string>"
        profileXml += "<key>Name</key><string>" + rlmObject.apnProfileObj.attachApnName + "</string>"
        if !rlmObject.apnProfileObj.attachApnPassword.isEmpty {
            profileXml += "<key>Password</key><string>" + rlmObject.apnProfileObj.attachApnPassword + "</string>"
        }
        if !rlmObject.apnProfileObj.attachApnUserName.isEmpty {
            profileXml += "<key>Username</key><string>" + rlmObject.apnProfileObj.attachApnUserName + "</string>"
        }
        profileXml += "</dict>"
        
        //PayloadDescription
        profileXml += "<key>PayloadDescription</key><string>" + String(NSDate.init(timeIntervalSinceReferenceDate: rlmObject.apnSummaryObj.createdDate)) + "</string>"
        profileXml += "<key>PayloadDisplayName</key><string>" + rlmObject.apnSummaryObj.name + "</string>"
        profileXml += "<key>PayloadIdentifier</key><string>" + bundleID + "</string>"
        profileXml += "<key>PayloadType</key><string>com.apple.cellular</string>"
        profileXml += "<key>PayloadUUID</key><string>" + UUID_forDescription + "</string>"
        profileXml += "<key>PayloadVersion</key><real>1</real></dict></array>"
        
        //PayloadDisplayName
        profileXml += "<key>PayloadDisplayName</key><string>" + payloadDisplayName + "</string>"
        profileXml += "<key>PayloadIdentifier</key><string>" + bundleID + "</string>"
        profileXml += "<key>PayloadRemovalDisallowed</key><false/>"
        profileXml += "<key>PayloadType</key><string>Configuration</string>"
        profileXml += "<key>PayloadUUID</key><string>" + UUID_forIdentifier + "</string>"
        profileXml += "<key>PayloadVersion</key><integer>1</integer></dict></plist>"
        
        // save the String that contains the HTML to a file
        //try! profileXml.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        try! profileXml.writeToFile(getConfigProfileFilePath(), atomically: true, encoding: NSUTF8StringEncoding)
        
        let fileManager = NSFileManager.defaultManager()
        copyHtmlFilesFromResource(fileManager, fileName: "index",fileType: ".html")
        copyHtmlFilesFromResource(fileManager, fileName: "configrationProfile",fileType: ".html")
    }
    
    func openSettingAppToSetProfile(rlmObject: UtilHandleRLMObject) {
        writeMobileConfigProfile(rlmObject)
        startCocoaHTTPServer()
        
        if #available(iOS 9.0, *) {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://localhost:8080")!)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://localhost:8080" + "/profile.mobileconfig")!)
        }
    }
    
    func copyHtmlFilesFromResource(fileManager: NSFileManager, fileName: String, fileType: String) {
        let filePath = getTargetFilePath(fileName, fileType: fileType)
        
        if fileManager.fileExistsAtPath(filePath) {
            try! fileManager.removeItemAtPath(filePath)
        }
        
        let resourcePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
        try! fileManager.copyItemAtPath(resourcePath!, toPath: filePath)
    }
}
