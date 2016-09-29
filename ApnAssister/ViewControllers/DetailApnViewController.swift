//
//  DetailApnViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/20.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

protocol DetailApnPreviewDelegate {
    func selectShareAction(handleObj: UtilHandleRLMObject)
    func selectEditAction(newObj: ApnSummaryObject)
}

class DetailApnViewController: UITableViewController,
    UIAlertViewDelegate, UIActionSheetDelegate,
    EditApnViewControllerDelegate
{
    let myUtilCocoaHTTPServer = UtilCocoaHTTPServer()
    let appStatus = UtilAppStatus()
    
    var myUtilHandleRLMObject: UtilHandleRLMObject!
    var myApnSummaryObject: ApnSummaryObject!

    var delegate: DetailApnPreviewDelegate!
    
    @available(iOS 9.0, *)
    lazy var previewActions: [UIPreviewActionItem] = {
        let menuArray = self.loadMenuArray()
        
        let setApnAction = UIPreviewAction(title: menuArray[Menu.setThisApnToDevice.rawValue], style: .Destructive, handler: { (action, viewcontroller) in
            self.handleUpdateDeviceApn()
        })
        let shareAction = UIPreviewAction(title: menuArray[Menu.share.rawValue], style: .Default, handler: { (action, viewcontroller) in
            self.delegate.selectShareAction(self.myUtilHandleRLMObject)
        })
        let editAction = UIPreviewAction(title: menuArray[Menu.edit.rawValue], style: .Default, handler: { (action, viewcontroller) in
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
        
        if appStatus.isAvailableAllFunction() {
        }
        let menuButton = UIBarButtonItem(title: NSLocalizedString("menu", comment: ""), style: .Bordered, target: self, action: #selector(DetailApnViewController.showMenuSheet))
        self.navigationItem.rightBarButtonItem = menuButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ApnSummaryObject.ApnInfoColumn.MAX.rawValue - 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = ApnSummaryObject.ApnInfoColumn(rawValue: section + 1)
        if sectionType == ApnSummaryObject.ApnInfoColumn.SUMMARY {
            return 0
        }
        return ApnProfileObject.KeyAPNs.maxRaw(sectionType!)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailApnCell", forIndexPath: indexPath)

        let type = ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section + 1)!
        let column = ApnProfileObject.KeyAPNs(rawValue: indexPath.row)!
        cell.textLabel?.text = column.getTitle(type)
        switch column {
        case ApnProfileObject.KeyAPNs.PASSWORD:
            cell.detailTextLabel?.text = "*******"
            
        default:
            cell.detailTextLabel?.text = myUtilHandleRLMObject.getKeptApnProfileColumnValue(type, column: column)
        }

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    // MARK: - EditApnViewControllerDelegate
    func didFinishEditApn(newObj: ApnSummaryObject) {
        myApnSummaryObject = newObj
        loadTargetSummaryObj()
        
        self.tableView.reloadData()
    }
    
    func loadTargetSummaryObj() {
        myUtilHandleRLMObject = UtilHandleRLMObject(id: myApnSummaryObject.id, profileObj: myApnSummaryObject.apnProfile, summaryObj: myApnSummaryObject)
        self.navigationItem.title = myApnSummaryObject.name
        
        myUtilHandleRLMObject.prepareKeepApnProfileColumn(myApnSummaryObject.apnProfile)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard (segue.identifier != nil) else { return }
        switch segue.identifier! {
        case "EditApnViewController":
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! EditApnViewController
            controller.editingApnSummaryObj = myApnSummaryObject
            controller.delegate = self
            
        default:
            break
        }
    }

    func loadMenuArray() -> [String] {
        var menuArray = [String]()
        
        for index in Menu.setThisApnToDevice.rawValue..<Menu.MAX.rawValue {
            menuArray.append(NSLocalizedString(Menu(rawValue: index)!.toString(), comment: ""))
        }
        return menuArray
    }
    
    func showMenuSheet() {
        let menuArray = loadMenuArray()
        showMenuAlertController(NSLocalizedString("menu", comment: ""), menuArray: menuArray)
    }
    
    func showComfirmOldSheet(title: String, menuArray: [String]) {
        let sheet = UIActionSheet()
        //sheet.tag =
        sheet.delegate = self
        sheet.title = title
        
        var dispMenuArray = menuArray
        if !appStatus.isShowImportantMenu() {
            dispMenuArray.removeAtIndex(Menu.setThisApnToDevice.rawValue)
        }
        for message in dispMenuArray {
            sheet.addButtonWithTitle(message)
        }
        sheet.cancelButtonIndex = dispMenuArray.count - 1
        if appStatus.isShowImportantMenu() {
            sheet.destructiveButtonIndex = 0
        }
        
        sheet.showInView(self.view)
    }
    
    func showMenuAlertController(title: String, menuArray: [String]){
        if #available(iOS 8.0, *) {
            let setApnAction = UIAlertAction(title: menuArray[Menu.setThisApnToDevice.rawValue], style: .Destructive){
                action in self.handleUpdateDeviceApn()
            }
            let shareAction = UIAlertAction(title: menuArray[Menu.share.rawValue], style: .Default){
                action in UtilShareAction.handleShareApn(self.myUtilCocoaHTTPServer, obj: self.myUtilHandleRLMObject, sender: self)
            }
            let editAction = UIAlertAction(title: menuArray[Menu.edit.rawValue], style: .Default){
                action in self.showEditApnViewController()
            }
            let cancelAction = UIAlertAction(title: menuArray[Menu.cancel.rawValue], style: .Cancel, handler: nil)
            
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .ActionSheet)
            alertController.addAction(cancelAction)
            if appStatus.isShowImportantMenu() {
                alertController.addAction(setApnAction)
            }
            alertController.addAction(shareAction)
            alertController.addAction(editAction)
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            }
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            showComfirmOldSheet(title, menuArray: menuArray)
        }
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch Menu(rawValue: (appStatus.isShowImportantMenu() ? buttonIndex : buttonIndex + 1))! {
        case .setThisApnToDevice:
            self.handleUpdateDeviceApn()
            
        case .share:
            UtilShareAction.handleShareApn(self.myUtilCocoaHTTPServer, obj: self.myUtilHandleRLMObject, sender: self)
            
        case .edit:
            self.showEditApnViewController()
            
        default:
            break
        }
    }
    
    func showEditApnViewController() {
        self.performSegueWithIdentifier("EditApnViewController", sender: self)
    }
    
    func handleUpdateDeviceApn(){
        if appStatus.isAvailableAllFunction() {
            let url = self.myUtilCocoaHTTPServer.prepareOpenSettingAppToSetProfile(self.myUtilHandleRLMObject)
            UIApplication.sharedApplication().openURL(url)
        } else {
            appStatus.showStatuLimitByApple(self)
        }
    }
        
    // MARK: Preview actions
    @available(iOS 9.0, *)
    override func previewActionItems() -> [UIPreviewActionItem] {
        return previewActions
    }
    
    enum Menu: Int {
        case setThisApnToDevice = 0,
        share,
        edit,
        cancel,
        MAX
        
        func toString() -> String {
            return String(self)
        }
    }
}
