//
//  ApnProfileObject.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/08.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit
import Realm

class ApnProfileObject: RLMObject {
    dynamic var KeyAPNsName = ""
    dynamic var KeyAPNsAuthenticationType = ""
    dynamic var KeyAPNsUserName = ""
    dynamic var KeyAPNsPassword = ""
    dynamic var KeyAPNsProxyServer = ""
    dynamic var KeyAPNsProxyServerPort = ""

    dynamic var KeyAttachAPNName = ""
    dynamic var KeyAttachAPNAuthenticationType = ""
    dynamic var KeyAttachAPNUserName = ""
    dynamic var KeyAttachAPNPassword = ""
    dynamic var KeyAttachAPNProxyServer = ""
    dynamic var KeyAttachAPNProxyServerPort = ""
}
