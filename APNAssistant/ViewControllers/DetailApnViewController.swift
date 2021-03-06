//
//  DetailApnViewController.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/04/20.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit
import Realm

protocol DetailApnPreviewDelegate {
    func selectShareAction(_ handleObj: UtilHandleRLMObject)
    func selectEditAction(_ newObj: ApnSummaryObject)
}

class DetailApnViewController: UITableViewController,
    EditApnViewControllerDelegate
{
    let myUtilCocoaHTTPServer = ConfigProfileService()
    let appStatus = UtilAppStatus()
    
    var myUtilHandleRLMObject: UtilHandleRLMObject!
    var myApnSummaryObject: ApnSummaryObject!

    var isShowCloudData = false
    var delegate: DetailApnPreviewDelegate!
    
    lazy var previewActions: [UIPreviewActionItem] = {
        let menuArray = self.loadMenuArray()
        
        let setApnAction = UIPreviewAction(title: menuArray[DetailMenu.setThisApnToDevice.rawValue], style: .destructive, handler: { (action, viewcontroller) in
            self.handleUpdateDeviceApn()
        })
        let shareAction = UIPreviewAction(title: menuArray[DetailMenu.share.rawValue], style: .default, handler: { (action, viewcontroller) in
            self.delegate.selectShareAction(self.myUtilHandleRLMObject)
        })
        let editAction = UIPreviewAction(title: menuArray[DetailMenu.edit.rawValue], style: .default, handler: { (action, viewcontroller) in
            self.delegate.selectEditAction(self.myApnSummaryObject)
        })
        
        //let subAction1 = previewActionForTitle("Sub Action 1")
        //let subAction2 = previewActionForTitle("Sub Action 2")
        //let groupedActions = UIPreviewActionGroup(title: "Sub Actions…", style: .Default, actions: [subAction1, subAction2] )
        
        if UtilAppStatus().isShowImportantMenu() {
            return [setApnAction, shareAction, editAction/*, groupedActions*/]
        } else {
            return [shareAction, editAction]
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTargetSummaryObj()
        
        let menuButton = UIBarButtonItem(title: NSLocalizedString("menu", comment: ""), style: .plain, target: self, action: #selector(DetailApnViewController.showMenuSheet))
        self.navigationItem.rightBarButtonItem = menuButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ApnSummaryObject.ApnInfoColumn.max.rawValue - 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = ApnSummaryObject.ApnInfoColumn(rawValue: section + 1)
        if sectionType == ApnSummaryObject.ApnInfoColumn.summary {
            return 0
        }
        return ApnProfileObject.KeyAPNs.maxRaw(sectionType!)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailApnCell", for: indexPath)

        let type = ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section + 1)!
        let column = ApnProfileObject.KeyAPNs(rawValue: indexPath.row)!
        cell.textLabel?.text = column.getTitle(type)
        switch column {
        case ApnProfileObject.KeyAPNs.password:
            cell.detailTextLabel?.text = "*******"
        
        case ApnProfileObject.KeyAPNs.allowed_protocol_mask:fallthrough
        case ApnProfileObject.KeyAPNs.allowed_protocol_mask_in_roaming:fallthrough
        case ApnProfileObject.KeyAPNs.allowed_protocol_mask_in_domestic_roaming:
            let maskValue = myUtilHandleRLMObject.getKeptApnProfileColumnValue(type, column: column)
            if maskValue.isEmpty {
                cell.detailTextLabel?.text = maskValue
            } else {
                if let maskType = AllowedProtocolMask(rawValue: Int(maskValue)!) {
                    cell.detailTextLabel?.text = (maskType == AllowedProtocolMask.nothing ? "" : maskType.toString())
                }
            }
            
        default:
            cell.detailTextLabel?.text = myUtilHandleRLMObject.getKeptApnProfileColumnValue(type, column: column)
        }

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    // MARK: - EditApnViewControllerDelegate
    func didFinishEditApn(_ newObj: ApnSummaryObject) {
        myApnSummaryObject = newObj
        loadTargetSummaryObj()
        if #available(iOS 9.0, *) {
            UtilShortcutLaunch().initDynamicShortcuts(UIApplication.shared)
        }
        
        self.tableView.reloadData()
    }
    
    func loadTargetSummaryObj() {
        myUtilHandleRLMObject = UtilHandleRLMObject(id: myApnSummaryObject.id, profileObj: myApnSummaryObject.apnProfile!, summaryObj: myApnSummaryObject)
        self.navigationItem.title = myApnSummaryObject.name
        
        myUtilHandleRLMObject.prepareKeepApnProfileColumn(myApnSummaryObject.apnProfile!)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard (segue.identifier != nil) else { return }
        switch segue.identifier! {
        case "EditApnViewController":
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! EditApnViewController
            controller.editingApnSummaryObj = myApnSummaryObject
            controller.delegate = self
            
        default:
            break
        }
    }

    func loadMenuArray() -> [String] {
        var menuArray = [String]()
        
        for index in DetailMenu.setThisApnToDevice.rawValue..<DetailMenu.max.rawValue {
            menuArray.append(NSLocalizedString(DetailMenu(rawValue: index)!.toString(), comment: ""))
        }
        
        if isShowCloudData {
            menuArray[DetailMenu.edit.rawValue] = NSLocalizedString("cache", comment: "")
        }

        return menuArray
    }
    
    @objc func showMenuSheet() {
        let menuArray = loadMenuArray()
        showMenuAlertController(NSLocalizedString("menu", comment: ""), menuArray: menuArray)
    }
    
    func showMenuAlertController(_ title: String, menuArray: [String]){
        let setApnAction = UIAlertAction(title: menuArray[DetailMenu.setThisApnToDevice.rawValue], style: .destructive){
            action in self.handleUpdateDeviceApn()
        }
        let shareAction = UIAlertAction(title: menuArray[DetailMenu.share.rawValue], style: .default){
            action in ProfileAction.share(self.myUtilCocoaHTTPServer, obj: self.myUtilHandleRLMObject, sender: self)
        }
        let editAction = UIAlertAction(title: menuArray[DetailMenu.edit.rawValue], style: .default){
            action in self.showEditApnViewController()
        }
        let cancelAction = UIAlertAction(title: menuArray[DetailMenu.cancel.rawValue], style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(cancelAction)
        if appStatus.isShowImportantMenu() {
            alertController.addAction(setApnAction)
        }
        alertController.addAction(shareAction)
        alertController.addAction(editAction)
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showEditApnViewController() {
        if isShowCloudData {
            let obj = UtilHandleRLMObject(id: UtilHandleRLMConst.CREATE_NEW_PROFILE, profileObj: ApnProfileObject(), summaryObj: ApnSummaryObject())
            obj.prepareKeepApnProfileColumn(myApnSummaryObject!.apnProfile!)
            obj.profileName = myApnSummaryObject.name
            let realm = RLMRealm.default()
            obj.saveUpdateApnDataObj(realm, isSetDataApnManually: true)
            
            UtilAlertSheet.showAlertController("confirm", messagekey: "complete", url: nil, vc: self)
        } else {
            self.performSegue(withIdentifier: "EditApnViewController", sender: self)
        }
    }
    
    func handleUpdateDeviceApn(){
        self.myUtilCocoaHTTPServer.updateProfile(self.myUtilHandleRLMObject, sender: self)
    }
    
    // MARK: Preview actions
    override var previewActionItems : [UIPreviewActionItem] {
        return previewActions
    }
    
    enum DetailMenu: Int {
        case setThisApnToDevice = 0,
        share,
        edit,
        cancel,
        max
        
        func toString() -> String {
            return String(describing: self)
        }
    }
}
