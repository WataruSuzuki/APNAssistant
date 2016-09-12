//
//  DownloadProfileListViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/05.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class DownloadProfileListViewController: UITableViewController,
    NSURLSessionDownloadDelegate
{
    let myUtilDownloadProfileList = UtilDownloadProfileList()

    override func viewDidLoad() {
        super.viewDidLoad()

        startJsonFileDownload()
        
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
        if section > (DownloadProfiles.json.MAX.rawValue - 1) {
            let customSection = section - DownloadProfiles.json.MAX.rawValue
            return myUtilDownloadProfileList.customProfileList[customSection].count
        } else {
            return myUtilDownloadProfileList.publicProfileList[section].count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DownloadProfileListCell", forIndexPath: indexPath)

        let items: NSArray
        // Configure the cell...
        if indexPath.section > (DownloadProfiles.json.MAX.rawValue - 1) {
            let customSection = indexPath.section - DownloadProfiles.json.MAX.rawValue
            items = myUtilDownloadProfileList.customProfileList[customSection] as NSArray
        } else {
            items = myUtilDownloadProfileList.publicProfileList[indexPath.section] as NSArray
        }
        cell.textLabel?.text = items[indexPath.row].objectForKey("name") as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > (DownloadProfiles.json.MAX.rawValue - 1) {
            let jsonName = DownloadProfiles.json(rawValue: section - DownloadProfiles.json.MAX.rawValue)!
            return jsonName.toString() + "(" + NSLocalizedString("custom", comment: "") + ")"
        } else {
            let jsonName = DownloadProfiles.json(rawValue: section)!
            return jsonName.toString() + "(" + NSLocalizedString("public", comment: "") + ")"
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
    
    // MARK: - NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        myUtilDownloadProfileList.moveJSONFilesFromURLSession(downloadTask, location: location)
        
        let section = myUtilDownloadProfileList.getUpdateIndexSection(downloadTask)
        if section != DownloadProfiles.ERROR_INDEX {
            self.tableView.reloadData()
            //self.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
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
