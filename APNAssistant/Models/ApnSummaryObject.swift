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
    dynamic var dataType = DataTypes.normal.rawValue
    dynamic var country = Country.unknown.rawValue
    
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
    
    static func getSearchedLists(_ keyword: String) -> RLMResults<RLMObject> {
        return ApnSummaryObject.objects(with: NSPredicate(format: "name contains %@", keyword))
    }
    
    static func getSearchedFavoriteLists(_ keyword: String) -> RLMResults<RLMObject> {
        var objs = ApnSummaryObject.objects(with: NSPredicate(format: "dataType = %d", DataTypes.favorite.rawValue))
        objs = objs.objects(with: NSPredicate(format: "name contains %@", keyword))
        
        return objs.sortedResults(using: sortProperties)
    }
    
    static func getFavoriteLists() -> RLMResults<RLMObject> {
        let objs = ApnSummaryObject.objects(with: NSPredicate(format: "dataType = %d", DataTypes.favorite.rawValue))
        
        return objs.sortedResults(using: sortProperties)
    }
    
    enum DataTypes : Int {
        case normal = 0,
        favorite,
        max
    }
    
    enum Country : Int {
        case unknown = -1,
        japan,
        max
    }
    
    enum ApnSummaryColumn: Int {
        case name = 0,
        datatype,
        max
    }
    
    enum ApnInfoColumn : Int {
        case summary = 0,
        attach_APN,
        apns,
        max
    }
}
