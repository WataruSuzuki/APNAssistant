//
//  ConfigProfileService.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/08/04.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ConfigProfileService: NSObject {
    let fileNameSetting = "set-to-device"
    let fileNameShare = "apn-assistant"
    
    let bridger = HttpServerBridger()
    var didEndParse:((XMLParser, ApnSummaryObject) -> Void)?
    
    var readSummaryObjFromFile: ApnSummaryObject!
    var currentParseType = ApnSummaryObject.ApnInfoColumn.max
    var currentParseTag = ApnProfileObject.KeyAPNs.max
    
    var isTagKey = false
    var isTagValue = false
    var isPayloadDisplayName = false
    
    func getProfileUrl(_ rlmObject: UtilHandleRLMObject) -> URL {
        writeMobileConfigProfile(rlmObject, fileName: fileNameShare)
        return URL(fileURLWithPath: getConfigProfileFilePath(fileNameShare))
    }
    
    func getConfigProfileFilePath(_ fileName: String) -> String {
        return getTargetFilePath(fileName, fileType: ".mobileconfig")
    }
    
    func getTargetFilePath(_ fileName: String, fileType: String) -> String {
        let filePath = UtilFileManager.getProfilesAppGroupPath() + "/" + fileName + fileType
        print(filePath)
        
        return filePath
    }
    
    func readDownloadedMobileConfigProfile(_ path: String) {
        startReadMobileCongigProfile(path)
    }
    
    func readLatestSavedMobileConfigProfile() {
        startReadMobileCongigProfile(getConfigProfileFilePath(fileNameSetting))
    }
    
    func writeMobileConfigProfile(_ rlmObject: UtilHandleRLMObject, fileName: String) {
        let payloadDescription = NSLocalizedString("payloadDescription", comment: "")
        let bundleID = Bundle.main.bundleIdentifier!
        let UUID_forIdentifier = "f9dbd18b-90ff-58c1-8605-5abae9c50691"
        let UUID_forDescription = "4be0643f-1d98-573b-97cd-ca98a65347dd"
        
        // build the Configuration Profile
        var profileXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist version=\"1.0\"><dict><key>PayloadContent</key><array><dict>"
        
        //APNs
        profileXml += "<key>APNs</key><array><dict>"
        let apnsAuthType = (rlmObject.apnProfileObj.apnsAuthenticationType.isEmpty ? "CHAP" : rlmObject.apnProfileObj.apnsAuthenticationType)
        profileXml += "<key>AuthenticationType</key><string>" + apnsAuthType + "</string>"
        profileXml += "<key>Name</key><string>" + rlmObject.apnProfileObj.apnsName + "</string>"
        if !rlmObject.apnProfileObj.apnsPassword.isEmpty {
            profileXml += "<key>Password</key><string>" + rlmObject.apnProfileObj.apnsPassword + "</string>"
        }
        
        if !rlmObject.apnProfileObj.apnsProxyServer.isEmpty
            && !rlmObject.apnProfileObj.apnsProxyServerPort.isEmpty {
            profileXml += "<key>ProxyPort</key><integer>" + rlmObject.apnProfileObj.apnsProxyServerPort + "</integer>"
            profileXml += "<key>ProxyServer</key><string>" + rlmObject.apnProfileObj.apnsProxyServer + "</string>"
        }
        if !rlmObject.apnProfileObj.apnsAllowedProtocolMask.isEmpty {
            profileXml += "<key>AllowedProtocolMask</key><integer>" + rlmObject.apnProfileObj.apnsAllowedProtocolMask + "</integer>"
        }
        if !rlmObject.apnProfileObj.apnsAllowedProtocolMaskInRoaming.isEmpty {
            profileXml += "<key>AllowedProtocolMaskInRoaming</key><integer>" + rlmObject.apnProfileObj.apnsAllowedProtocolMaskInRoaming + "</integer>"
        }
        if !rlmObject.apnProfileObj.apnsAllowedProtocolMaskInDomesticRoaming.isEmpty {
            profileXml += "<key>AllowedProtocolMaskInDomesticRoaming</key><integer>" + rlmObject.apnProfileObj.apnsAllowedProtocolMaskInDomesticRoaming + "</integer>"
        }

        if !rlmObject.apnProfileObj.apnsUserName.isEmpty {
            profileXml += "<key>Username</key><string>" + rlmObject.apnProfileObj.apnsUserName + "</string>"
        }
        profileXml += "</dict></array>"
        
        //AttachAPN
        profileXml += "<key>AttachAPN</key><dict>"
        let attachAuthType = (rlmObject.apnProfileObj.attachApnAuthenticationType.isEmpty ? "CHAP" : rlmObject.apnProfileObj.attachApnAuthenticationType)
        profileXml += "<key>AuthenticationType</key><string>" + attachAuthType + "</string>"
        profileXml += "<key>Name</key><string>" + rlmObject.apnProfileObj.attachApnName + "</string>"
        if !rlmObject.apnProfileObj.attachApnPassword.isEmpty {
            profileXml += "<key>Password</key><string>" + rlmObject.apnProfileObj.attachApnPassword + "</string>"
        }
        if !rlmObject.apnProfileObj.attachApnUserName.isEmpty {
            profileXml += "<key>Username</key><string>" + rlmObject.apnProfileObj.attachApnUserName + "</string>"
        }
        profileXml += "</dict>"
        
        //PayloadDescription
        profileXml += "<key>PayloadDescription</key><string>" + payloadDescription + "</string>"
        profileXml += "<key>PayloadDisplayName</key><string>" + rlmObject.apnSummaryObj.name + "</string>"
        profileXml += "<key>PayloadIdentifier</key><string>" + bundleID + "</string>"
        profileXml += "<key>PayloadType</key><string>com.apple.cellular</string>"
        profileXml += "<key>PayloadUUID</key><string>" + UUID_forDescription + "</string>"
        profileXml += "<key>PayloadVersion</key><real>1</real></dict></array>"
        
        //PayloadDisplayName
        profileXml += "<key>PayloadDisplayName</key><string>" + rlmObject.apnSummaryObj.name + "</string>"
        profileXml += "<key>PayloadIdentifier</key><string>" + bundleID + "</string>"
        profileXml += "<key>PayloadRemovalDisallowed</key><false/>"
        profileXml += "<key>PayloadType</key><string>Configuration</string>"
        profileXml += "<key>PayloadUUID</key><string>" + UUID_forIdentifier + "</string>"
        profileXml += "<key>PayloadVersion</key><integer>1</integer></dict></plist>"
        
        // save the String that contains the HTML to a file
        try! profileXml.write(toFile: getConfigProfileFilePath(fileName), atomically: true, encoding: String.Encoding.utf8)
        
        let fileManager = FileManager.default
        copyHtmlFilesFromResource(fileManager, fileName: "index",fileType: ".html")
        copyHtmlFilesFromResource(fileManager, fileName: "configrationProfile",fileType: ".html")
    }
    
    func copyHtmlFilesFromResource(_ fileManager: FileManager, fileName: String, fileType: String) {
        let filePath = getTargetFilePath(fileName, fileType: fileType)
        
        if fileManager.fileExists(atPath: filePath) {
            try! fileManager.removeItem(atPath: filePath)
        }
        
        if let resourcePath = Bundle.main.path(forResource: fileName, ofType: fileType) {
            try! fileManager.copyItem(atPath: resourcePath, toPath: filePath)
        }
    }
    
}
