//
//  AvailableApnListViewController.swift
//  ApnBookmarks
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
    let myUtilCocoaHTTPServer = UtilCocoaHTTPServer()
    
    var updateSectionCount = 0
    var indicatorView: ProgressIndicatorView!
    var cachedObj: ApnSummaryObject!
    var isUpdateConfirm = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("AvailableList", comment: "")
        let jsonRefreshControl = UIRefreshControl()
        jsonRefreshControl.addTarget(self, action: #selector(AvailableApnListViewController.startJsonFileDownload), forControlEvents: .ValueChanged)
        self.refreshControl = jsonRefreshControl
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isUpdateConfirm {
            confirmUpdateAvailableList()
            isUpdateConfirm = true
        }
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
                action in self.myAvailableUpdateHelper.loadCachedJsonList()
                self.tableView.reloadData()
            }
            let installAction = UIAlertAction(title: positiveMessage, style: UIAlertActionStyle.Default){
                action in self.startJsonFileDownload()
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            alertController.addAction(cancelAction)
            alertController.addAction(installAction)
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                alertController.popoverPresentationController?.sourceView = self.view
                alertController.popoverPresentationController?.sourceRect = CGRect(x: (self.view.frame.width/2), y: self.view.frame.height, width: 0, height: 0)
            }
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            showComfirmOldSheet(title + "\n" + message, negativeMessage: negativeMessage, positiveMessage: positiveMessage)
        }
    }
    
    func installProfileFromNetwork(selectedIndexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(getTargetUrl(selectedIndexPath))
    }
    
    func getTargetUrl(selectedIndexPath: NSIndexPath) -> NSURL {
        let offset = myAvailableUpdateHelper.getOffsetSection(selectedIndexPath.section)
        let profileData = (offset.0
            ? myAvailableUpdateHelper.customProfileList[offset.1]
            : myAvailableUpdateHelper.publicProfileList[offset.1]
        )
        let urlPath = profileData[selectedIndexPath.row].objectForKey(DownloadProfiles.profileUrl) as! String
        return NSURL(string: urlPath)!
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let reqUrl = getTargetUrl(indexPath)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.downloadTaskWithURL(reqUrl) { (location, response, error) in
            guard let thisResponse = response else { return }
            guard let thisLocation = location else { return }
            
            let helper = AvailableUpdateHelper()
            let fileName = thisResponse.URL?.lastPathComponent?.stringByReplacingOccurrencesOfString(".mobileconfig", withString: "")
            let filePath = self.myUtilCocoaHTTPServer.getTargetFilePath(fileName!, fileType: ".mobileconfig")
            helper.moveDownloadItemAtURL(filePath, location: thisLocation)
            
            self.readProfileInfo(filePath)
        }
        
        task.resume()
        startProgressView()
    }
    
    func readProfileInfo(filePath: String) {
        myUtilCocoaHTTPServer.didEndParse = {(parse, obj) in
            dispatch_async(dispatch_get_main_queue(), {
                self.stopProgressView()
            })
            if obj.name != NSLocalizedString("unknown", comment: "") {
                dispatch_async(dispatch_get_main_queue(), {
                    self.cachedObj = obj
                    self.performSegueWithIdentifier("DetailApnViewController", sender: self)
                })
            }
        }
        myUtilCocoaHTTPServer.readDownloadedMobileConfigProfile(filePath)
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if 0 == buttonIndex {
            self.startJsonFileDownload()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "DetailApnViewController":
            let destinationVC = segue.destinationViewController as! DetailApnViewController
            destinationVC.myApnSummaryObject = cachedObj
            
        default:
            break
        }
    }
    
    // MARK: - NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        myAvailableUpdateHelper.moveJSONFilesFromURLSession(downloadTask, location: location)
        
        if let response = downloadTask.response {
            let countryUrl = myAvailableUpdateHelper.getCountryFileUrl(response)
            let section = myAvailableUpdateHelper.getUpdateIndexSection(countryUrl!)
            if section != DownloadProfiles.ERROR_INDEX {
                self.tableView.reloadData()
                //self.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
            }
        }
        updateProgress()
        
        print("updateSectionCount = \(updateSectionCount)")
        print("numberOfSections = \(self.tableView.numberOfSections)")
        if updateSectionCount >= self.tableView.numberOfSections {
            self.refreshControl?.endRefreshing()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            stopProgressView()
            myAvailableUpdateHelper.stopDownloadTask()
        } else {
            myAvailableUpdateHelper.executeNextDownloadTask()
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if nil != error {
            updateProgress()
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
        startProgressView()
    }
    
    func startProgressView() {
        indicatorView = ProgressIndicatorView.instanceFromNib(self.tableView.frame)
        indicatorView.center = self.tableView.center
        indicatorView.progressBar.progress = 0.0
        indicatorView.cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), forState: .Normal)
        indicatorView.didTapCancel = { (button) in
            self.updateSectionCount = self.tableView.numberOfSections + 1
        }
        self.view.addSubview(indicatorView)
        self.tableView.scrollEnabled = false
    }
    
    func updateProgress() {
        updateSectionCount += 1
        indicatorView.progressBar.progress = Float(updateSectionCount) / Float(self.tableView.numberOfSections)
    }
    
    func stopProgressView() {
        self.tableView.scrollEnabled = true
        indicatorView.removeFromSuperview()
    }
}
