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
    dynamic var country = Country.UNKNOWN.rawValue
    
    dynamic var apnProfile = ApnProfileObject()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    static func getLastId() -> Int {
        if let lastObj = ApnSummaryObject.allObjects().lastObject() as? ApnSummaryObject {
            print(lastObj.id)
            return lastObj.id + 1
        } else {
            return 1
        }
    }
    
    enum DataTypes : Int {
        case NORMAL = 0,
        FAVORITE,
        MAX
    }
    
    enum Country : Int {
        case UNKNOWN = -1,
        JAPAN,
        MAX
    }
    
    enum ApnSummaryColumn: Int {
        case NAME = 0,
        DATATYPE,
        MAX
    }
    
    enum ApnInfoColumn : Int {
        case SUMMARY = 0,
        ATTACH_APN,
        APNS,
        MAX
    }
}
