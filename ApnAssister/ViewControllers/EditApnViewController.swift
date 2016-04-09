//
//  EditApnViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class EditApnViewController: UITableViewController//,
    //UISwitchCellDelegate,
    //TextFieldCellDelegate
{
    var isSetDataApnManually = true
    let apnProfileObj = ApnProfileObject()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    /*
    // MARK: - TextFieldCellDelegate
    func textFieldCellDidEndEditing(sender: UITextField) {
        //TODO
    }
    
    func textFieldCellDidBeginEditing(sender: UITextField) {
        //TODO
    }
    
    func textFieldCellShouldClear(sender: UITextField) -> Bool {
        return false//TODO
    }
    
    func textFieldCellShouldReturn(sender: UITextField) -> Bool {
        return false//TODO
    }
    
    func textFieldCellShouldEndEditing(sender: UITextField) -> Bool {
        return false//TODO
    }
    
    func textFieldCellShouldBeginEditing(sender: UITextField) -> Bool {
        return false//TODO
    }
    
    func textFieldCellShouldChangeCharactersInRange(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false//TODO
    }
    
    // MARK: - UISwitchCellDelegate
    func changeMyUiSwitch(sender: UISwitch, indexPath: NSIndexPath) {
        //TODO
        print(indexPath.debugDescription)
    }
    */
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ApnProfileObject.ApnType.MAX.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = ApnProfileObject.ApnType(rawValue: section)
        switch sectionType! {
        case .APNS:
            return ApnProfileObject.KeyAPNs.MAX.rawValue
        case .ATTACH_APN:
            if isSetDataApnManually {
                return ApnProfileObject.KeyAPNs.MAX.rawValue + 1
            } else {
                return 1
            }
            
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionType = ApnProfileObject.ApnType(rawValue: indexPath.section)
        
        switch sectionType! {
        case .APNS:
            return loadTextFieldCell(tableView, cellForRowAtIndexPath: indexPath)
            
        case .ATTACH_APN:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("UISwitchCell") as! UISwitchCell
                //cell.delegate = self
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
        
        if indexPath.section == ApnProfileObject.ApnType.APNS.rawValue {
            let rowApns = ApnProfileObject.KeyAPNs(rawValue: indexPath.row)
            cell.myUILabel?.text = rowApns?.getTitle(.APNS)
        } else {
            let rowAttachApn = ApnProfileObject.KeyAPNs(rawValue: indexPath.row - 1)
            cell.myUILabel?.text = rowAttachApn?.getTitle(.ATTACH_APN)
        }
        
        //newTextFieldCell.delegate = self
        cell.didBeginEditing = {(textField) in
            //TODO
        }
        cell.didEndEditing = {(textField) in
            print(indexPath)
        }
        cell.shouldChangeCharactersInRange = {(textField, range, string) in
            self.updateApnProfileObj(cell, textfield: textField, range: range, string: string, indexPath: indexPath)
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
    
    func updateApnProfileObj(cell:TextFieldCell, textfield:UITextField, range:NSRange, string:String, indexPath:NSIndexPath) {
        switch ApnProfileObject.ApnType(rawValue: indexPath.section)! {
            
        case .APNS:
            let keyApns = ApnProfileObject.KeyAPNs(rawValue: indexPath.row)
            
        case .ATTACH_APN:
            let keyAttachApn = ApnProfileObject.KeyAPNs(rawValue: indexPath.row)
            
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
        UtilHandleRLMObject.sharedInstance.saveApnProfileObj(apnProfileObj)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
