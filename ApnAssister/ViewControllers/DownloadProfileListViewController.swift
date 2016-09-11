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
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    func moveJSONFilesFromURLSession(fileManager: NSFileManager, fileName: String, fileType: String, location: NSURL) {
        let filePath = UtilCocoaHTTPServer().getTargetFilePath(fileName, fileType: fileType)
        
        if fileManager.fileExistsAtPath(filePath) {
            try! fileManager.removeItemAtPath(filePath)
        }
        
        let url = NSURL.fileURLWithPath(filePath)
        do{
            try fileManager.moveItemAtURL(location, toURL: url)
            let jsonData = NSData(contentsOfURL: url)
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers) as! NSDictionary
            print(json)
            let station = json.objectForKey("items") as! NSArray
            for i in 0  ..< station.count  {
                print(station[i].objectForKey("name") as! NSString)
            }
        } catch {
            let nsError = error as NSError
            print(nsError.description)
        }
    }
    
    // MARK: - NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        // ファイルを移動.
        let fileManager = NSFileManager.defaultManager()
        moveJSONFilesFromURLSession(fileManager, fileName: "japan", fileType: ".json", location: location)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //TODO
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("progress = \(Float((bytesWritten / totalBytesWritten) * 100))%")
        //TODO
    }
    
    func startJsonFileDownload() {
        let url = NSURL(string: "https://watarusuzuki.github.io/public-profiles/japan.json")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        session.downloadTaskWithURL(url!).resume()
    }
}
