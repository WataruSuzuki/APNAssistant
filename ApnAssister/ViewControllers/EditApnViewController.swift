//
//  EditApnViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class EditApnViewController: UITableViewController,
    UIAlertViewDelegate, UIActionSheetDelegate
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
        let payloadDisplayName = "APNS Assister profile"
        let bundleID = NSBundle.mainBundle().bundleIdentifier!
        let UUID_forIdentifier = "f9dbd18b-90ff-58c1-8605-5abae9c50691"
        let UUID_forDescription = "4be0643f-1d98-573b-97cd-ca98a65347dd"
        
        // build the Configuration Profile
        var profileXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist version=\"1.0\"><dict><key>PayloadContent</key><array><dict>"
        
        //APNs
        profileXml += "<key>APNs</key><array><dict><key>AuthenticationType</key><string>CHAP</string>"
        profileXml += "<key>Name</key><string>" + myUtilHandleRLMObject.apnProfileObj.apnsName + "</string>"
        profileXml += "<key>Password</key><string>" + myUtilHandleRLMObject.apnProfileObj.apnsPassword + "</string>"
        
        if !myUtilHandleRLMObject.apnProfileObj.apnsProxyServer.isEmpty
            && !myUtilHandleRLMObject.apnProfileObj.apnsProxyServerPort.isEmpty {
            profileXml += "<key>ProxyPort</key><integer>" + myUtilHandleRLMObject.apnProfileObj.apnsProxyServerPort + "</integer>"
            profileXml += "<key>ProxyServer</key><string>" + myUtilHandleRLMObject.apnProfileObj.apnsProxyServer + "</string>"
        }
        profileXml += "<key>Username</key><string>" + myUtilHandleRLMObject.apnProfileObj.apnsUserName + "</string></dict></array>"
        
        //AttachAPN
        profileXml += "<key>AttachAPN</key><dict><key>AuthenticationType</key><string>CHAP</string>"
        profileXml += "<key>Name</key><string>" + myUtilHandleRLMObject.apnProfileObj.attachApnName + "</string>"
        profileXml += "<key>Password</key><string>" + myUtilHandleRLMObject.apnProfileObj.attachApnPassword + "</string>"
        profileXml += "<key>Username</key><string>" + myUtilHandleRLMObject.apnProfileObj.attachApnUserName + "</string></dict>"
        
        //PayloadDescription
        profileXml += "<key>PayloadDescription</key><string>" + NSLocalizedString("config_mobile_network", comment: "") + "</string>"
        profileXml += "<key>PayloadDisplayName</key><string>" + NSLocalizedString("mobile_network", comment: "") + "</string>"
        profileXml += "<key>PayloadIdentifier</key><string>" + bundleID + "</string>"
        profileXml += "<key>PayloadType</key><string>com.apple.cellular</string>"
        profileXml += "<key>PayloadUUID</key><string>" + UUID_forDescription + "</string>"
        profileXml += "<key>PayloadVersion</key><real>1</real></dict></array>"
        
        //PayloadDisplayName
        profileXml += "<key>PayloadDisplayName</key><string>" + payloadDisplayName + "</string>"
        profileXml += "<key>PayloadIdentifier</key><string>" + bundleID + "</string>"
        profileXml += "<key>PayloadRemovalDisallowed</key><false/>"
        profileXml += "<key>PayloadType</key><string>Configuration</string>"
        profileXml += "<key>PayloadUUID</key><string>" + UUID_forIdentifier + "</string>"
        profileXml += "<key>PayloadVersion</key><integer>1</integer></dict></plist>"
        
        // build the path where you're going to save the HTML
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = documentsPath + "/" + "profile.mobileconfig"
        print(filePath)
        
        // save the NSString that contains the HTML to a file
        //try! profileXml.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        try! profileXml.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        
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
    
    func handleNotThisTime(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleUpdateDeviceApn(){
        self.writeMobileConfigProfile()
    }
    
    func showConfirmUpdatingDeviceApn() {
        let negativeMessage = NSLocalizedString("not_this_time", comment: "")
        let positiveMessage = NSLocalizedString("yes_update", comment: "")
        
        showConfirmAlertController(negativeMessage, positiveMessage: positiveMessage)
    }
    
    func showComfirmOldSheet(negativeMessage: String, positiveMessage: String) {
        let sheet = UIActionSheet()
        //sheet.tag =
        sheet.delegate = self
        sheet.title = positiveMessage
        sheet.addButtonWithTitle(positiveMessage)
        sheet.addButtonWithTitle(negativeMessage)
        sheet.cancelButtonIndex = 1
        sheet.destructiveButtonIndex = 0
        
        sheet.showInView(self.view)
    }
    
    func showConfirmAlertController(negativeMessage: String, positiveMessage: String){
        if #available(iOS 8.0, *) {
            let cancelAction = UIAlertAction(title: negativeMessage, style: UIAlertActionStyle.Cancel){
                action in self.handleNotThisTime()
            }
            let deleteAction = UIAlertAction(title: positiveMessage, style: UIAlertActionStyle.Default){
                action in self.handleUpdateDeviceApn()
            }
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                alertController.popoverPresentationController?.sourceView = self.view;
                alertController.popoverPresentationController?.barButtonItem
            }
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            showComfirmOldSheet(negativeMessage, positiveMessage: positiveMessage)
        }
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            self.handleNotThisTime()
            break
            
        case 0:
            self.handleUpdateDeviceApn()
            break
            
        default:
            break
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
        
        showConfirmUpdatingDeviceApn()
    }
    
    @IBAction func tapCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
