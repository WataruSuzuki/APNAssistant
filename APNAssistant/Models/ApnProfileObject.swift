//
//  ApnProfileObject.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/09/23.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

struct ProfileXmlTag {
    static let AttachAPN = "AttachAPN"
    static let APNs = "APNs"
    static let Name = "Name"
    static let Username = "Username"
    static let Password = "Password"
    static let AuthenticationType = "AuthenticationType"
    static let ProxyServer = "ProxyServer"
    static let ProxyPort = "ProxyPort"
}

class ApnProfileObject: RLMObject {

    dynamic var apnsName = ""
    dynamic var apnsAuthenticationType = ""
    dynamic var apnsUserName = ""
    dynamic var apnsPassword = ""
    dynamic var apnsProxyServer = ""
    dynamic var apnsProxyServerPort = ""
    
    dynamic var attachApnName = ""
    dynamic var attachApnAuthenticationType = ""
    dynamic var attachApnUserName = ""
    dynamic var attachApnPassword = ""
    //dynamic var attachApnProxyServer = ""
    //dynamic var attachApnProxyServerPort = ""
    
    func updateApnProfileColumn(type: ApnSummaryObject.ApnInfoColumn, column: KeyAPNs, newText: String) {
        print("column(\(type)) = " + column.getTitle(type))
        print("newText = " + newText)
        switch column {
        case .NAME:
            if type == .APNS {
                self.apnsName = newText
            } else {
                self.attachApnName = newText
            }
            
        case .AUTHENTICATION_TYPE:
            if type == .APNS {
                self.apnsAuthenticationType = (newText.isEmpty ? "CHAP" : newText)
            } else {
                self.attachApnAuthenticationType = (newText.isEmpty ? "CHAP" : newText)
            }
            
        case .USERNAME:
            if type == .APNS {
                self.apnsUserName = newText
            } else {
                self.attachApnUserName = newText
            }
            
        case .PASSWORD:
            if type == .APNS {
                self.apnsPassword = newText
            } else {
                self.attachApnPassword = newText
            }
            
        case .PROXY_SERVER:
            if type == .APNS {
                self.apnsProxyServer = newText
            }
            
        case .PROXY_SERVER_PORT:
            if type == .APNS {
                self.apnsProxyServerPort = newText
            }
            
        default:
            break
        }
    }
    
    enum KeyAPNs : Int {
        case NAME = 0,
        AUTHENTICATION_TYPE,
        USERNAME,
        PASSWORD,
        PROXY_SERVER,
        PROXY_SERVER_PORT,
        MAX
        
        init(tag: String) {
            switch tag {
            case ProfileXmlTag.Name:
                self = .NAME
            case ProfileXmlTag.AuthenticationType:
                self = .AUTHENTICATION_TYPE
            case ProfileXmlTag.Username:
                self = .USERNAME
            case ProfileXmlTag.Password:
                self = .PASSWORD
            case ProfileXmlTag.ProxyServer:
                self = .PROXY_SERVER
            case ProfileXmlTag.ProxyPort:
                self = .PROXY_SERVER_PORT
            default:
                self = .MAX
            }
        }
        
        func getTitle(type: ApnSummaryObject.ApnInfoColumn) -> String {
            switch self {
            case KeyAPNs.NAME:
                return NSLocalizedString((type == .APNS ? "keyApnsName" : "keyAttachApnName"), comment: "")
            case KeyAPNs.AUTHENTICATION_TYPE:
                return NSLocalizedString((type == .APNS ? "keyApnsAuthenticationType" : "keyAttachApnAuthenticationType"), comment: "")
            case KeyAPNs.USERNAME:
                return NSLocalizedString((type == .APNS ? "keyApnsUsername" : "keyAttachApnUsername"), comment: "")
            case KeyAPNs.PASSWORD:
                return NSLocalizedString((type == .APNS ? "keyApnsPassword" : "keyAttachApnPassword"), comment: "")
            case KeyAPNs.PROXY_SERVER:
                return NSLocalizedString((type == .APNS ? "keyApnsProxyServer" : "keyAttachApnProxyServer"), comment: "")
            case KeyAPNs.PROXY_SERVER_PORT:
                return NSLocalizedString((type == .APNS ? "keyApnsProxyServerPort" : "keyAttachApnProxyServerPort"), comment: "")
            default:
                return ""
            }
        }
        
        static func maxRaw(type: ApnSummaryObject.ApnInfoColumn) -> Int {
            return (type == .ATTACH_APN ? (KeyAPNs.MAX.rawValue - 2) : KeyAPNs.MAX.rawValue)
        }
    }
}
