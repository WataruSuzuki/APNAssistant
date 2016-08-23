//
//  UtilHandleRLMObject.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/08.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

struct UtilHandleRLMConst {
    internal static let CREATE_NEW_PROFILE = -1
    internal static let CURRENT_SCHEMA_VERSION = UInt64(1)
}

class UtilHandleRLMObject: NSObject {
    /*
    static var sharedInstance: UtilHandleRLMObject = {
        return UtilHandleRLMObject()
    }()
    private override init() {}
    */
    
    let primaryId: Int!
    let apnProfileObj: ApnProfileObject!
    let apnSummaryObj: ApnSummaryObject!
    
    var arrayKeyApns = [String](count: ApnProfileObject.KeyAPNs.MAX.rawValue, repeatedValue:"")
    var arrayKeyAttachApn = [String](count: ApnProfileObject.KeyAPNs.MAX.rawValue, repeatedValue:"")
    var profileName = ""
    var summaryDataType = ApnSummaryObject.DataTypes.NORMAL
    
    required init(id: Int, profileObj: ApnProfileObject, summaryObj: ApnSummaryObject) {
        primaryId = id
        apnProfileObj = profileObj
        apnSummaryObj = summaryObj
        
        profileName = summaryObj.name
        summaryDataType = ApnSummaryObject.DataTypes(rawValue: summaryObj.dataType)!
    }
    
    func saveApnDataObj(realm: RLMRealm) {
        realm.addOrUpdateObject(apnSummaryObj)
        do {
            try realm.commitWriteTransaction()
        } catch let error as NSError{
            print(error.description)
        }
    }
    
    func deleteApnSummaryObj(obj: ApnSummaryObject) {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        realm.deleteObject(obj)
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
        //arrayKeyAttachApn[index] = prepareObj.attachApnProxyServer
        //index += 1
        //arrayKeyAttachApn[index] = prepareObj.attachApnProxyServerPort
    }
    
    func keepApnProfileColumnValue(type: ApnSummaryObject.ApnInfoColumn, column: ApnProfileObject.KeyAPNs, newText: String) {
        if type == .APNS {
            arrayKeyApns[column.rawValue] = newText
        } else {
            arrayKeyAttachApn[column.rawValue] = newText
        }
    }
    
    func getKeptApnProfileColumnValue(type: ApnSummaryObject.ApnInfoColumn, column: ApnProfileObject.KeyAPNs) -> String {
        if type == .APNS {
            return arrayKeyApns[column.rawValue]
        } else {
            return arrayKeyAttachApn[column.rawValue]
        }
    }
    
    func prepareApnData(realm: RLMRealm, isSetDataApnManually: Bool) {
        realm.beginWriteTransaction()
        
        prepareApnProfileColumn(.ATTACH_APN, columnArray: arrayKeyAttachApn)
        prepareApnProfileColumn(.APNS, columnArray: (isSetDataApnManually ? arrayKeyApns : arrayKeyAttachApn))
        
        prepareApnSummaryData()
    }
    
    func prepareApnSummaryData() {
        let now = NSDate()
        apnSummaryObj.createdDate = now.timeIntervalSinceReferenceDate
        apnSummaryObj.name = (profileName.isEmpty ? String(now) : profileName)
        apnSummaryObj.dataType = summaryDataType.rawValue
        if 0 > primaryId {
            apnSummaryObj.id = ApnSummaryObject.getLastId()
        }
        apnSummaryObj.apnProfile = apnProfileObj
    }
    
    func prepareApnProfileColumn(type: ApnSummaryObject.ApnInfoColumn, columnArray: Array<String>) {
        var index = 0
        for columnValue in columnArray {
            apnProfileObj.updateApnProfileColumn(type, column: ApnProfileObject.KeyAPNs(rawValue: index)!, newText: columnValue)
            index += 1
        }
    }
    
    static func getAppGroupPathURL() -> NSURL? {
        return NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group." + NSBundle.mainBundle().bundleIdentifier!.stringByReplacingOccurrencesOfString(".TodayWidget", withString: ""))
    }
    
    static func getDatabasePathOfAppGroupPathURL() -> NSURL? {
        return getAppGroupPathURL()?.URLByAppendingPathComponent("profiledatabases")
    }
    
    static func getDefaultRealmDatabaseURL(directoryURL: NSURL?) -> NSURL? {
        let containerURL = directoryURL?.URLByAppendingPathComponent("default.realm")
        
        return containerURL
    }
    
    static func setupGroupDB() {
        let containerURL = getDefaultRealmDatabaseURL(getDatabasePathOfAppGroupPathURL())
        print(containerURL?.path)
        
        let config = RLMRealmConfiguration.defaultConfiguration()
        config.fileURL = containerURL
        config.schemaVersion = UtilHandleRLMConst.CURRENT_SCHEMA_VERSION
        config.migrationBlock = {(migration, oldSchemaVersion) in
            // 最初のマイグレーションの場合、`oldSchemaVersion`は0です
            if (oldSchemaVersion < UtilHandleRLMConst.CURRENT_SCHEMA_VERSION) {
                // 何もする必要はありません！
                // Realmは自動的に新しく追加されたプロパティと、削除されたプロパティを認識します。
                // そしてディスク上のスキーマを自動的にアップデートします。
            }
        }
        RLMRealmConfiguration.setDefaultConfiguration(config)
    }
    
    static func getRealmDatabaseFiles(targetURL: NSURL?) -> [NSURL?] {
        let URLs = [
            targetURL,
            targetURL?.URLByAppendingPathExtension("lock"),
            targetURL?.URLByAppendingPathExtension("management")
        ]
        
        return URLs
    }
    
    static func copyToGroupDB() {
        let manager = NSFileManager.defaultManager()
        let config = RLMRealmConfiguration.defaultConfiguration()
        let oldURLs = getRealmDatabaseFiles(config.fileURL)
        
        let containerDirectory = getDatabasePathOfAppGroupPathURL()
        if nil == containerDirectory?.path
            || !manager.fileExistsAtPath(containerDirectory!.path!)
        {
            try! manager.createDirectoryAtURL(containerDirectory!, withIntermediateDirectories: true, attributes: nil)
        }
        
        let containerURL = getDefaultRealmDatabaseURL(containerDirectory)
        let newURLs = getRealmDatabaseFiles(containerURL)
        
        var index = 0
        for oldURL in oldURLs {
            do {
                try manager.copyItemAtURL(oldURL!, toURL: newURLs[index]!)
                index += 1
                try manager.removeItemAtURL(oldURL!)
            } catch {
                let nsError = error as NSError
                print(nsError.description)
            }
        }
    }
}
