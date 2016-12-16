//
//  AvailableApnListViewController.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/04/05.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class AvailableApnListViewController: UITableViewController,
    //UISearchDisplayDelegate,
    UISearchBarDelegate,
    UIAlertViewDelegate, UIActionSheetDelegate,
    URLSessionDownloadDelegate
{
    let myAvailableUpdateHelper = AvailableUpdateHelper()
    let myUtilCocoaHTTPServer = UtilCocoaHTTPServer()
    let appStatus = UtilAppStatus()
    
    var updateSectionCount = 0
    var progressView: ProgressIndicatorView!
    var cachedObj: ApnSummaryObject!
    var isUpdateConfirm = false
    var targetProfileList = [NSArray](repeating: [], count: DownloadProfiles.json.MAX.rawValue)
    
    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    @IBOutlet weak var profileSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("availableList", comment: "")
        reloadCachedData()
        
        let jsonRefreshControl = UIRefreshControl()
        jsonRefreshControl.addTarget(self, action: #selector(AvailableApnListViewController.startJsonFileDownload), for: .valueChanged)
        self.refreshControl = jsonRefreshControl
        
        self.tableView.keyboardDismissMode = .interactive
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return targetProfileList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetProfileList[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadProfileListCell", for: indexPath)

        let items = targetProfileList[indexPath.section] as NSArray
        let item = items[indexPath.row] as! NSDictionary
        cell.textLabel?.text = item.object(forKey: DownloadProfiles.profileName) as? String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if targetProfileList[section].count == 0 {
            return ""
        }
        let jsonName = DownloadProfiles.json(rawValue: section)!
        return NSLocalizedString(jsonName.toString(), comment: "") //+ "(" + NSLocalizedString((offset.0 ? "custom": "public"), comment: "") + ")"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        installProfileFromNetwork(indexPath)
    }
    
    func confirmUpdateAvailableList() {
        let title = NSLocalizedString("confirm", comment: "")
        let message = NSLocalizedString("update_available_list", comment: "")
        let negativeMessage = NSLocalizedString("cancel", comment: "")
        let positiveMessage = NSLocalizedString("yes_update", comment: "")
        
        var actions = [Any]()
        if #available(iOS 8.0, *) {
            let cancelAction = UIAlertAction(title: negativeMessage, style: UIAlertActionStyle.cancel){
                action in self.reloadCachedData()
            }
            let installAction = UIAlertAction(title: positiveMessage, style: UIAlertActionStyle.default){
                action in self.startJsonFileDownload()
            }
            actions.append(cancelAction)
            actions.append(installAction)
        } else {
            actions.append(positiveMessage)
            actions.append(negativeMessage)
        }
        
        UtilAlertSheet.showSheetController(title, message: message, actions: actions, sender: self)
    }
    
    func reloadCachedData() {
        self.myAvailableUpdateHelper.loadCachedJsonList()
        targetProfileList = myAvailableUpdateHelper.publicProfileList
        self.tableView.reloadData()
    }
    
    func installProfileFromNetwork(_ selectedIndexPath: IndexPath) {
        UIApplication.shared.openURL(getTargetUrl(selectedIndexPath))
    }
    
    func getTargetUrl(_ selectedIndexPath: IndexPath) -> URL {
        let profileData = targetProfileList[(selectedIndexPath as NSIndexPath).section]
        let item = profileData[selectedIndexPath.row] as! NSDictionary
        let urlPath = item.object(forKey: DownloadProfiles.profileUrl) as! String
        return URL(string: urlPath)!
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let reqUrl = getTargetUrl(indexPath)
        let config = URLSessionConfiguration.default
        let session = Foundation.URLSession(configuration: config)
        let task = session.downloadTask(with: reqUrl, completionHandler: { (location, response, error) in
            if let thisResponse = response, let thisLocation = location {
                if let lastPathComponent = thisResponse.url?.lastPathComponent {
                    if lastPathComponent.contains(".mobileconfig") {
                        let helper = AvailableUpdateHelper()
                        let fileName = lastPathComponent.replacingOccurrences(of: ".mobileconfig", with: "")
                        let filePath = self.myUtilCocoaHTTPServer.getTargetFilePath(fileName, fileType: ".mobileconfig")
                        helper.moveDownloadItemAtURL(filePath, location: thisLocation)
                        
                        self.readProfileInfo(filePath)
                        return
                    }
                }
            }
            print(error as Any)
            DispatchQueue.main.async(execute: {
                self.appStatus.stopIndicator()
                if let nsError = error as? NSError {
                    if #available(iOS 9.0, *) {
                        if nsError.code == NSURLErrorAppTransportSecurityRequiresSecureConnection {
                            UtilAlertSheet.showAlertController("error", messagekey: "fail_load_profile_security", url: nil, vc: self)
                            return
                        }
                    }
                }
                UtilAlertSheet.showAlertController("error", messagekey: "fail_load_profile", url: nil, vc: self)
            })
            
        }) 
        
        task.resume()
        appStatus.startIndicator(self.tableView)
    }
    
    func readProfileInfo(_ filePath: String) {
        myUtilCocoaHTTPServer.didEndParse = {(parse, obj) in
            if obj.name != NSLocalizedString("unknown", comment: "") {
                DispatchQueue.main.async(execute: {
                    self.cachedObj = obj
                    self.performSegue(withIdentifier: "DetailApnViewController", sender: self)
                })
            }
            DispatchQueue.main.async(execute: {
                self.appStatus.stopIndicator()
            })
        }
        myUtilCocoaHTTPServer.readDownloadedMobileConfigProfile(filePath)
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if 0 == buttonIndex {
            self.startJsonFileDownload()
        }
    }
    
    // MARK: - UISearchDisplayDelegate
