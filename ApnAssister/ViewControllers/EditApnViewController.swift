//
//  EditApnViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

protocol EditApnViewControllerDelegate {
    func didFinishEditApn(newObj: ApnSummaryObject)
}

class EditApnViewController: UITableViewController,
    UIAlertViewDelegate, UIActionSheetDelegate
{
    var myUtilHandleRLMObject: UtilHandleRLMObject!
    let myUtilCocoaHTTPServer = UtilCocoaHTTPServer()
    
    var editingApnSummaryObj: ApnSummaryObject?
    var isCompFirstRespond = false
    var isSetDataApnManually = true
    
    var delegate: EditApnViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("edit_apn", comment: "")
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        registerCustomCell("TextFieldCell")
        registerCustomCell("UISwitchCell")
        
        if nil != editingApnSummaryObj {
            myUtilHandleRLMObject = UtilHandleRLMObject(id: editingApnSummaryObj!.id, profileObj: editingApnSummaryObj!.apnProfile, summaryObj: editingApnSummaryObj!)
            myUtilHandleRLMObject.prepareKeepApnProfileColumn(editingApnSummaryObj!.apnProfile)
        } else {
            myUtilHandleRLMObject = UtilHandleRLMObject(id: UtilHandleRLMConst.CREATE_NEW_PROFILE, profileObj: ApnProfileObject(), summaryObj: ApnSummaryObject())
        }
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
        return ApnSummaryObject.ApnInfoColumn.MAX.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = ApnSummaryObject.ApnInfoColumn(rawValue: section)
        switch sectionType! {
        case .ATTACH_APN:
            //No Proxy Settings
            return ApnProfileObject.KeyAPNs.maxRaw(sectionType!)
            
        case .APNS:
            if isSetDataApnManually {
                return ApnProfileObject.KeyAPNs.maxRaw(sectionType!) + 1
            } else {
                return 1
            }
            
        case .SUMMARY:
            return ApnSummaryObject.ApnSummaryColumn.MAX.rawValue
            
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section)! {
        case .APNS:
            if indexPath.row == 0 {
                return loadSwitchCell(tableView, cellForRowAtIndexPath: indexPath)
            }
            
        case .SUMMARY:
            if indexPath.row == ApnSummaryObject.ApnSummaryColumn.DATATYPE.rawValue {
                return loadSwitchCell(tableView, cellForRowAtIndexPath: indexPath)
            } else {
                return loadSummaryApnProfileCell(tableView, cellForRowAtIndexPath: indexPath)
            }
            
        case .ATTACH_APN: fallthrough
        default: break
        }

        return loadTextFieldCell(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func loadSummaryApnProfileCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TextFieldCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell", forIndexPath: indexPath) as! TextFieldCell
        cell.myUILabel.text = ""
        cell.myUITextField?.placeholder = NSLocalizedString("nameOfThisApnProfile", comment: "")
        cell.myUITextField.text = myUtilHandleRLMObject.apnSummaryObj.name
        
        if !isCompFirstRespond && indexPath.section == 0 && indexPath.row == 0 {
            cell.myUITextField.becomeFirstResponder()
            isCompFirstRespond = true
        }
        
        cell.shouldChangeCharactersInRange = {(textField, range, string) in
            self.myUtilHandleRLMObject.apnSummaryObj.name += string
            return true
        }
        
        return cell
    }
    
    func loadSwitchCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UISwitchCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UISwitchCell", forIndexPath: indexPath) as! UISwitchCell
        switch ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section)! {
        case .APNS:
            cell.myUILabel?.text = NSLocalizedString("setAttachApnManual", comment: "")
            cell.switchValueChanged = {(switchOn) in
                self.isSetDataApnManually = switchOn
                UIView.animateWithDuration(0.4, animations: {
                    self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
                })
            }
            cell.myUISwitch.on = isSetDataApnManually
            
        case .SUMMARY:
            cell.myUILabel?.text = NSLocalizedString("isThisFavoriteOne", comment: "")
            cell.switchValueChanged = {(switchOn) in
                self.myUtilHandleRLMObject.apnSummaryObj.dataType = (switchOn ? ApnSummaryObject.DataTypes.FAVORITE.rawValue : ApnSummaryObject.DataTypes.NORMAL.rawValue)
            }
            cell.myUISwitch.on = (myUtilHandleRLMObject.apnSummaryObj.dataType == ApnSummaryObject.DataTypes.FAVORITE.rawValue ? true : false)
            
        default: break
        }
        return cell
    }
    
    func loadTextFieldCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TextFieldCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell", forIndexPath: indexPath) as! TextFieldCell
        
        let type = ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section)!
        let column = ApnProfileObject.KeyAPNs(rawValue: (type == .APNS ? indexPath.row - 1 : indexPath.row))!
        cell.myUILabel?.text = column.getTitle(type)
        cell.myUITextField.text = myUtilHandleRLMObject.getKeptApnProfileColumnValue(type, column: column)
        
        cell.didBeginEditing = {(textField) in
            //do nothing
        }
        cell.didEndEditing = {(textField) in
            //do nothing
        }
        cell.shouldChangeCharactersInRange = {(textField, range, string) in
            let newText = (string.isEmpty
                ? textField.text!.substringToIndex(textField.text!.startIndex.advancedBy(range.location))
                : textField.text! + string
            )
            self.myUtilHandleRLMObject.keepApnProfileColumnValue(type, column: column, newText: newText)
            return true
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionType = ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section)
        switch sectionType! {
        case .APNS:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("UISwitchCell") as! UISwitchCell
                return cell.frame.height
            }
            fallthrough
        case .ATTACH_APN:
            let newTextFieldCell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
            return newTextFieldCell.frame.height
            
        default:
            return tableView.rowHeight
        }
    }
    
    func handleUpdateDeviceApn(isUpdateNow: Bool){
        self.delegate.didFinishEditApn(myUtilHandleRLMObject.apnSummaryObj)
        self.dismissViewControllerAnimated(true) { 
            if isUpdateNow {
                self.myUtilCocoaHTTPServer.writeMobileConfigProfile(self.myUtilHandleRLMObject)
            }
        }
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
                action in self.handleUpdateDeviceApn(false)
            }
            let deleteAction = UIAlertAction(title: positiveMessage, style: UIAlertActionStyle.Default){
                action in self.handleUpdateDeviceApn(true)
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
        self.handleUpdateDeviceApn(0 == buttonIndex ? true : false)
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
        myUtilHandleRLMObject.prepareApnData(isSetDataApnManually)
        myUtilHandleRLMObject.saveApnDataObj()
        
        showConfirmUpdatingDeviceApn()
    }
    
    @IBAction func tapCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
