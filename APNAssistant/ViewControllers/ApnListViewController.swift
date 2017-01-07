//
//  ApnListViewController.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/03/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ApnListViewController: UITableViewController,
    UISearchBarDelegate,
    CMPopTipViewDelegate,
    DetailApnPreviewDelegate,
    EditApnViewControllerDelegate
{
    let tutorialPopView = CMPopTipView(message: NSLocalizedString("tutorial_message", comment: ""))
    let myUtilHandleRLMObject = UtilHandleRLMObject(id: UtilHandleRLMConst.CREATE_NEW_PROFILE, profileObj: ApnProfileObject(), summaryObj: ApnSummaryObject())
    let appStatus = UtilAppStatus()
    
    var msgNodataView: MsgNoDataView?
    var allApnSummaryObjs: RLMResults<RLMObject>!
    var previewApnSummaryObj: ApnSummaryObject?
    
    @IBOutlet weak var apnSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationItem.title = NSLocalizedString("profileList", comment: "")
        allApnSummaryObjs = ApnSummaryObject.allObjects()
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == .available {
                self.registerForPreviewing(with: self, sourceView: self.tableView)
            }
        }
        self.tableView.keyboardDismissMode = .interactive
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateApnSummaryObjs()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if 0 == Int(allApnSummaryObjs.count) {
            showNodataMessage()
        } else {
            dismissNodataMossage()
        }
    }
    
    func updateApnSummaryObjs() {
        allApnSummaryObjs = ApnSummaryObject.allObjects()
        if 0 < allApnSummaryObjs.count {
            tutorialPopView?.dismiss(animated: true)
        } else {
            tutorialPopView?.has3DStyle = false
            tutorialPopView?.presentPointing(at: self.navigationItem.rightBarButtonItem, animated: true)
        }
        if #available(iOS 9.0, *) {
            UtilShortcutLaunch().initDynamicShortcuts(UIApplication.shared)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(allApnSummaryObjs.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return loadApnListFromResults(allApnSummaryObjs, tableView: tableView, indexPath: indexPath)
    }
    
    func loadApnListFromResults(_ results: RLMResults<RLMObject>, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApnListCell", for: indexPath)
        
        // Configure the cell...
        let apnSummary = results.object(at: UInt(indexPath.row)) as! ApnSummaryObject
        cell.textLabel?.text = apnSummary.name
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteSeletedApn(allApnSummaryObjs, indexPath: indexPath)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func deleteSeletedApn(_ objs: RLMResults<RLMObject>, indexPath: IndexPath) {
        let apnSummary = objs.object(at: UInt(indexPath.row)) as! ApnSummaryObject
        myUtilHandleRLMObject.deleteApnSummaryObj(apnSummary)
        
        // Delete the row from the data source
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func showNodataMessage() {
        msgNodataView = MsgNoDataView.instanceFromNib(getTableViewFrame())
        msgNodataView!.labelMsgNoData.text = NSLocalizedString("nodata_available", comment: "")
        self.view.addSubview(msgNodataView!)
        self.tableView.isScrollEnabled = false
    }
    
    func getTableViewFrame() -> CGRect {
        return CGRect(origin: self.tableView.contentOffset, size: self.view.frame.size)
    }
    
    func dismissNodataMossage() {
        msgNodataView?.removeFromSuperview()
        self.tableView.isScrollEnabled = true
    }
    
    // MARK: - EditApnViewControllerDelegate
    func didFinishEditApn(_ newObj: ApnSummaryObject) {
        //Do nothing. Because this VC checking update in viewDidAppear.
    }
    
    // MARK: - DetailApnPreviewDelegate
    func selectShareAction(_ handleObj: UtilHandleRLMObject) {
        UtilShareAction.handleShareApn(UtilCocoaHTTPServer(), obj: handleObj, sender: self)
    }
    
    func selectEditAction(_ newObj: ApnSummaryObject) {
        previewApnSummaryObj = newObj
        self.performSegue(withIdentifier: "EditApnViewController", sender: self)
    }
    
    // MARK: - CMPopTipViewDelegate
    func popTipViewWasDismissed(byUser popTipView: CMPopTipView!) {
        //TODO
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (text.isEmpty
            ? searchBar.text!.substring(to: searchBar.text!.characters.index(searchBar.text!.startIndex, offsetBy: range.location))
            : searchBar.text!.substring(to: searchBar.text!.characters.index(searchBar.text!.startIndex, offsetBy: range.location)) + text
        )
        loadTargetApnSummaryObjs(newText)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadTargetApnSummaryObjs(searchText)
    }
    
    func loadTargetApnSummaryObjs(_ searchString: String) {
        if searchString.isEmpty {
            allApnSummaryObjs = ApnSummaryObject.allObjects()
        } else {
            allApnSummaryObjs = ApnSummaryObject.getSearchedLists(searchString)
        }
        self.tableView.reloadData()
    }
        
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "DetailApnViewController":
            let indexPath = self.tableView.indexPathForSelectedRow
            let destinationVC = segue.destination as! DetailApnViewController
            destinationVC.myApnSummaryObject = allApnSummaryObjs.object(at: UInt(((indexPath as NSIndexPath?)?.row)!)) as! ApnSummaryObject
            
        case "EditApnViewController":
            if let navigationController = segue.destination as? UINavigationController {
                let controller = navigationController.viewControllers.last as! EditApnViewController
                controller.editingApnSummaryObj = previewApnSummaryObj
                controller.delegate = self
                previewApnSummaryObj = nil
            }
            
        default:
            break
        }
    }
    
    // MARK: - Action
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "EditApnViewController", sender: self)
    }
}
