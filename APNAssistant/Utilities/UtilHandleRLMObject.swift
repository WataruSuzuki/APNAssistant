//
//  UtilHandleRLMObject.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/04/08.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit
import Realm

struct UtilHandleRLMConst {
    internal static let CREATE_NEW_PROFILE = -1
    internal static let CURRENT_SCHEMA_VERSION = UInt64(4)
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
    
    var arrayKeyApns = [String](repeating: "", count: ApnProfileObject.KeyAPNs.max.rawValue)
    var arrayKeyAttachApn = [String](repeating: "", count: ApnProfileObject.KeyAPNs.max.rawValue)
    var profileName = ""
    var summaryDataType = ApnSummaryObject.DataTypes.normal
    
    required init(id: Int, profileObj: ApnProfileObject, summaryObj: ApnSummaryObject) {
        primaryId = id
        apnProfileObj = profileObj
        apnSummaryObj = summaryObj
        
        profileName = summaryObj.name
        summaryDataType = ApnSummaryObject.DataTypes(rawValue: summaryObj.dataType)!
    }
    
    func saveUpdateApnDataObj(_ realm: RLMRealm, isSetDataApnManually: Bool) {
        realm.beginWriteTransaction()
        prepareApnData(isSetDataApnManually)
        realm.addOrUpdate(apnSummaryObj)
        do {
            try realm.commitWriteTransaction()
        } catch let error as NSError{
            print(error.description)
        }
    }
    
    func deleteApnSummaryObj(_ obj: ApnSummaryObject) {
        let realm = RLMRealm.default()
        realm.beginWriteTransaction()
        realm.delete(obj)
        do {
            try realm.commitWriteTransaction()
        } catch let error as NSError{
            print(error.description)
        }
    }
    
    func prepareKeepApnProfileColumn(_ prepareObj: ApnProfileObject) {
        for index in 0..<ApnProfileObject.KeyAPNs.max.rawValue {
            if let keyApns = ApnProfileObject.KeyAPNs(rawValue: index) {
                arrayKeyApns[index] = keyApns.getPreparedAPNValue(prepareObj: prepareObj)
            }
        }
        
        for index in 0..<ApnProfileObject.KeyAPNs.max.rawValue {
            if let keyApns = ApnProfileObject.KeyAPNs(rawValue: index) {
                arrayKeyAttachApn[index] = keyApns.getPreparedAttachValue(prepareObj: prepareObj)
            }
        }
    }
    
    func keepApnProfileColumnValue(_ type: ApnSummaryObject.ApnInfoColumn, column: ApnProfileObject.KeyAPNs, newText: String) {
        if type == .apns {
            arrayKeyApns[column.rawValue] = newText
        } else {
            arrayKeyAttachApn[column.rawValue] = newText
        }
    }
    
    func getKeptApnProfileColumnValue(_ type: ApnSummaryObject.ApnInfoColumn, column: ApnProfileObject.KeyAPNs) -> String {
        if type == .apns {
            return arrayKeyApns[column.rawValue]
        } else {
            return arrayKeyAttachApn[column.rawValue]
        }
    }
    
    func prepareApnData(_ isSetDataApnManually: Bool) {
        prepareApnProfileColumn(.attach_APN, columnArray: arrayKeyAttachApn)
        prepareApnProfileColumn(.apns, columnArray: (isSetDataApnManually ? arrayKeyApns : arrayKeyAttachApn))
        
        prepareApnSummaryData()
    }
    
    func prepareApnSummaryData() {
        let now = Date()
        apnSummaryObj.createdDate = now.timeIntervalSinceReferenceDate
        apnSummaryObj.name = (profileName.isEmpty ? String(describing: now) : profileName)
        apnSummaryObj.dataType = summaryDataType.rawValue
        if 0 > primaryId {
            apnSummaryObj.id = ApnSummaryObject.getLastId()
        }
        apnSummaryObj.apnProfile = apnProfileObj
    }
    
    func prepareApnProfileColumn(_ type: ApnSummaryObject.ApnInfoColumn, columnArray: Array<String>) {
        var index = 0
        for columnValue in columnArray {
            apnProfileObj.updateApnProfileColumn(type, column: ApnProfileObject.KeyAPNs(rawValue: index)!, newText: columnValue)
            index += 1
        }
    }
    
    static func getDatabasePathOfAppGroupPathURL() -> URL? {
        return UtilFileManager.getAppGroupPathURL()?.appendingPathComponent("profiledatabases")
    }
    
    static func getDefaultRealmDatabaseURL(_ directoryURL: URL?) -> URL? {
        let containerURL = directoryURL?.appendingPathComponent("default.realm")
        
        return containerURL
    }
    
    static func setupGroupDB() {
        guard let containerURL = getDefaultRealmDatabaseURL(getDatabasePathOfAppGroupPathURL()) else {
            return
        }
        print(containerURL.path)
        
        let config = RLMRealmConfiguration.default()
        config.fileURL = containerURL
        config.schemaVersion = UtilHandleRLMConst.CURRENT_SCHEMA_VERSION
        config.migrationBlock = {(migration, oldSchemaVersion) in
            // Note : https://realm.io/docs/objc/latest/#migrations
            if (oldSchemaVersion < UtilHandleRLMConst.CURRENT_SCHEMA_VERSION) {
                migration.enumerateObjects(ApnSummaryObject.className()) { (oldObject, newObject) in
                    // Note : https://realm.io/docs/objc/latest/#updating-values
                    oldObject?.objectSchema.properties.forEach({ (migrationSummary) in
                        if migrationSummary.name != "apnProfile" {
                            if let migrationSummaryProperty = oldObject?[migrationSummary.name] {
                                newObject?[migrationSummary.name] = migrationSummaryProperty
                            }
                        } else {
                            if let oldProfile = oldObject?["apnProfile"] as? RLMObject,
                                let newProfile = newObject?["apnProfile"] as? RLMObject {
                                oldProfile.objectSchema.properties.forEach { (migrationApnElement) in
                                    if let apnElementProperty = oldProfile[migrationApnElement.name] {
                                        newProfile[migrationApnElement.name] = apnElementProperty
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
        RLMRealmConfiguration.setDefault(config)
    }
    
    static func getRealmDatabaseFiles(_ targetURL: URL?) -> [URL]? {
        guard let targetURL = targetURL else { return nil }
        
        return [
            targetURL,
            targetURL.appendingPathExtension("lock"),
            targetURL.appendingPathExtension("management")
        ]
    }
    
    static func copyToGroupDB() {
        let manager = FileManager.default
        let config = RLMRealmConfiguration.default()
        
        let containerDirectory = getDatabasePathOfAppGroupPathURL()
        if nil == containerDirectory?.path
            || !manager.fileExists(atPath: containerDirectory!.path)
        {
            try! manager.createDirectory(at: containerDirectory!, withIntermediateDirectories: true, attributes: nil)
        }
        
        guard let containerURL = getDefaultRealmDatabaseURL(containerDirectory) else { return }
        
        if let oldURLs = getRealmDatabaseFiles(config.fileURL),
            let newURLs = getRealmDatabaseFiles(containerURL) {
            newURLs.enumerated().forEach { (index, url) in
                do {
                    try manager.copyItem(at: oldURLs[index], to: url)
                    try manager.removeItem(at: oldURLs[index])
                } catch {
                    let nsError = error as NSError
                    print(nsError.description)
                }
            }
        }
    }
}
