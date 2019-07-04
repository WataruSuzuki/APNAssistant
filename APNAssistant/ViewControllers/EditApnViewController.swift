//
//  EditApnViewController.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/03/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit
import Realm

protocol EditApnViewControllerDelegate {
    func didFinishEditApn(_ newObj: ApnSummaryObject)
}

class EditApnViewController: UITableViewController//,
{
    let myUtilCocoaHTTPServer = ConfigProfileService()
    let appStatus = UtilAppStatus()
    
    var myUtilHandleRLMObject: UtilHandleRLMObject!
    var editingApnSummaryObj: ApnSummaryObject?
    var isCompFirstRespond = false
    var isSetDataApnManually = false
    
    var delegate: EditApnViewControllerDelegate!
    var pickerExpandedStatus = [
        ApnProfileObject.KeyAPNs.allowed_protocol_mask: false,
        ApnProfileObject.KeyAPNs.allowed_protocol_mask_in_roaming: false,
        ApnProfileObject.KeyAPNs.allowed_protocol_mask_in_domestic_roaming: false
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("edit_apn", comment: "")
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.keyboardDismissMode = .interactive

        registerCustomCell("TextFieldCell")
        registerCustomCell("UISwitchCell")
        registerCustomCell("SegmentedCtrlCell")
        registerCustomCell("PickerCell")

        if nil != editingApnSummaryObj {
            myUtilHandleRLMObject = UtilHandleRLMObject(id: editingApnSummaryObj!.id, profileObj: editingApnSummaryObj!.apnProfile!, summaryObj: editingApnSummaryObj!)
            myUtilHandleRLMObject.prepareKeepApnProfileColumn(editingApnSummaryObj!.apnProfile!)
        } else {
            myUtilHandleRLMObject = UtilHandleRLMObject(id: UtilHandleRLMConst.CREATE_NEW_PROFILE, profileObj: ApnProfileObject(), summaryObj: ApnSummaryObject())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerCustomCell(_ nibIdentifier: String) {
        let nib = UINib(nibName: nibIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: nibIdentifier)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ApnSummaryObject.ApnInfoColumn.max.rawValue
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = ApnSummaryObject.ApnInfoColumn(rawValue: section)
        switch sectionType! {
        case .attach_APN:
            //No Proxy Settings
            return ApnProfileObject.KeyAPNs.maxRaw(sectionType!)
            
        case .apns:
            if isSetDataApnManually {
                return ApnProfileObject.KeyAPNs.maxRaw(sectionType!) + 1
            } else {
                return 1
            }
            
        case .summary:
            return ApnSummaryObject.ApnSummaryColumn.max.rawValue
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var row = indexPath.row
        switch ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section)! {
        case .apns:
            if row == 0 {
                return loadSwitchCell(tableView, cellForRowAtIndexPath: indexPath)
            } else {
                row -= 1
            }
            
        case .summary:
            if row == ApnSummaryObject.ApnSummaryColumn.datatype.rawValue {
                return loadSwitchCell(tableView, cellForRowAtIndexPath: indexPath)
            } else {
                return loadSummaryApnProfileCell(tableView, cellForRowAtIndexPath: indexPath)
            }
            
        case .attach_APN: fallthrough
        default: break
        }
        
        switch row {
        case ApnProfileObject.KeyAPNs.authentication_type.rawValue:
            return loadSegmentedCtrlCell(tableView, cellForRowAtIndexPath: indexPath)
            
        case ApnProfileObject.KeyAPNs.allowed_protocol_mask.rawValue: fallthrough
        case ApnProfileObject.KeyAPNs.allowed_protocol_mask_in_roaming.rawValue: fallthrough
        case ApnProfileObject.KeyAPNs.allowed_protocol_mask_in_domestic_roaming.rawValue:
            return loadPickerCell(tableView, cellForRowAtIndexPath: indexPath)
            
        default:
            return loadTextFieldCell(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    func getTypeAndColumn(_ indexPath: IndexPath) -> (ApnSummaryObject.ApnInfoColumn, ApnProfileObject.KeyAPNs) {
        let type = ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section)!
        let column = ApnProfileObject.KeyAPNs(rawValue: (type == .apns ? indexPath.row - 1 : indexPath.row))!
        
        return (type, column)
    }
    
    func loadSegmentedCtrlCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> SegmentedCtrlCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedCtrlCell", for: indexPath) as! SegmentedCtrlCell
        let typeAndColumn = getTypeAndColumn(indexPath)
        cell.myUILabel?.text = typeAndColumn.1.getTitle(typeAndColumn.0)
        cell.didChangeValue = { (segmentedCtrl) in
            self.myUtilHandleRLMObject.keepApnProfileColumnValue(typeAndColumn.0, column: typeAndColumn.1, newText: SegmentedCtrlCell.SegmentAuthType(rawValue: segmentedCtrl.selectedSegmentIndex)!.toString())
        }
        cell.myUISegmentedControl.selectedSegmentIndex = SegmentedCtrlCell.SegmentAuthType(type: myUtilHandleRLMObject.getKeptApnProfileColumnValue(typeAndColumn.0, column: typeAndColumn.1)).rawValue
        
        return cell
    }
    
    func loadSummaryApnProfileCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> TextFieldCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
        cell.myUILabel.text = ""
        cell.myUITextField?.placeholder = NSLocalizedString("nameOfThisApnProfile", comment: "")
        cell.myUITextField.text = myUtilHandleRLMObject.profileName
        cell.myUITextField.keyboardType = .default
        cell.myUITextField.isSecureTextEntry = false
        
        if !isCompFirstRespond && indexPath.section == 0 && indexPath.row == 0 {
            cell.myUITextField.becomeFirstResponder()
            isCompFirstRespond = true
        }
        
        cell.didEndEditing = {(textField) in
            self.myUtilHandleRLMObject.profileName = textField.text!
        }
        cell.shouldChangeCharactersInRange = {(textField, range, string) in
            let newText = cell.getNewChangeCharactersInRange(textField, range: range, string: string)
            self.myUtilHandleRLMObject.profileName = newText
            return true
        }
        
        return cell
    }
    
    func loadSwitchCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UISwitchCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UISwitchCell", for: indexPath) as! UISwitchCell
        switch ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section)! {
        case .apns:
            cell.myUILabel?.text = NSLocalizedString("setDataApnManual", comment: "")
            cell.switchValueChanged = {(switchOn) in
                self.isSetDataApnManually = switchOn
                UIView.animate(withDuration: 0.4, animations: {
                    self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
                })
            }
            cell.myUISwitch.isOn = isSetDataApnManually
            
        case .summary:
            cell.myUILabel?.text = NSLocalizedString("isThisFavoriteOne", comment: "")
            cell.switchValueChanged = {(switchOn) in
                self.myUtilHandleRLMObject.summaryDataType = (switchOn ? ApnSummaryObject.DataTypes.favorite : ApnSummaryObject.DataTypes.normal)
            }
            cell.myUISwitch.isOn = (myUtilHandleRLMObject.summaryDataType == ApnSummaryObject.DataTypes.favorite ? true : false)
            
        default: break
        }
        return cell
    }
    