//    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
//        loadTargetProfileList(searchString!)
//        return true
//    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (text.isEmpty
            ? searchBar.text!.substring(to: searchBar.text!.characters.index(searchBar.text!.startIndex, offsetBy: range.location))
            : searchBar.text!.substring(to: searchBar.text!.characters.index(searchBar.text!.startIndex, offsetBy: range.location)) + text
        )
        loadTargetProfileList(newText)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadTargetProfileList(searchText)
    }
    
    func loadTargetProfileList(_ searchString: String) {
        if searchString.isEmpty {
            targetProfileList = myAvailableUpdateHelper.publicProfileList
        } else {
            targetProfileList = filteringTargetProfileList(searchString: searchString)
        }
        self.tableView.reloadData()
    }
    
    func filteringTargetProfileList(searchString: String) -> [NSArray] {
        var profileList = myAvailableUpdateHelper.publicProfileList
        
        let sectionCount = profileList.count
        for section in 0..<sectionCount {
            let items = NSMutableArray(array: profileList[section])
            let rowCount = items.count
            for row in (0..<rowCount).reversed() {
                let item = items[row] as! NSDictionary
                if let name = item.object(forKey: DownloadProfiles.profileName) as? String {
                    if name.contains(searchString) {
                        //Hit!!
                    } else {
                        items.removeObject(at: row)
                    }
                }
            }
            profileList[section] = items
        }
        
        return profileList
    }
    
    // MARK: - Action
    @IBAction func tapRefreshBarButton(_ sender: UIBarButtonItem) {
        startJsonFileDownload()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "DetailApnViewController":
            let destinationVC = segue.destination as! DetailApnViewController
            destinationVC.myApnSummaryObject = cachedObj
            destinationVC.isShowCloudData = true
            
        default:
            break
        }
    }
    
    // MARK: - NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        myAvailableUpdateHelper.moveJSONFilesFromURLSession(downloadTask, location: location)
        
        if let response = downloadTask.response {
            let countryUrl = myAvailableUpdateHelper.getCountryFileUrl(response)
            let section = myAvailableUpdateHelper.getUpdateIndexSection(countryUrl!)
            if section != DownloadProfiles.ERROR_INDEX {
                targetProfileList = myAvailableUpdateHelper.publicProfileList
                self.tableView.reloadData()
                //self.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
            }
        }
        updateProgress()
        
        print("updateSectionCount = \(updateSectionCount)")
        print("numberOfSections = \(self.tableView.numberOfSections)")
        if updateSectionCount >= self.tableView.numberOfSections {
            self.refreshControl?.endRefreshing()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            stopProgressView()
//            myAvailableUpdateHelper.stopDownloadTask()
        } else {
            //myAvailableUpdateHelper.executeNextDownloadTask()
        }
        session.invalidateAndCancel()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if nil != error {
            //updateProgress()
            //myAvailableUpdateHelper.executeNextDownloadTask()
        }
        session.invalidateAndCancel()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //TODO
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("progress = \(Float((bytesWritten / totalBytesWritten) * 100))%")
        //TODO
    }
    
    func startJsonFileDownload() {
        updateSectionCount = 0
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        myAvailableUpdateHelper.startJsonFileDownload(self)
        startProgressView()
    }
    
    func startProgressView() {
        progressView = ProgressIndicatorView.instanceFromNib(appStatus.getIndicatorFrame(self.tableView))
        //progressView.center = self.view.center
        progressView.progressBar.progress = 0.0
        progressView.cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: UIControlState())
        progressView.didTapCancel = { (button) in
            self.updateSectionCount = self.tableView.numberOfSections + 1
        }
        self.view.addSubview(progressView)
        self.tableView.isScrollEnabled = false
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func updateProgress() {
        updateSectionCount += 1
        progressView.progressBar.progress = Float(updateSectionCount) / Float(self.tableView.numberOfSections)
    }
    
    func stopProgressView() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.tableView.isScrollEnabled = true
        progressView.removeFromSuperview()
    }
}
