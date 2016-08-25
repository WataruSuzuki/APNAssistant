//
//  DetailApnViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/20.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class DetailApnViewController: UITableViewController,
    UIAlertViewDelegate, UIActionSheetDelegate,
    EditApnViewControllerDelegate
{
    let myUtilCocoaHTTPServer = UtilCocoaHTTPServer()
    
    var myUtilHandleRLMObject: UtilHandleRLMObject!
    var myApnSummaryObject: ApnSummaryObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTargetSummaryObj()
        let menuButton = UIBarButtonItem(title: NSLocalizedString("menu", comment: ""), style: .Bordered, target: self, action: #selector(DetailApnViewController.showMenuSheet))
        self.navigationItem.rightBarButtonItem = menuButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ApnSummaryObject.ApnInfoColumn.MAX.rawValue - 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = ApnSummaryObject.ApnInfoColumn(rawValue: section + 1)
        if sectionType == ApnSummaryObject.ApnInfoColumn.SUMMARY {
            return 0
        }
        return ApnProfileObject.KeyAPNs.maxRaw(sectionType!)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailApnCell", forIndexPath: indexPath)

        let type = ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section)!
        let column = ApnProfileObject.KeyAPNs(rawValue: indexPath.row)!
        cell.textLabel?.text = column.getTitle(type)
        switch column {
        case ApnProfileObject.KeyAPNs.PASSWORD:
            cell.detailTextLabel?.text = "*******"
            
        default:
            cell.detailTextLabel?.text = myUtilHandleRLMObject.getKeptApnProfileColumnValue(type, column: column)
        }

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

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

    // MARK: - EditApnViewControllerDelegate
    func didFinishEditApn(newObj: ApnSummaryObject) {
        myApnSummaryObject = newObj
        loadTargetSummaryObj()
        
        self.tableView.reloadData()
    }
    
    func loadTargetSummaryObj() {
        myUtilHandleRLMObject = UtilHandleRLMObject(id: myApnSummaryObject.id, profileObj: myApnSummaryObject.apnProfile, summaryObj: myApnSummaryObject)
        self.navigationItem.title = myApnSummaryObject.name
        
        myUtilHandleRLMObject.prepareKeepApnProfileColumn(myApnSummaryObject.apnProfile)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard (segue.identifier != nil) else { return }
        switch segue.identifier! {
        case "EditApnViewController":
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! EditApnViewController
            controller.editingApnSummaryObj = myApnSummaryObject
            controller.delegate = self
            
        default:
            break
        }
    }

    func showMenuSheet() {
        var menuArray = [String]()
        
        for index in Menu.setThisApnToDevice.rawValue..<Menu.MAX.rawValue {
            menuArray.append(NSLocalizedString(Menu(rawValue: index)!.toString(), comment: ""))
        }
        
        showConfirmAlertController(NSLocalizedString("menu", comment: ""), menuArray: menuArray)
    }
    
    func showComfirmOldSheet(title: String, menuArray: [String]) {
        let sheet = UIActionSheet()
        //sheet.tag =
        sheet.delegate = self
        sheet.title = title
        for message in menuArray {
            sheet.addButtonWithTitle(message)
        }
        sheet.cancelButtonIndex = menuArray.count - 1
        //sheet.destructiveButtonIndex = 0
        
        sheet.showInView(self.view)
    }
    
    func showConfirmAlertController(title: String, menuArray: [String]){
        if #available(iOS 8.0, *) {
            let setApnAction = UIAlertAction(title: menuArray[Menu.setThisApnToDevice.rawValue], style: .Default){
                action in self.handleUpdateDeviceApn()
            }
            let shareAction = UIAlertAction(title: menuArray[Menu.share.rawValue], style: .Default){
                action in self.handleShareApn()
            }
            let editAction = UIAlertAction(title: menuArray[Menu.edit.rawValue], style: .Default){
                action in self.showEditApnViewController()
            }
            let cancelAction = UIAlertAction(title: menuArray[Menu.cancel.rawValue], style: .Cancel, handler: nil)
            
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .ActionSheet)
            alertController.addAction(cancelAction)
            alertController.addAction(setApnAction)
            alertController.addAction(shareAction)
            alertController.addAction(editAction)
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                alertController.popoverPresentationController?.sourceView = self.view;
                alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            }
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            showComfirmOldSheet(title, menuArray: menuArray)
        }
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch Menu(rawValue: buttonIndex)! {
        case .setThisApnToDevice:
            self.handleUpdateDeviceApn()
            
        case .share:
            self.handleShareApn()
            
        case .edit:
            self.showEditApnViewController()
            
        default:
            break
        }
    }
    
    func showEditApnViewController() {
        self.performSegueWithIdentifier("EditApnViewController", sender: self)
    }
    
    func handleUpdateDeviceApn(){
        let url = self.myUtilCocoaHTTPServer.prepareOpenSettingAppToSetProfile(self.myUtilHandleRLMObject)
        UIApplication.sharedApplication().openURL(url)
    }
    
    func handleShareApn(){
        let configProfileUrl = myUtilCocoaHTTPServer.getProfileUrl(myUtilHandleRLMObject)
        
        let contoller = UIActivityViewController(activityItems: [configProfileUrl], applicationActivities: nil)
        contoller.excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypePrint
        ]

        self.presentViewController(contoller, animated: true, completion: nil)
    }
    
    enum Menu: Int {
        case setThisApnToDevice = 0,
        share,
        edit,
        cancel,
        MAX
        
        func toString() -> String {
            return String(self)
        }
    }
}
