//
//  ApnSummaryObject.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/08.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ApnSummaryObject: RLMObject {
    dynamic var id = 0
    
    dynamic var name = ""
    dynamic var createdDate = 0.0
    dynamic var dataType = DataTypes.NORMAL.rawValue
    
    dynamic var apnProfile = ApnProfileObject()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    static func getLastId() -> Int {
        let lastObj = ApnSummaryObject.allObjects().lastObject() as! ApnSummaryObject
        return lastObj.id
    }
    
    enum DataTypes : Int {
        case NORMAL = 0,
        FAVORITE,
        MAX
    }
}
