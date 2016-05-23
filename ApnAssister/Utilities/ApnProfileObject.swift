//
//  ApnProfileObject.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

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
    dynamic var attachApnProxyServer = ""
    dynamic var attachApnProxyServerPort = ""
    
    func updateApnProfileColumn(type: ApnType, column: KeyAPNs, newText: String) {
        //print("newText = " + newText)
        switch column {
        case .NAME:
            if type == .APNS {
                self.apnsName = newText
                print("apnsName = " + self.apnsName)
            } else {
                self.attachApnName = newText
                print("attachApnName = " + self.attachApnName)
            }
            
        case .AUTHENTICATION_TYPE:
            if type == .APNS {
                self.apnsAuthenticationType = newText
                print("apnsAuthenticationType = " + self.apnsAuthenticationType)
            } else {
                self.attachApnAuthenticationType = newText
                print("attachApnAuthenticationType = " + self.attachApnAuthenticationType)
            }
            
        case .USERNAME:
            if type == .APNS {
                self.apnsUserName = newText
                print("apnsUserName = " + self.apnsUserName)
            } else {
                self.attachApnUserName = newText
                print("attachApnUserName = " + self.attachApnUserName)
            }
            
        case .PASSWORD:
            if type == .APNS {
                self.apnsPassword = newText
                print("apnsPassword = " + self.apnsPassword)
            } else {
                self.attachApnPassword = newText
                print("attachApnPassword = " + self.attachApnPassword)
            }
            
        case .PROXY_SERVER:
            if type == .APNS {
                self.apnsProxyServer = newText
                print("apnsProxyServer = " + self.apnsProxyServer)
            } else {
                self.attachApnProxyServer = newText
                print("attachApnProxyServer = " + self.attachApnProxyServer)
            }
            
        case .PROXY_SERVER_PORT:
            if type == .APNS {
                self.apnsProxyServerPort = newText
                print("apnsProxyServerPort = " + self.apnsProxyServerPort)
            } else {
                self.attachApnProxyServerPort = newText
                print("attachApnProxyServerPort = " + self.attachApnProxyServerPort)
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
        
        func getTitle(type: ApnType) -> String {
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
        
        static func maxRaw(type: ApnType) -> Int {
            return (type == .APNS ? (KeyAPNs.MAX.rawValue - 2) : KeyAPNs.MAX.rawValue)
        }
    }
    
    enum ApnType : Int {
        case APNS = 0,
        ATTACH_APN,
        MAX
    }
}
