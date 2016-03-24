//
//  EditApnViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class EditApnViewController: UITableViewController,
    TextFieldCellDelegate,
    UISwitchCellDelegate
{

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
    func changeMyUiSwitch(sender: UISwitch) {
        //TODO
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ConfigProfileUtils.ApnType.MAX.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = ConfigProfileUtils.ApnType(rawValue: section)
        switch sectionType! {
        case .APNS:
            return ConfigProfileUtils.KeyAPNs.MAX.rawValue
        case .ATTACH_APN:
            return ConfigProfileUtils.KeyAttachAPN.MAX.rawValue + 1
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionType = ConfigProfileUtils.ApnType(rawValue: indexPath.section)
        
        switch sectionType! {
        case .APNS:
            let newTextFieldCell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
            let rowApns = ConfigProfileUtils.KeyAPNs(rawValue: indexPath.row)
            newTextFieldCell.myUILabel?.text = rowApns?.getTitle()
            
            return newTextFieldCell
            
        case .ATTACH_APN:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("UISwitchCell") as! UISwitchCell
                cell.myUILabel?.text = NSLocalizedString("setAttachApnManual", comment: "")
                return cell
                
            } else {
                let newTextFieldCell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                let rowAttachApn = ConfigProfileUtils.KeyAttachAPN(rawValue: indexPath.row-1)
                newTextFieldCell.myUILabel?.text = rowAttachApn?.getTitle()
                
                return newTextFieldCell
            }
            
        default:
            break
        }

        return tableView.dequeueReusableCellWithIdentifier("EditApnViewCell", forIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionType = ConfigProfileUtils.ApnType(rawValue: indexPath.section)
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
