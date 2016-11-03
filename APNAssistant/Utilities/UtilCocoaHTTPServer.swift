//
//  UtilCocoaHTTPServer.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/08/04.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilCocoaHTTPServer: NSObject,
    XMLParserDelegate
{
    let cocoaHTTPServer = HTTPServer()
    let fileNameSetting = "set-to-device"
    let fileNameShare = "apn-assistant"
    
    var didEndParse:((XMLParser, ApnSummaryObject) -> Void)?
    
    var readSummaryObjFromFile: ApnSummaryObject!
    var currentParseType = ApnSummaryObject.ApnInfoColumn.max
    var currentParseTag = ApnProfileObject.KeyAPNs.max
    
    var isTagKey = false
    var isTagValue = false
    var isPayloadDisplayName = false
    
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
    
    func getProfileUrl(_ rlmObject: UtilHandleRLMObject) -> URL {
        writeMobileConfigProfile(rlmObject, fileName: fileNameShare)
        return URL(fileURLWithPath: getConfigProfileFilePath(fileNameShare))
    }
    
    func getConfigProfileFilePath(_ fileName: String) -> String {
        return getTargetFilePath(fileName, fileType: ".mobileconfig")
    }
    
    func getTargetFilePath(_ fileName: String, fileType: String) -> String {
        let filePath = getProfilesAppGroupPath() + fileName + fileType
        print(filePath)
        
        return filePath
    }
    
    func getProfilesAppGroupPath() -> String {
        let fileManager = FileManager.default
        let targetDirectory = UtilHandleRLMObject.getAppGroupPathURL()?.appendingPathComponent("apnassistant")
        if nil == targetDirectory?.path
            || !fileManager.fileExists(atPath: targetDirectory!.path)
        {
            try! fileManager.createDirectory(at: targetDirectory!, withIntermediateDirectories: true, attributes: nil)
        }
        
        return targetDirectory!.path + "/"
    }
    
    func readDownloadedMobileConfigProfile(_ path: String) {
        startReadMobileCongigProfile(path)
    }
    
    func readLatestSavedMobileConfigProfile() {
        startReadMobileCongigProfile(getConfigProfileFilePath(fileNameSetting))
    }
    
    func startReadMobileCongigProfile(_ path: String) {
        readSummaryObjFromFile = ApnSummaryObject()
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            if let parser = XMLParser(contentsOf: URL(fileURLWithPath: path)) {
                parser.delegate = self
                readSummaryObjFromFile.apnProfile = ApnProfileObject()
                parser.parse()
                return
            }
        }
        readSummaryObjFromFile.name = NSLocalizedString("unknown", comment: "")
        self.didEndParse?(XMLParser(), readSummaryObjFromFile)
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
    
    func prepareOpenSettingAppToSetProfile(_ rlmObject: UtilHandleRLMObject) -> URL {
        writeMobileConfigProfile(rlmObject, fileName: fileNameSetting)
        startCocoaHTTPServer()
        
        return URL(string: "http://localhost:8080")!
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
    
    // MARK: - NSXMLParserDelegate
    func parserDidStartDocument(_ parser: XMLParser) {
        //do nothing
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.didEndParse?(parser, readSummaryObjFromFile)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        switch elementName {
        case "key":
            isTagKey = true
            
        case "string": fallthrough
        case "integer":
            isTagValue = true
            break
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isTagKey {
            switch string {
            case ProfileXmlTag.AttachAPN:
                currentParseType = ApnSummaryObject.ApnInfoColumn.attach_APN
            case ProfileXmlTag.APNs:
                currentParseType = ApnSummaryObject.ApnInfoColumn.apns
            default:
                if string == "PayloadDisplayName" {
                    isPayloadDisplayName = true
                } else {
                    currentParseTag = ApnProfileObject.KeyAPNs(tag: string)
                }
            }
        } else if isTagValue {
            if isPayloadDisplayName {
                readSummaryObjFromFile.name = string
            } else {
                readSummaryObjFromFile.apnProfile.updateApnProfileColumn(currentParseType, column: currentParseTag, newText: string)
            }
            isPayloadDisplayName = false
        } else {
            //do nothing
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        isTagKey = false
        isTagValue = false
    }
}
