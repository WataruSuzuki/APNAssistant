//
//  ApnSummaryObject.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/09/23.
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
    
    static let sortProperties = [
        RLMSortDescriptor(property: "createdDate", ascending: false),
        RLMSortDescriptor(property: "id", ascending: false)
    ]
    
    static func getLastId() -> Int {
        if let lastObj = ApnSummaryObject.allObjects().lastObject() as? ApnSummaryObject {
            print(lastObj.id)
            return lastObj.id + 1
        } else {
            return 1
        }
    }
    
    static func getSearchedLists(keyword: String) -> RLMResults {
        return ApnSummaryObject.objectsWithPredicate(NSPredicate(format: "name contains %@", keyword))
    }
    
    static func getSearchedFavoriteLists(keyword: String) -> RLMResults {
        var objs = ApnSummaryObject.objectsWithPredicate(NSPredicate(format: "dataType = %d", DataTypes.FAVORITE.rawValue))
        objs = objs.objectsWithPredicate(NSPredicate(format: "name contains %@", keyword))
        
        return objs.sortedResultsUsingDescriptors(sortProperties)
    }
    
    static func getFavoriteLists() -> RLMResults {
        let objs = ApnSummaryObject.objectsWithPredicate(NSPredicate(format: "dataType = %d", DataTypes.FAVORITE.rawValue))
        
        return objs.sortedResultsUsingDescriptors(sortProperties)
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
