//
//  FirstViewController.swift
//  ApnAssister
//
//  Created by 鈴木 航 on 2016/03/18.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func writeFile() {
        let accessPointName = "freetel.link"
        let payloadDescription = "APNS Assister profile"
        let payloadDisplayName = "APNS Assister chooser"
        let bundleID = NSBundle.mainBundle().bundleIdentifier!
        let UUID_forPayloadId = "f9dbd18b-90ff-58c1-8605-5abae9c50691"
        let UUID_forPayloadInfo = "4be0643f-1d98-573b-97cd-ca98a65347dd"
        
        // build the Configuration Profile
        let startOfXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist version=\"1.0\"><dict><key>PayloadType</key><string>Configuration</string><key>PayloadVersion</key><integer>1</integer>"
        let xmlOfProfileIdentifier = "<key>PayloadIdentifier</key><string>" + bundleID + "</string><key>PayloadUUID</key><string>" + UUID_forPayloadId + "</string>"
        let xmlOfPayloadDescription = "<key>PayloadDisplayName</key><string>iOS Configuration Profile</string><key>PayloadDescription</key><string>" + payloadDescription + "</string><key>PayloadContent</key><array><dict><key>PayloadType</key><string>com.apple.cellular</string><key>PayloadVersion</key><integer>1</integer>"
        
        let xmlOfPayloadInfo = "<key>PayloadIdentifier</key><string>" + bundleID + "</string><key>PayloadUUID</key><string>" + UUID_forPayloadInfo + "</string><key>PayloadDisplayName</key><string>" + payloadDisplayName + "</string><key>PayloadDescription</key><string>" + payloadDescription + "</string><key>AttachAPN</key><dict><key>Name</key><string>" + accessPointName + "</string><key>AuthenticationType</key><string>CHAP</string></dict><key>APNs</key><array><dict><key>Name</key><string>" + accessPointName
        let endOfXml = "</string><key>AuthenticationType</key><string>CHAP</string></dict></array></dict></array></dict></plist>"
        
        let xml = startOfXml
            + xmlOfProfileIdentifier
            + xmlOfPayloadDescription
            + xmlOfPayloadInfo
            + endOfXml
        
        // build the path where you're going to save the HTML
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = documentsPath + "/" + "profile.mobileconfig"
        
        // save the NSString that contains the HTML to a file
        try! xml.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
    }
}

