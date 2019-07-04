//
//  ConfigProfile+Xml.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2019/09/29.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import Foundation

extension ConfigProfileService: XMLParserDelegate {
    
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
                readSummaryObjFromFile.apnProfile?.updateApnProfileColumn(currentParseType, column: currentParseTag, newText: string)
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
