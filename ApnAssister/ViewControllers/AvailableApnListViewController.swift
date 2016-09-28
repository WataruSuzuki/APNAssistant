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
    let myUtilCocoaHTTPServer = UtilCocoaHTTPServer()
    let appStatus = UtilAppStatus()
    
    var updateSectionCount = 0
    var progressView: ProgressIndicatorView!
    var indicator: UIActivityIndicatorView!
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
        return myAvailableUpdateHelper.publicProfileList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAvailableUpdateHelper.publicProfileList[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DownloadProfileListCell", forIndexPath: indexPath)

        let items = myAvailableUpdateHelper.publicProfileList[indexPath.section] as NSArray
        cell.textLabel?.text = items[indexPath.row].objectForKey(DownloadProfiles.profileName) as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if myAvailableUpdateHelper.publicProfileList[section].count == 0 {
            return ""
        }
        let jsonName = DownloadProfiles.json(rawValue: section)!
        return NSLocalizedString(jsonName.toString(), comment: "") //+ "(" + NSLocalizedString((offset.0 ? "custom": "public"), comment: "") + ")"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !appStatus.isAvailableAllFunction() {
            appStatus.showStatuLimitByApple(self)
        } else {
            installProfileFromNetwork(indexPath)
        }
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
                let tabBarItemWidth = Int((self.tabBarController?.tabBar.frame.size.width)!) / (self.tabBarController?.tabBar.items!.count)!
                let x = (tabBarItemWidth * 1) //- (tabBarItemWidth / 5);
                let newRect = CGRect(x: x, y: 0, width: tabBarItemWidth, height: Int((self.tabBarController?.tabBar.frame.size.height)!))
                
                alertController.popoverPresentationController?.sourceRect = newRect
                alertController.popoverPresentationController?.sourceView = self.tabBarController?.tabBar
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
        let profileData = myAvailableUpdateHelper.publicProfileList[selectedIndexPath.section]
        let urlPath = profileData[selectedIndexPath.row].objectForKey(DownloadProfiles.profileUrl) as! String
        return NSURL(string: urlPath)!
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let reqUrl = getTargetUrl(indexPath)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.downloadTaskWithURL(reqUrl) { (location, response, error) in
            if let thisResponse = response, let thisLocation = location {
                if let lastPathComponent = thisResponse.URL?.lastPathComponent {
                    if lastPathComponent.containsString(".mobileconfig") {
                        let helper = AvailableUpdateHelper()
                        let fileName = lastPathComponent.stringByReplacingOccurrencesOfString(".mobileconfig", withString: "")
                        let filePath = self.myUtilCocoaHTTPServer.getTargetFilePath(fileName, fileType: ".mobileconfig")
                        helper.moveDownloadItemAtURL(filePath, location: thisLocation)
                        
                        self.readProfileInfo(filePath)
                        return
                    }
                }
            }
            print(error?.description)
            dispatch_async(dispatch_get_main_queue(), {
                self.stopIndicator()
                UtilAlertSheet.showFailAlertController("fail_load_profile", url: nil, vc: self)
            })
            
        }
        
        task.resume()
        startIndicator()
    }
    
    func readProfileInfo(filePath: String) {
        myUtilCocoaHTTPServer.didEndParse = {(parse, obj) in
            if obj.name != NSLocalizedString("unknown", comment: "") {
                dispatch_async(dispatch_get_main_queue(), {
                    self.cachedObj = obj
                    self.performSegueWithIdentifier("DetailApnViewController", sender: self)
                })
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.stopIndicator()
            })
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
        session.invalidateAndCancel()
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if nil != error {
            updateProgress()
            myAvailableUpdateHelper.executeNextDownloadTask()
        }
        session.invalidateAndCancel()
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
    
    func getIndicatorFrame() -> CGRect {
        return CGRect(origin: self.tableView.contentOffset, size: self.view.frame.size)
    }
    
    func startProgressView() {
        progressView = ProgressIndicatorView.instanceFromNib(getIndicatorFrame())
        //progressView.center = self.view.center
        progressView.progressBar.progress = 0.0
        progressView.cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), forState: .Normal)
        progressView.didTapCancel = { (button) in
            self.updateSectionCount = self.tableView.numberOfSections + 1
        }
        self.view.addSubview(progressView)
        self.tableView.scrollEnabled = false
    }
    
    func updateProgress() {
        updateSectionCount += 1
        progressView.progressBar.progress = Float(updateSectionCount) / Float(self.tableView.numberOfSections)
    }
    
    func stopProgressView() {
        self.tableView.scrollEnabled = true
        progressView.removeFromSuperview()
    }
    
    func startIndicator() {
        indicator = UIActivityIndicatorView(frame: getIndicatorFrame())
        //indicator.center = self.view.center
        indicator.backgroundColor = UIColor.darkGrayColor()
        indicator.alpha = 0.5
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        self.view.addSubview(indicator)
    }
    
    func stopIndicator() {
        indicator.removeFromSuperview()
    }
}
