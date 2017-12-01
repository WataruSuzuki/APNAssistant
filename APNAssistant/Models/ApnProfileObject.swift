//
//  ApnProfileObject.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/03/24.
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
    static let AllowedProtocolMask = "AllowedProtocolMask"
    static let AllowedProtocolMaskInRoaming = "AllowedProtocolMaskInRoaming"
    static let AllowedProtocolMaskInDomesticRoaming = "AllowedProtocolMaskInDomesticRoaming"
}

enum AllowedProtocolMask: Int {
    case ipv4 = 1,
    ipv6,
    both
}

class ApnProfileObject: RLMObject {

    @objc dynamic var apnsName = ""
    @objc dynamic var apnsAuthenticationType = ""
    @objc dynamic var apnsUserName = ""
    @objc dynamic var apnsPassword = ""
    @objc dynamic var apnsProxyServer = ""
    @objc dynamic var apnsProxyServerPort = ""
    @objc dynamic var apnsAllowedProtocolMask = ""
    @objc dynamic var apnsAllowedProtocolMaskInRoaming = ""
    @objc dynamic var apnsAllowedProtocolMaskInDomesticRoaming = ""
    
    @objc dynamic var attachApnName = ""
    @objc dynamic var attachApnAuthenticationType = ""
    @objc dynamic var attachApnUserName = ""
    @objc dynamic var attachApnPassword = ""
    
    func updateApnProfileColumn(_ type: ApnSummaryObject.ApnInfoColumn, column: KeyAPNs, newText: String) {
        print("column(\(type)) = " + column.getTitle(type))
        print("newText = " + newText)
        switch column {
        case .name:
            if type == .apns {
                self.apnsName = newText
            } else {
                self.attachApnName = newText
            }
            
        case .authentication_type:
            if type == .apns {
                self.apnsAuthenticationType = (newText.isEmpty ? "CHAP" : newText)
            } else {
                self.attachApnAuthenticationType = (newText.isEmpty ? "CHAP" : newText)
            }
            
        case .username:
            if type == .apns {
                self.apnsUserName = newText
            } else {
                self.attachApnUserName = newText
            }
            
        case .password:
            if type == .apns {
                self.apnsPassword = newText
            } else {
                self.attachApnPassword = newText
            }
            
        case .proxy_server:
            if type == .apns {
                self.apnsProxyServer = newText
            }
            
        case .proxy_server_port:
            if type == .apns {
                self.apnsProxyServerPort = newText
            }
            
        case .allowed_protocol_mask:
            if type == .apns {
                self.apnsAllowedProtocolMask = newText
            }

        case .allowed_protocol_mask_in_roaming:
            if type == .apns {
                self.apnsAllowedProtocolMaskInRoaming = newText
            }

        case .allowed_protocol_mask_in_domestic_roaming:
            if type == .apns {
                self.apnsAllowedProtocolMaskInDomesticRoaming = newText
            }
            
        default:
            break
        }
    }
    
    enum KeyAPNs : Int {
        case name = 0,
        authentication_type,
        username,
        password,
        proxy_server,
        proxy_server_port,
        allowed_protocol_mask,
        allowed_protocol_mask_in_roaming,
        allowed_protocol_mask_in_domestic_roaming,
        max
        
        init(tag: String) {
            switch tag {
            case ProfileXmlTag.Name:
                self = .name
            case ProfileXmlTag.AuthenticationType:
                self = .authentication_type
            case ProfileXmlTag.Username:
                self = .username
            case ProfileXmlTag.Password:
                self = .password
            case ProfileXmlTag.ProxyServer:
                self = .proxy_server
            case ProfileXmlTag.ProxyPort:
                self = .proxy_server_port
            default:
                self = .max
            }
        }
        
        func getTitle(_ type: ApnSummaryObject.ApnInfoColumn) -> String {
            var key = ""
            switch self {
            case KeyAPNs.name:
                return NSLocalizedString((type == .apns ? "keyApnsName" : "keyAttachApnName"), comment: "")
            case KeyAPNs.authentication_type:
                return NSLocalizedString((type == .apns ? "keyApnsAuthenticationType" : "keyAttachApnAuthenticationType"), comment: "")
            case KeyAPNs.username:
                return NSLocalizedString((type == .apns ? "keyApnsUsername" : "keyAttachApnUsername"), comment: "")
            case KeyAPNs.password:
                return NSLocalizedString((type == .apns ? "keyApnsPassword" : "keyAttachApnPassword"), comment: "")
            case KeyAPNs.proxy_server:
                return NSLocalizedString((type == .apns ? "keyApnsProxyServer" : "keyAttachApnProxyServer"), comment: "")
            case KeyAPNs.proxy_server_port:
                return NSLocalizedString((type == .apns ? "keyApnsProxyServerPort" : "keyAttachApnProxyServerPort"), comment: "")
            case KeyAPNs.allowed_protocol_mask:
                key = ProfileXmlTag.AllowedProtocolMask
            case KeyAPNs.allowed_protocol_mask_in_roaming:
                key = ProfileXmlTag.AllowedProtocolMaskInRoaming
            case KeyAPNs.allowed_protocol_mask_in_domestic_roaming:
                key = ProfileXmlTag.AllowedProtocolMaskInDomesticRoaming

            default:
                return ""
            }
            
            return NSLocalizedString((type == .apns ? "keyApns" + key : "keyAttachApn" + key), comment: "")
        }
        
        func getPreparedAPNValue(prepareObj: ApnProfileObject) -> String {
            switch self {
            case .name:
                return prepareObj.apnsName
            case .authentication_type:
                return prepareObj.apnsAuthenticationType
            case .username:
                return prepareObj.apnsUserName
            case .password:
                return prepareObj.apnsPassword
            case.proxy_server:
                return prepareObj.apnsProxyServer
            case .proxy_server_port:
                return prepareObj.apnsProxyServerPort
            case .allowed_protocol_mask:
                return prepareObj.apnsAllowedProtocolMask
                
            default:
                return ""
            }
        }
        
        func getPreparedAttachValue(prepareObj: ApnProfileObject) -> String {
            switch self {
            case .name:
                return prepareObj.attachApnName
            case .authentication_type:
                return prepareObj.attachApnAuthenticationType
            case .username:
                return prepareObj.attachApnUserName
            case .password:
                return prepareObj.attachApnPassword
                
            default:
                return ""
            }
        }
        
        static func maxRaw(_ type: ApnSummaryObject.ApnInfoColumn) -> Int {
            let removedListWhenAttachApn = [KeyAPNs.proxy_server, KeyAPNs.proxy_server_port]
            var maxRow = KeyAPNs.max.rawValue
            if #available(iOS 10.3, *) {
                //do nothing
            } else {
                let removedListUnder10_2 = [KeyAPNs.allowed_protocol_mask, KeyAPNs.allowed_protocol_mask_in_roaming, KeyAPNs.allowed_protocol_mask_in_domestic_roaming]
                maxRow -= removedListUnder10_2.count
            }
            return (type == .attach_APN ? (maxRow - removedListWhenAttachApn.count) : maxRow)
        }
    }
}
