//
//  ApnSummaryObject.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/04/08.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ApnSummaryObject: RLMObject {
    @objc dynamic var id = 0
    
    @objc dynamic var name = ""
    @objc dynamic var createdDate = 0.0
    @objc dynamic var dataType = DataTypes.normal.rawValue
    @objc dynamic var country = Country.unknown.rawValue
    
    @objc dynamic var apnProfile = ApnProfileObject()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    static let sortProperties = [
        RLMSortDescriptor(keyPath: "createdDate", ascending: false),
        RLMSortDescriptor(keyPath: "id", ascending: false)
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
        return ApnSummaryObject.objects(with: NSPredicate(format: "name contains %@", keyword)) as! RLMResults<RLMObject>
    }
    
    static func getSearchedFavoriteLists(_ keyword: String) -> RLMResults<RLMObject> {
        var objs = ApnSummaryObject.objects(with: NSPredicate(format: "dataType = %d", DataTypes.favorite.rawValue))
        objs = objs.objects(with: NSPredicate(format: "name contains %@", keyword))
        
        return objs.sortedResults(using: sortProperties) as! RLMResults<RLMObject>
    }
    
    static func getFavoriteLists() -> RLMResults<RLMObject> {
        let objs = ApnSummaryObject.objects(with: NSPredicate(format: "dataType = %d", DataTypes.favorite.rawValue))
        
        return objs.sortedResults(using: sortProperties) as! RLMResults<RLMObject>
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
