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
    
    var arrayKeyApns = [String](count: ApnProfileObject.KeyAPNs.MAX.rawValue, repeatedValue:"")
    var arrayKeyAttachApn = [String](count: ApnProfileObject.KeyAPNs.MAX.rawValue, repeatedValue:"")
    
    func saveApnProfileObj(apnObj: ApnProfileObject) {
        realm.beginWriteTransaction()
        realm.addObject(apnObj)
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
    }
    
    func prepareApnProfileColumn(type: ApnProfileObject.ApnType, columnArray: Array<String>) {
        var index = 0
        for columnValue in columnArray {
            apnProfileObj.updateApnProfileColumn(type, column: ApnProfileObject.KeyAPNs(rawValue: index)!, newText: columnValue)
            index += 1
        }
    }
}
