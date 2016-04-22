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
    let apnSummaryObj = ApnSummaryObject()
    
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
    
    func prepareKeepApnProfileColumn(prepareObj: ApnProfileObject) {
        var index = 0
        arrayKeyApns[index] = prepareObj.apnsName
        index += 1
        arrayKeyApns[index] = prepareObj.apnsAuthenticationType
        index += 1
        arrayKeyApns[index] = prepareObj.apnsUserName
        index += 1
        arrayKeyApns[index] = prepareObj.apnsPassword
        index += 1
        arrayKeyApns[index] = prepareObj.apnsProxyServer
        index += 1
        arrayKeyApns[index] = prepareObj.apnsProxyServerPort
        
        index = 0
        arrayKeyAttachApn[index] = prepareObj.attachApnName
        index += 1
        arrayKeyAttachApn[index] = prepareObj.attachApnAuthenticationType
        index += 1
        arrayKeyAttachApn[index] = prepareObj.attachApnUserName
        index += 1
        arrayKeyAttachApn[index] = prepareObj.attachApnPassword
        index += 1
        arrayKeyAttachApn[index] = prepareObj.attachApnProxyServer
        index += 1
        arrayKeyAttachApn[index] = prepareObj.attachApnProxyServerPort
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
        apnSummaryObj.createdDate = now.timeIntervalSinceNow
        apnSummaryObj.name = String(now)
        
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
