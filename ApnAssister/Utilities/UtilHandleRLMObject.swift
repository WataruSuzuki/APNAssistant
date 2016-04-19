//
//  UtilHandleRLMObject.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/08.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilHandleRLMObject: NSObject {
    /*
    static var sharedInstance: UtilHandleRLMObject = {
        return UtilHandleRLMObject()
    }()
    private override init() {}
    */
    
    let realm = RLMRealm.defaultRealm()
    let apnProfileObj = ApnProfileObject()
    let apnSummaryObj = ApnDataObject()
    
    var arrayKeyApns = [String](count: ApnProfileObject.KeyAPNs.MAX.rawValue, repeatedValue:"")
    var arrayKeyAttachApn = [String](count: ApnProfileObject.KeyAPNs.MAX.rawValue, repeatedValue:"")
    
    func saveApnDataObj() {
        realm.beginWriteTransaction()
        realm.addObject(apnSummaryObj)
        do {
            try realm.commitWriteTransaction()
        } catch let error as NSError{
            print(error.description)
        }
    }
    
    func keepApnProfileColumnValue(type: ApnProfileObject.ApnType, column: ApnProfileObject.KeyAPNs, newText: String) {
        if type == .APNS {
            arrayKeyApns[column.rawValue] = newText
        } else {
            arrayKeyAttachApn[column.rawValue] = newText
        }
    }
    
    func getKeptApnProfileColumnValue(type: ApnProfileObject.ApnType, column: ApnProfileObject.KeyAPNs) -> String {
        if type == .APNS {
            return arrayKeyApns[column.rawValue]
        } else {
            return arrayKeyAttachApn[column.rawValue]
        }
    }
    
    func prepareApnData() {
        prepareApnProfileColumn(.APNS, columnArray: arrayKeyApns)
        prepareApnProfileColumn(.ATTACH_APN, columnArray: arrayKeyAttachApn)
        
        prepareApnSummaryData()
    }
    
    func prepareApnSummaryData() {
        let now = NSDate()
        apnSummaryObj.createdDate = now.timeIntervalSinceDate(NSDate())
        apnSummaryObj.name = String(apnSummaryObj.createdDate)
        
        apnSummaryObj.apnProfile = apnProfileObj
    }
    
    func prepareApnProfileColumn(type: ApnProfileObject.ApnType, columnArray: Array<String>) {
        var index = 0
        for columnValue in columnArray {
            apnProfileObj.updateApnProfileColumn(type, column: ApnProfileObject.KeyAPNs(rawValue: index)!, newText: columnValue)
            index += 1
        }
    }
}
