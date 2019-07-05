//
//  AvailableApnListViewController.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/04/05.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class AvailableApnListViewController: UITableViewController,
    UISearchBarDelegate,
    URLSessionDownloadDelegate
{
    let myAvailableCountriesHelper = AvailableCountriesHelper()
    let myUtilCocoaHTTPServer = ConfigProfileService()
    let appStatus = UtilAppStatus()
    
    var myProfileHelper: AvailableProfileHelper!
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
        myProfileHelper = AvailableProfileHelper(list: targetProfileList)
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
        if !appStatus.isAvailableAllFunction() {
            appStatus.showStatuLimitByApple(self)
        } else {
            installProfileFromNetwork(indexPath)
        }
    }
    
    func confirmUpdateAvailableList() {
        let title = NSLocalizedString("confirm", comment: "")
        let message = NSLocalizedString("update_available_list", comment: "")
        let negativeMessage = NSLocalizedString("cancel", comment: "")
        let positiveMessage = NSLocalizedString("yes_update", comment: "")
        
        let cancelAction = UIAlertAction(title: negativeMessage, style: .cancel){
            action in self.reloadCachedData()
        }
        let updateAction = UIAlertAction(title: positiveMessage, style: .default){
            action in self.startJsonFileDownload()
        }
        
        UtilAlertSheet.showSheetController(title, message: message, actions: [cancelAction, updateAction], sender: self)
    }
    
    func confirmUpdateCachedProfile() {
        let title = NSLocalizedString("confirm", comment: "")
        let message = NSLocalizedString("update_available_profile", comment: "")
        let negativeMessage = NSLocalizedString("cancel", comment: "")
        let positiveMessage = NSLocalizedString("yes_cache", comment: "")
        
        let cancelAction = UIAlertAction(title: negativeMessage, style: .cancel){
            action in //do nothing
        }
        let updateAction = UIAlertAction(title: positiveMessage, style: .default){
            action in
            self.myProfileHelper = AvailableProfileHelper(list: self.myAvailableCountriesHelper.publicProfileList)
            self.myProfileHelper.startDownloadAvailableProfiles()
        }
        
        UtilAlertSheet.showSheetController(title, message: message, actions: [cancelAction, updateAction], sender: self)
    }
    
    func reloadCachedData() {
        self.myAvailableCountriesHelper.loadCachedJsonList()
        targetProfileList = myAvailableCountriesHelper.publicProfileList
        myProfileHelper = AvailableProfileHelper(list: targetProfileList)
        self.tableView.reloadData()
    }
    
    func installProfileFromNetwork(_ selectedIndexPath: IndexPath) {
        UIApplication.shared.openURL(myProfileHelper.getTargetUrl(selectedIndexPath))
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        myProfileHelper.executeDownloadProfile(indexPath: indexPath, success: { (filePath) in
            self.readProfileInfo(filePath)
        }) { (error) in
            self.fallbackCacheProfile(indexPath: indexPath, error: error)
        }
        appStatus.startIndicator(self.tableView)
        self.tableView.isScrollEnabled = false
    }
    
    func fallbackCacheProfile(indexPath: IndexPath, error: Error?) {
        let url = myProfileHelper.getTargetUrl(indexPath)
        let filePath = myProfileHelper.generateProfilePath(lastPathComponent: url.lastPathComponent)
        if FileManager.default.fileExists(atPath: filePath) {
            readProfileInfo(filePath)
        } else {
            self.appStatus.stopIndicator()
            self.tableView.isScrollEnabled = true
            self.showErrorDownload(error: error)
        }
    }
    
    func showErrorDownload(error: Error?) {
        if let nsError = error as NSError? {
            if #available(iOS 9.0, *) {
                if nsError.code == NSURLErrorAppTransportSecurityRequiresSecureConnection {
                    UtilAlertSheet.showAlertController("error", messagekey: "fail_load_profile_security", url: nil, vc: self)
                    return
                }
            }
        }
        UtilAlertSheet.showAlertController("error", messagekey: "fail_load_profile", url: nil, vc: self)
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
                self.tableView.isScrollEnabled = true
                self.appStatus.stopIndicator()
            })
        }
        myUtilCocoaHTTPServer.readDownloadedMobileConfigProfile(filePath)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let toIndex = searchBar.text!.index(searchBar.text!.startIndex, offsetBy: range.location)
        let newText = (text.isEmpty
            ? String(searchBar.text![..<toIndex])
            : String(searchBar.text![..<toIndex]) + text
        )
        loadTargetProfileList(newText)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadTargetProfileList(searchText)
    }
    
    func loadTargetProfileList(_ searchString: String) {
        if searchString.isEmpty {
            targetProfileList = myAvailableCountriesHelper.publicProfileList
        } else {
            targetProfileList = filteringTargetProfileList(searchString: searchString)
        }
        myProfileHelper = AvailableProfileHelper(list: targetProfileList)
        self.tableView.reloadData()
    }
    
    func filteringTargetProfileList(searchString: String) -> [NSArray] {
        var profileList = myAvailableCountriesHelper.publicProfileList
        
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
        myAvailableCountriesHelper.moveJSONFromURLSessionToLocation(downloadTask, location: location)
        
        if let response = downloadTask.response {
            let countryUrl = myAvailableCountriesHelper.getCountryFileUrl(response)
            let section = myAvailableCountriesHelper.getUpdateIndexSection(countryUrl!)
            if section != DownloadProfiles.ERROR_INDEX {
                targetProfileList = myAvailableCountriesHelper.publicProfileList
                self.tableView.reloadData()
                //self.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
            }
        }
        updateProgress()
        
        if updateSectionCount >= self.tableView.numberOfSections {
            endJsonFileDownload()
        } else {
            //myAvailableCountriesHelper.executeNextDownloadTask()
        }
        session.invalidateAndCancel()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if nil != error {
            //updateProgress()
            //myAvailableCountriesHelper.executeNextDownloadTask()
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
    
    @objc func startJsonFileDownload() {
        updateSectionCount = 0
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        myAvailableCountriesHelper.startJsonFileDownload(self)
        startProgressView()
    }
    
    func endJsonFileDownload() {
        invalidateIndicator()
        //myAvailableCountriesHelper.endJsonFileDownload()
        confirmUpdateCachedProfile()
    }
    
    func invalidateIndicator() {
        self.refreshControl?.endRefreshing()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        stopProgressView()
    }
    
    func startProgressView() {
        progressView = ProgressIndicatorView.instanceFromNib(appStatus.getIndicatorFrame(self.tableView))
        //progressView.center = self.view.center
        progressView.progressBar.progress = 0.0
        progressView.cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: UIControl.State())
        progressView.didTapCancel = { (button) in
            self.updateSectionCount = self.tableView.numberOfSections + 1
            self.invalidateIndicator()
        }
        self.view.addSubview(progressView)
        self.tableView.isScrollEnabled = false
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func updateProgress() {
        updateSectionCount += 1
        print("updateSectionCount = \(updateSectionCount)")
        print("numberOfSections = \(self.tableView.numberOfSections)")
        progressView.progressBar.progress = Float(updateSectionCount) / Float(self.tableView.numberOfSections)
    }
    
    func stopProgressView() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.tableView.isScrollEnabled = true
        progressView.removeFromSuperview()
    }
}
