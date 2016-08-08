//
//  ApnListViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ApnListViewController: UITableViewController,
    EditApnViewControllerDelegate
{

    var allApnSummaryObjs = ApnSummaryObject.allObjects()
    let myUtilHandleRLMObject = UtilHandleRLMObject(id: UtilHandleRLMConst.CREATE_NEW_PROFILE, profileObj: ApnProfileObject(), summaryObj: ApnSummaryObject())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("profile_list", comment: "")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        allApnSummaryObjs = ApnSummaryObject.allObjects()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(allApnSummaryObjs.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return loadApnListFromResults(allApnSummaryObjs, tableView: tableView, indexPath: indexPath)
    }
    
    func loadApnListFromResults(results: RLMResults, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ApnListCell", forIndexPath: indexPath)
        
        // Configure the cell...
        let apnSummary = results.objectAtIndex(UInt(indexPath.row)) as! ApnSummaryObject
        cell.textLabel?.text = apnSummary.name
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let apnSummary = allApnSummaryObjs.objectAtIndex(UInt(indexPath.row)) as! ApnSummaryObject
            myUtilHandleRLMObject.deleteApnSummaryObj(apnSummary)
            
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    // MARK: - EditApnViewControllerDelegate
    func didFinishEditApn(newObj: ApnSummaryObject) {
        //Do nothing. Because this VC checking update in viewDidAppear.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "DetailApnViewController":
            let indexPath = self.tableView.indexPathForSelectedRow
            let destinationVC = segue.destinationViewController as! DetailApnViewController
            destinationVC.myApnSummaryObject = allApnSummaryObjs.objectAtIndex(UInt((indexPath?.row)!)) as! ApnSummaryObject
            
        case "EditApnViewController":
            if let navigationController = segue.destinationViewController as? UINavigationController {
                let controller = navigationController.viewControllers.last as! EditApnViewController
                controller.delegate = self
            }
            
        default:
            break
        }
    }

}
