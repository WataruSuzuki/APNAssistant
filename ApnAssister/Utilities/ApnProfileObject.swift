//
//  ApnProfileObject.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ApnProfileObject: RLMObject {

    dynamic var columnAPNs = KeyAPNs.NAME.rawValue
    
    var columnAPNsAsEnum: KeyAPNs {
        get {
            return KeyAPNs(rawValue: columnAPNs)!
        }
        set {
            columnAPNs = newValue.rawValue
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
    }
    
    enum ApnType : Int {
        case APNS = 0,
        ATTACH_APN,
        MAX
    }
}
