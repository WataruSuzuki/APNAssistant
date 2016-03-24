//
//  ConfigProfileUtils.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ConfigProfileUtils: NSObject {

    enum keyAPNs : Int {
        case NAME = 0,
        AUTHENTICATION_TYPE,
        USERNAME,
        PASSWORD,
        PROXY_SERVER,
        PROXY_SERVER_PORT,
        MAX
        /*
        func getGaugeDispTypeTitle() -> String {
            switch self {
            case GaugeDispType.CAFFEINE:
                return NSLocalizedString("your_caffeine", comment: "")
            case GaugeDispType.TIME:
                return NSLocalizedString("time_left", comment: "")
            default:
                return ""
            }
        }
        func getGaugeDispTypeUnit() -> String {
            switch self {
            case GaugeDispType.CAFFEINE:
                return NSLocalizedString("caffeine_unit_mg", comment: "")
            case GaugeDispType.TIME:
                return NSLocalizedString("time_left", comment: "")
            default:
                return ""
            }
        }*/
    }
    
}
