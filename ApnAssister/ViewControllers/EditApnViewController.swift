//
//  EditApnViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class EditApnViewController: UITableViewController
{
    let myUtilHandleRLMObject = UtilHandleRLMObject()
    let cocoaHTTPServer = HTTPServer()
    
    var isCompFirstRespond = false
    var isSetDataApnManually = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("edit_apn", comment: "")
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        registerCustomCell("TextFieldCell")
        registerCustomCell("UISwitchCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerCustomCell(nibIdentifier: String) {
        let nib = UINib(nibName: nibIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: nibIdentifier)
    }
    
    func getTextFieldForCell(indexPath: NSIndexPath) -> UITextField {
        let newUITextField = UITextField()
        newUITextField.adjustsFontSizeToFitWidth = true
        newUITextField.returnKeyType = .Next
        
        return newUITextField
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ApnProfileObject.ApnType.MAX.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = ApnProfileObject.ApnType(rawValue: section)
        switch sectionType! {
        case .APNS:
            //No Proxy Settings
            return ApnProfileObject.KeyAPNs.maxRaw(sectionType!)
            
        case .ATTACH_APN:
            if isSetDataApnManually {
                return ApnProfileObject.KeyAPNs.maxRaw(sectionType!) + 1
            } else {
                return 1
            }
            
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch ApnProfileObject.ApnType(rawValue: indexPath.section)! {
        case .APNS:
            return loadTextFieldCell(tableView, cellForRowAtIndexPath: indexPath)
            
        case .ATTACH_APN:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("UISwitchCell", forIndexPath: indexPath) as! UISwitchCell
                cell.myUILabel?.text = NSLocalizedString("setAttachApnManual", comment: "")
                cell.switchValueChanged = {(switchOn) in
                    self.isSetDataApnManually = switchOn
                    UIView.animateWithDuration(0.4, animations: {
                        self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
                    })
                }
                cell.myUISwitch.on = isSetDataApnManually
                
                return cell
                
            } else {
                return loadTextFieldCell(tableView, cellForRowAtIndexPath: indexPath)
            }
            
        default:
            break
        }

        return tableView.dequeueReusableCellWithIdentifier("EditApnViewCell", forIndexPath: indexPath)
    }
    
    func loadTextFieldCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TextFieldCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell", forIndexPath: indexPath) as! TextFieldCell
        //let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
        
        let type = ApnProfileObject.ApnType(rawValue: indexPath.section)!
        let column = ApnProfileObject.KeyAPNs(rawValue: (type == .APNS ? indexPath.row : indexPath.row - 1))!
        cell.myUILabel?.text = column.getTitle(type)
        cell.myUITextField.text = myUtilHandleRLMObject.getKeptApnProfileColumnValue(type, column: column)
        
        if !isCompFirstRespond && indexPath.section == 0 && indexPath.row == 0 {
            cell.myUITextField.becomeFirstResponder()
            isCompFirstRespond = true
        }
        
        cell.didBeginEditing = {(textField) in
            //TODO
        }
        cell.didEndEditing = {(textField) in
            //TODO
        }
        cell.shouldChangeCharactersInRange = {(textField, range, string) in
            self.myUtilHandleRLMObject.keepApnProfileColumnValue(type, column: column, newText: textField.text! + string)
            return true
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionType = ApnProfileObject.ApnType(rawValue: indexPath.section)
        switch sectionType! {
        case .APNS:
            let newTextFieldCell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
            return newTextFieldCell.frame.height
            
        case .ATTACH_APN:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("UISwitchCell") as! UISwitchCell
                return cell.frame.height
                
            } else {
                let newTextFieldCell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                return newTextFieldCell.frame.height
            }
            
        default:
            return tableView.rowHeight
        }
    }
    
    func writeMobileConfigProfile() {
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
        //xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist version=\"1.0\"><dict><key>PayloadType</key><string>Configuration</string><key>PayloadVersion</key><integer>1</integer><key>PayloadIdentifier</key><string>jp.co.JchanKchan.WriteFile</string><key>PayloadUUID</key><string>f9dbd18b-90ff-58c1-8605-5abae9c50691</string><key>PayloadDisplayName</key><string>iOS Configuration Profile</string><key>PayloadDescription</key><string>APNS Assister profile</string><key>PayloadContent</key><array><dict><key>PayloadType</key><string>com.apple.cellular</string><key>PayloadVersion</key><integer>1</integer><key>PayloadIdentifier</key><string>jp.co.JchanKchan.WriteFile</string><key>PayloadUUID</key><string>4be0643f-1d98-573b-97cd-ca98a65347dd</string><key>PayloadDisplayName</key><string>APNS Assister chooser</string><key>PayloadDescription</key><string>APNS Assister profile</string><key>AttachAPN</key><dict><key>Name</key><string>freetel.link</string><key>AuthenticationType</key><string>CHAP</string></dict><key>APNs</key><array><dict><key>Name</key><string>freetel.link</string><key>AuthenticationType</key><string>CHAP</string></dict></array></dict></array></dict></plist>"
        //xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist version=\"1.0\"><dict><key>PayloadType</key><string>Configuration</string><key>PayloadVersion</key><integer>1</integer><key>PayloadIdentifier</key><string>net.azurewebsites.mobileconfig</string><key>PayloadUUID</key><string>f9dbd18b-90ff-58c1-8605-5abae9c50691</string><key>PayloadDisplayName</key><string>iOS構成プロファイル</string><key>PayloadDescription</key><string>mobileconfig.azurewebsites.netにて生成された構成プロファイルです。</string><key>PayloadContent</key><array><dict><key>PayloadType</key><string>com.apple.cellular</string><key>PayloadVersion</key><integer>1</integer><key>PayloadIdentifier</key><string>net.azurewebsites.mobileconfig.cellular</string><key>PayloadUUID</key><string>4be0643f-1d98-573b-97cd-ca98a65347dd</string><key>PayloadDisplayName</key><string>testのCellularペイロード</string><key>PayloadDescription</key><string>APNペイロードがインストール済みであれば、このペイロードはインストールできません。</string><key>AttachAPN</key><dict><key>Name</key><string>test</string><key>AuthenticationType</key><string>CHAP</string></dict><key>APNs</key><array><dict><key>Name</key><string>test</string><key>AuthenticationType</key><string>CHAP</string></dict></array></dict></array></dict></plist>"
        
        // build the path where you're going to save the HTML
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = documentsPath + "/" + "profile.mobileconfig"
        
        // save the NSString that contains the HTML to a file
        try! xml.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        
        startCocoaHTTPServer()
        
        let fileUrl = "http://localhost:8080" + "/profile.mobileconfig"
        UIApplication.sharedApplication().openURL(NSURL(string: fileUrl)!)
    }
    
    func startCocoaHTTPServer() {
        cocoaHTTPServer.setType("_http._tcp.")
        cocoaHTTPServer.setPort(8080)
        
        cocoaHTTPServer.setDocumentRoot(NSHomeDirectory() + "/Documents/")
        do {
            try cocoaHTTPServer.start()
        } catch  _ as NSError{
            //(・A・)!!
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Action
    @IBAction func tapSave(sender: AnyObject) {
        myUtilHandleRLMObject.prepareApnData()
        myUtilHandleRLMObject.saveApnDataObj()
        
        self.dismissViewControllerAnimated(true, completion: {
            self.writeMobileConfigProfile()
        })
    }
    
    @IBAction func tapCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
