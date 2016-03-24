//
//  ConfigProfileUtils.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ConfigProfileUtils: NSObject {

    enum keyAttachAPN : Int {
        case NAME = 0,
        AUTHENTICATION_TYPE,
        USERNAME,
        PASSWORD,
        PROXY_SERVER,
        PROXY_SERVER_PORT,
        MAX
        
        func getTitle() -> String {
            switch self {
            case keyAttachAPN.NAME:
                return NSLocalizedString("keyAttachApnName", comment: "")
            case keyAttachAPN.AUTHENTICATION_TYPE:
                return NSLocalizedString("keyAttachApnAuthenticationType", comment: "")
            case keyAttachAPN.USERNAME:
                return NSLocalizedString("keyAttachApnUsername", comment: "")
            case keyAttachAPN.PASSWORD:
                return NSLocalizedString("keyAttachApnPassword", comment: "")
            case keyAttachAPN.PROXY_SERVER:
                return NSLocalizedString("keyAttachApnProxyServer", comment: "")
            case keyAttachAPN.PROXY_SERVER_PORT:
                return NSLocalizedString("keyAttachApnProxyServerPort", comment: "")
            default:
                return ""
            }
        }
    }
    
    enum keyAPNs : Int {
        case NAME = 0,
        AUTHENTICATION_TYPE,
        USERNAME,
        PASSWORD,
        PROXY_SERVER,
        PROXY_SERVER_PORT,
        MAX
        
        func getTitle() -> String {
            switch self {
            case keyAPNs.NAME:
                return NSLocalizedString("keyApnsName", comment: "")
            case keyAPNs.AUTHENTICATION_TYPE:
                return NSLocalizedString("keyApnsAuthenticationType", comment: "")
            case keyAPNs.USERNAME:
                return NSLocalizedString("keyApnsUsername", comment: "")
            case keyAPNs.PASSWORD:
                return NSLocalizedString("keyApnsPassword", comment: "")
            case keyAPNs.PROXY_SERVER:
                return NSLocalizedString("keyApnsProxyServer", comment: "")
            case keyAPNs.PROXY_SERVER_PORT:
                return NSLocalizedString("keyApnsProxyServerPort", comment: "")
            default:
                return ""
            }
        }
    }
    
}
