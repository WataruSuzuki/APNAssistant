//
//  ApnListViewController.swift
//  ApnBookmarks
//
//  Created by WataruSuzuki on 2016/03/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ApnListViewController: UITableViewController,
    UISearchDisplayDelegate,
    UISearchBarDelegate,
    UIAlertViewDelegate, UIActionSheetDelegate,
    CMPopTipViewDelegate,
    DetailApnPreviewDelegate,
    EditApnViewControllerDelegate
{
    let tutorialPopView = CMPopTipView(message: NSLocalizedString("tutorial_message", comment: ""))
    let myUtilHandleRLMObject = UtilHandleRLMObject(id: UtilHandleRLMConst.CREATE_NEW_PROFILE, profileObj: ApnProfileObject(), summaryObj: ApnSummaryObject())
    
    var allApnSummaryObjs: RLMResults!
    var previewApnSummaryObj: ApnSummaryObject?
    //var searchedApnSummaryObjs: RLMResults!
    
    @IBOutlet var apnSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationItem.title = NSLocalizedString("ProfileList", comment: "")
        allApnSummaryObjs = ApnSummaryObject.allObjects()
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == .Available {
                self.registerForPreviewingWithDelegate(self, sourceView: self.tableView)
            }
        }
        self.tableView.keyboardDismissMode = .Interactive
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateApnSummaryObjs()
        self.tableView.reloadData()
    }
    
    func updateApnSummaryObjs() {
        allApnSummaryObjs = ApnSummaryObject.allObjects()
        if 0 < allApnSummaryObjs.count {
            tutorialPopView.dismissAnimated(true)
        } else {
            tutorialPopView.has3DStyle = false
            tutorialPopView.presentPointingAtBarButtonItem(self.navigationItem.rightBarButtonItem, animated: true)
        }
        if #available(iOS 9.0, *) {
            UtilShortcutLaunch().initDynamicShortcuts(UIApplication.sharedApplication())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(allApnSummaryObjs.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return loadApnListFromResults(allApnSummaryObjs, tableView: tableView, indexPath: indexPath)
    }
    
    func loadApnListFromResults(results: RLMResults, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ApnListCell", forIndexPath: indexPath)
        
        // Configure the cell...
        let apnSummary = results.objectAtIndex(UInt(indexPath.row)) as! ApnSummaryObject
        cell.textLabel?.text = apnSummary.name
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteSeletedApn(allApnSummaryObjs, indexPath: indexPath)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func deleteSeletedApn(objs: RLMResults, indexPath: NSIndexPath) {
        let apnSummary = objs.objectAtIndex(UInt(indexPath.row)) as! ApnSummaryObject
        myUtilHandleRLMObject.deleteApnSummaryObj(apnSummary)
        
        // Delete the row from the data source
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }

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
        //Do nothing. Because this VC checking update in viewDidAppear.
    }
    
    // MARK: - DetailApnPreviewDelegate
    func selectShareAction(handleObj: UtilHandleRLMObject) {
        UtilShareAction.handleShareApn(UtilCocoaHTTPServer(), obj: handleObj, sender: self)
    }
    
    func selectEditAction(newObj: ApnSummaryObject) {
        previewApnSummaryObj = newObj
        self.performSegueWithIdentifier("EditApnViewController", sender: self)
    }
    
    // MARK: - CMPopTipViewDelegate
    func popTipViewWasDismissedByUser(popTipView: CMPopTipView!) {
        //TODO
    }
    
    // MARK: - UISearchDisplayDelegate
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        loadTargetApnSummaryObjs(searchString!)
        return true
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = (text.isEmpty
            ? searchBar.text!.substringToIndex(searchBar.text!.startIndex.advancedBy(range.location))
            : searchBar.text!.substringToIndex(searchBar.text!.startIndex.advancedBy(range.location)) + text
        )
        loadTargetApnSummaryObjs(newText)
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        loadTargetApnSummaryObjs(searchText)
    }
    
    func loadTargetApnSummaryObjs(searchString: String) {
        if searchString.isEmpty {
            allApnSummaryObjs = ApnSummaryObject.allObjects()
        } else {
            allApnSummaryObjs = ApnSummaryObject.getSearchedLists(searchString)
        }
        self.tableView.reloadData()
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if 0 == buttonIndex {
            self.performSegueWithIdentifier("EditApnViewController", sender: self)
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "DetailApnViewController":
            let indexPath = self.tableView.indexPathForSelectedRow
            let destinationVC = segue.destinationViewController as! DetailApnViewController
            destinationVC.myApnSummaryObject = allApnSummaryObjs.objectAtIndex(UInt((indexPath?.row)!)) as! ApnSummaryObject
            
        case "EditApnViewController":
            if let navigationController = segue.destinationViewController as? UINavigationController {
                let controller = navigationController.viewControllers.last as! EditApnViewController
                controller.editingApnSummaryObj = previewApnSummaryObj
                controller.delegate = self
                previewApnSummaryObj = nil
            }
            
        default:
            break
        }
    }
    
    func showCautionCreateProfile() {
        let negativeMessage = NSLocalizedString("cancel", comment: "")
        let positiveMessage = NSLocalizedString("understand", comment: "")
        
        showConfirmAlertController(negativeMessage, positiveMessage: positiveMessage)
    }
    
    func showComfirmOldSheet(title: String, negativeMessage: String, positiveMessage: String) {
        let sheet = UIActionSheet()
        //sheet.tag =
        sheet.delegate = self
        sheet.title = title
        sheet.addButtonWithTitle(positiveMessage)
        sheet.addButtonWithTitle(negativeMessage)
        sheet.cancelButtonIndex = 1
        sheet.destructiveButtonIndex = 0
        
        sheet.showInView(self.view)
    }
    
    func showConfirmAlertController(negativeMessage: String, positiveMessage: String){
        let title = NSLocalizedString("caution", comment: "")
        let message = NSLocalizedString("caution_profile", comment: "")
        if #available(iOS 8.0, *) {
            let cancelAction = UIAlertAction(title: negativeMessage, style: UIAlertActionStyle.Cancel){
                action in //do nothing
            }
            let installAction = UIAlertAction(title: positiveMessage, style: UIAlertActionStyle.Destructive){
                action in self.performSegueWithIdentifier("EditApnViewController", sender: self)
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            alertController.addAction(cancelAction)
            alertController.addAction(installAction)
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            }
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            showComfirmOldSheet(title + "\n" + message, negativeMessage: negativeMessage, positiveMessage: positiveMessage)
        }
    }
    
    // MARK: - Action
    @IBAction func tapAddButton(sender: UIBarButtonItem) {
        showCautionCreateProfile()
    }
}
