//
//  AvailableApnListViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/05.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class AvailableApnListViewController: UITableViewController,
    UIAlertViewDelegate, UIActionSheetDelegate,
    NSURLSessionDownloadDelegate
{
    let myAvailableUpdateHelper = AvailableUpdateHelper()
    //var selectedIndexPath = NSIndexPath()
    var updateSectionCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        //ここでダウンロードを試みるとデバイスではうまく動かない(Simulatorだと動くけど)
        //startJsonFileDownload()
        
        self.navigationItem.title = NSLocalizedString("DownloadList", comment: "")
        let jsonRefreshControl = UIRefreshControl()
        jsonRefreshControl.addTarget(self, action: #selector(AvailableApnListViewController.startJsonFileDownload), forControlEvents: .ValueChanged)
        self.refreshControl = jsonRefreshControl
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        confirmUpdateAvailableList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return myAvailableUpdateHelper.customProfileList.count + myAvailableUpdateHelper.publicProfileList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let offset = myAvailableUpdateHelper.getOffsetSection(section)
        if offset.0 {
            return myAvailableUpdateHelper.customProfileList[offset.1].count
        } else {
            return myAvailableUpdateHelper.publicProfileList[offset.1].count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DownloadProfileListCell", forIndexPath: indexPath)

        let items: NSArray
        // Configure the cell...
        let offset = myAvailableUpdateHelper.getOffsetSection(indexPath.section)
        if offset.0 {
            items = myAvailableUpdateHelper.customProfileList[offset.1] as NSArray
        } else {
            items = myAvailableUpdateHelper.publicProfileList[offset.1] as NSArray
        }
        cell.textLabel?.text = items[indexPath.row].objectForKey(DownloadProfiles.profileName) as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let offset = myAvailableUpdateHelper.getOffsetSection(section)
        if (offset.0 && 0 == myAvailableUpdateHelper.customProfileList[offset.1].count)
            || (!offset.0 && myAvailableUpdateHelper.publicProfileList[offset.1].count == 0)
        {
            return ""
        }
        let jsonName = DownloadProfiles.json(rawValue: offset.1)!
        return NSLocalizedString(jsonName.toString(), comment: "") + "(" + NSLocalizedString((offset.0 ? "custom": "public"), comment: "") + ")"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //selectedIndexPath = indexPath
        installProfileFromNetwork(indexPath)
    }
    
    func confirmUpdateAvailableList() {
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
        //sheet.destructiveButtonIndex = 0
        
        sheet.showInView(self.view)
    }
    
    func showConfirmAlertController(negativeMessage: String, positiveMessage: String){
        let title = NSLocalizedString("confirm", comment: "")
        let message = NSLocalizedString("update_available_list", comment: "")
        if #available(iOS 8.0, *) {
            let cancelAction = UIAlertAction(title: negativeMessage, style: UIAlertActionStyle.Cancel){
                action in //do nothing
            }
            let installAction = UIAlertAction(title: positiveMessage, style: UIAlertActionStyle.Default){
                action in self.startJsonFileDownload()
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            alertController.addAction(cancelAction)
            alertController.addAction(installAction)
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                alertController.popoverPresentationController?.sourceView = self.view
                alertController.popoverPresentationController?.sourceRect = self.view.frame
            }
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            showComfirmOldSheet(title + "\n" + message, negativeMessage: negativeMessage, positiveMessage: positiveMessage)
        }
    }
    
    func installProfileFromNetwork(selectedIndexPath: NSIndexPath) {
        let offset = myAvailableUpdateHelper.getOffsetSection(selectedIndexPath.section)
        let profileData = (offset.0
            ? myAvailableUpdateHelper.customProfileList[offset.1]
            : myAvailableUpdateHelper.publicProfileList[offset.1]
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
            self.startJsonFileDownload()
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
        myAvailableUpdateHelper.moveJSONFilesFromURLSession(downloadTask, location: location)
        
        let section = myAvailableUpdateHelper.getUpdateIndexSection(downloadTask)
        if section != DownloadProfiles.ERROR_INDEX {
            self.tableView.reloadData()
            //self.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
        }
        updateSectionCount += 1
        
        print("updateSectionCount = \(updateSectionCount)")
        print("numberOfSections = \(self.tableView.numberOfSections)")
        if updateSectionCount >= self.tableView.numberOfSections {
            self.refreshControl?.endRefreshing()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        } else {
            myAvailableUpdateHelper.executeNextDownloadTask()
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if nil != error {
            updateSectionCount += 1
            myAvailableUpdateHelper.executeNextDownloadTask()
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
        updateSectionCount = 0
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        myAvailableUpdateHelper.startJsonFileDownload(self)
    }
}