    func loadPickerCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> PickerCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerCell
        
        let typeAndColumn = getTypeAndColumn(indexPath)
        cell.myTitleLabel?.text = typeAndColumn.1.getTitle(typeAndColumn.0)
        cell.isExpanded = pickerExpandedStatus[typeAndColumn.1]!
        let maskType = myUtilHandleRLMObject.getKeptApnProfileColumnValue(typeAndColumn.0, column: typeAndColumn.1)
        cell.myDetailField.placeholder = AllowedProtocolMask(rawValue: (maskType.isEmpty ? 0 : Int(maskType)!))?.toString()
        cell.didSelectRow = {(mask) in
            self.myUtilHandleRLMObject.keepApnProfileColumnValue(typeAndColumn.0, column: typeAndColumn.1, newText:(mask == AllowedProtocolMask.nothing ? "" : String(mask.rawValue)))
        }

        return cell
    }
    
    func loadTextFieldCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> TextFieldCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
        
        let typeAndColumn = getTypeAndColumn(indexPath)
        cell.myUILabel?.text = typeAndColumn.1.getTitle(typeAndColumn.0)
        cell.myUITextField.text = myUtilHandleRLMObject.getKeptApnProfileColumnValue(typeAndColumn.0, column: typeAndColumn.1)
        cell.myUITextField.placeholder = NSLocalizedString("no_settings", comment: "")
        
        switch typeAndColumn.1 {
        case ApnProfileObject.KeyAPNs.proxy_server_port:
            cell.myUITextField.keyboardType = .numberPad
            cell.myUITextField.isSecureTextEntry = false
            
        case ApnProfileObject.KeyAPNs.password:
            cell.myUITextField.keyboardType = .default
            cell.myUITextField.isSecureTextEntry = true
            
        default:
            cell.myUITextField.keyboardType = .default
            cell.myUITextField.isSecureTextEntry = false
        }
        
        cell.didBeginEditing = {(textField) in
            //do nothing
        }
        cell.didEndEditing = {(textField) in
            self.myUtilHandleRLMObject.keepApnProfileColumnValue(typeAndColumn.0, column: typeAndColumn.1, newText: textField.text!)
        }
        cell.shouldChangeCharactersInRange = {(textField, range, string) in
            let newText = cell.getNewChangeCharactersInRange(textField, range: range, string: string)
            self.myUtilHandleRLMObject.keepApnProfileColumnValue(typeAndColumn.0, column: typeAndColumn.1, newText: newText)
            return true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionType = ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section) {
            let row = (sectionType == .apns
                ? indexPath.row - 1
                : indexPath.row
            )

            switch sectionType {
            case .apns:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UISwitchCell") as! UISwitchCell
                    return cell.frame.height
                }
                fallthrough
                
            case .attach_APN:
                switch row {
                case ApnProfileObject.KeyAPNs.authentication_type.rawValue:
                    let newSegmentedCtrlCell = tableView.dequeueReusableCell(withIdentifier: "SegmentedCtrlCell") as! SegmentedCtrlCell
                    return newSegmentedCtrlCell.frame.height

                case ApnProfileObject.KeyAPNs.allowed_protocol_mask.rawValue: fallthrough
                case ApnProfileObject.KeyAPNs.allowed_protocol_mask_in_roaming.rawValue: fallthrough
                case ApnProfileObject.KeyAPNs.allowed_protocol_mask_in_domestic_roaming.rawValue:
                    let newPickerCell = tableView.dequeueReusableCell(withIdentifier: "PickerCell") as! PickerCell
                    if pickerExpandedStatus[ApnProfileObject.KeyAPNs(rawValue: row)!]! {
                        return newPickerCell.frame.height
                    }
                    fallthrough

                default:
                    let newTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
                    return newTextFieldCell.frame.height
                }

            default:
                break
            }
        }
        return tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = (ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section)! == .apns
            ? indexPath.row - 1
            : indexPath.row
            )
        
        switch row {
        case ApnProfileObject.KeyAPNs.allowed_protocol_mask.rawValue: fallthrough
        case ApnProfileObject.KeyAPNs.allowed_protocol_mask_in_roaming.rawValue: fallthrough
        case ApnProfileObject.KeyAPNs.allowed_protocol_mask_in_domestic_roaming.rawValue:
            pickerExpandedStatus[ApnProfileObject.KeyAPNs(rawValue: row)!] = !pickerExpandedStatus[ApnProfileObject.KeyAPNs(rawValue: row)!]!
            UIView.animate(withDuration: 0.4, animations: {
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            })

        default:
            break
        }
    }
    
    func handleUpdateDeviceApn(_ isUpdateNow: Bool){
        self.delegate.didFinishEditApn(myUtilHandleRLMObject.apnSummaryObj)
        self.dismiss(animated: true) { 
            if isUpdateNow {
                if self.appStatus.isAvailableAllFunction() {
                    self.myUtilCocoaHTTPServer.updateProfile(self.myUtilHandleRLMObject)
                } else {
                    self.appStatus.showStatuLimitByApple(self)
                }
            }
        }
    }
    
    func showConfirmUpdatingDeviceApn() {
        let negativeMessage = NSLocalizedString("not_this_time", comment: "")
        let positiveMessage = NSLocalizedString("yes_update", comment: "")
        let sheetTitle = NSLocalizedString("is_update_now", comment: "")
        
        showSheetController(sheetTitle, negativeMessage: negativeMessage, positiveMessage: positiveMessage)
    }
    
    func showSheetController(_ title: String, negativeMessage: String, positiveMessage: String){
        let cancelAction = UIAlertAction(title: negativeMessage, style: UIAlertActionStyle.cancel){
            action in self.handleUpdateDeviceApn(false)
        }
        let updateAction = UIAlertAction(title: positiveMessage, style: UIAlertActionStyle.destructive){
            action in self.handleUpdateDeviceApn(true)
        }
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(cancelAction)
        alertController.addAction(updateAction)
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        }
        
        present(alertController, animated: true, completion: nil)
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
    @IBAction func tapSave(_ sender: Any) {
        let realm = RLMRealm.default()
        myUtilHandleRLMObject.saveUpdateApnDataObj(realm, isSetDataApnManually: isSetDataApnManually)
        
        if appStatus.isShowImportantMenu() {
            showConfirmUpdatingDeviceApn()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
