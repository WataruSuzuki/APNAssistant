//
//  DownloadProfileListViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/05.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class DownloadProfileListViewController: UITableViewController,
    UIAlertViewDelegate, UIActionSheetDelegate,
    NSURLSessionDownloadDelegate
{
    let myUtilDownloadProfileList = UtilDownloadProfileList()
    var selectedIndexPath = NSIndexPath()
    var updateSectionCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        startJsonFileDownload()
        
        self.navigationItem.title = NSLocalizedString("DownloadList", comment: "")
        let jsonRefreshControl = UIRefreshControl()
        jsonRefreshControl.addTarget(self, action: #selector(DownloadProfileListViewController.startJsonFileDownload), forControlEvents: .ValueChanged)
        self.refreshControl = jsonRefreshControl
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return myUtilDownloadProfileList.customProfileList.count + myUtilDownloadProfileList.publicProfileList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let offset = myUtilDownloadProfileList.getOffsetSection(section)
        if offset.0 {
            return myUtilDownloadProfileList.customProfileList[offset.1].count
        } else {
            return myUtilDownloadProfileList.publicProfileList[offset.1].count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DownloadProfileListCell", forIndexPath: indexPath)

        let items: NSArray
        // Configure the cell...
        let offset = myUtilDownloadProfileList.getOffsetSection(indexPath.section)
        if offset.0 {
            items = myUtilDownloadProfileList.customProfileList[offset.1] as NSArray
        } else {
            items = myUtilDownloadProfileList.publicProfileList[offset.1] as NSArray
        }
        cell.textLabel?.text = items[indexPath.row].objectForKey(DownloadProfiles.profileName) as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let offset = myUtilDownloadProfileList.getOffsetSection(section)
        if (offset.0 && 0 == myUtilDownloadProfileList.customProfileList[offset.1].count)
            || (!offset.0 && myUtilDownloadProfileList.publicProfileList[offset.1].count == 0)
        {
            return ""
        }
        let jsonName = DownloadProfiles.json(rawValue: offset.1)!
        return NSLocalizedString(jsonName.toString(), comment: "") + "(" + NSLocalizedString((offset.0 ? "custom": "public"), comment: "") + ")"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        showConfirmInstallProfile()
    }
    
    func showConfirmInstallProfile() {
        let negativeMessage = NSLocalizedString("cancel", comment: "")
        let positiveMessage = NSLocalizedString("yes_update", comment: "")
        
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
                action in self.installProfileFromNetwork()
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            alertController.addAction(cancelAction)
            alertController.addAction(installAction)
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                alertController.popoverPresentationController?.sourceView = self.view;
                alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            }
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            showComfirmOldSheet(title + "\n" + message, negativeMessage: negativeMessage, positiveMessage: positiveMessage)
        }
    }
    
    func installProfileFromNetwork() {
        let offset = myUtilDownloadProfileList.getOffsetSection(selectedIndexPath.section)
        let profileData = (offset.0
            ? myUtilDownloadProfileList.customProfileList[offset.1]
            : myUtilDownloadProfileList.publicProfileList[offset.1]
        )
        let url = profileData[selectedIndexPath.row].objectForKey(DownloadProfiles.profileUrl) as! String
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
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

    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if 0 == buttonIndex {
            self.installProfileFromNetwork()
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
    
    // MARK: - NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        myUtilDownloadProfileList.moveJSONFilesFromURLSession(downloadTask, location: location)
        
        let section = myUtilDownloadProfileList.getUpdateIndexSection(downloadTask)
        if section != DownloadProfiles.ERROR_INDEX {
            self.tableView.reloadData()
            //self.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
            updateSectionCount += 1
        }
        
        if updateSectionCount >= self.tableView.numberOfSections {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //TODO
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("progress = \(Float((bytesWritten / totalBytesWritten) * 100))%")
        //TODO
    }
    
    func startJsonFileDownload() {
        myUtilDownloadProfileList.startJsonFileDownload(self)
    }
}
