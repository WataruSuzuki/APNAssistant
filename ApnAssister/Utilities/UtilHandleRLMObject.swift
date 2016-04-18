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
    
    func saveApnProfileObj(apnObj: ApnProfileObject) {
        realm.beginWriteTransaction()
        realm.addObject(apnObj)
        do {
            try realm.commitWriteTransaction()
        } catch let error as NSError{
            print(error.description)
        }
    }
    
}
