//
//  ConfigProfileKeys.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ConfigProfileKeys: NSObject {

    enum KeyAttachAPN : Int {
        case NAME = 0,
        AUTHENTICATION_TYPE,
        USERNAME,
        PASSWORD,
        PROXY_SERVER,
        PROXY_SERVER_PORT,
        MAX
        
        func getTitle() -> String {
            switch self {
            case KeyAttachAPN.NAME:
                return NSLocalizedString("keyAttachApnName", comment: "")
            case KeyAttachAPN.AUTHENTICATION_TYPE:
                return NSLocalizedString("keyAttachApnAuthenticationType", comment: "")
            case KeyAttachAPN.USERNAME:
                return NSLocalizedString("keyAttachApnUsername", comment: "")
            case KeyAttachAPN.PASSWORD:
                return NSLocalizedString("keyAttachApnPassword", comment: "")
            case KeyAttachAPN.PROXY_SERVER:
                return NSLocalizedString("keyAttachApnProxyServer", comment: "")
            case KeyAttachAPN.PROXY_SERVER_PORT:
                return NSLocalizedString("keyAttachApnProxyServerPort", comment: "")
            default:
                return ""
            }
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
        
        func getTitle() -> String {
            switch self {
            case KeyAPNs.NAME:
                return NSLocalizedString("keyApnsName", comment: "")
            case KeyAPNs.AUTHENTICATION_TYPE:
                return NSLocalizedString("keyApnsAuthenticationType", comment: "")
            case KeyAPNs.USERNAME:
                return NSLocalizedString("keyApnsUsername", comment: "")
            case KeyAPNs.PASSWORD:
                return NSLocalizedString("keyApnsPassword", comment: "")
            case KeyAPNs.PROXY_SERVER:
                return NSLocalizedString("keyApnsProxyServer", comment: "")
            case KeyAPNs.PROXY_SERVER_PORT:
                return NSLocalizedString("keyApnsProxyServerPort", comment: "")
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
