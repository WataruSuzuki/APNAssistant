//
//  ApnSummaryObject.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/08.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ApnSummaryObject: RLMObject {
    dynamic var name = ""
    dynamic var createdDate = 0.0
    dynamic var dataType = DataTypes.NORMAL.rawValue
    
    dynamic var apnProfile = ApnProfileObject()
    
    enum DataTypes : Int {
        case NORMAL = 0,
        FAVORITE,
        MAX
    }
}