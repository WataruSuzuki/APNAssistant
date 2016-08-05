//
//  DetailApnViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/04/20.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class DetailApnViewController: UITableViewController {
    
    var myUtilHandleRLMObject: UtilHandleRLMObject!
    var myApnSummaryObject: ApnSummaryObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        myUtilHandleRLMObject = UtilHandleRLMObject(profileObj: myApnSummaryObject.apnProfile, summaryObj: myApnSummaryObject)
        self.title = myApnSummaryObject.name
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(DetailApnViewController.showEditApnViewController))
        self.navigationItem.rightBarButtonItem = editButton
        
        myUtilHandleRLMObject.prepareKeepApnProfileColumn(myApnSummaryObject.apnProfile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ApnSummaryObject.ApnInfoColumn.MAX.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = ApnSummaryObject.ApnInfoColumn(rawValue: section)
        if sectionType == ApnSummaryObject.ApnInfoColumn.SUMMARY {
            return 0
        }
        return ApnProfileObject.KeyAPNs.maxRaw(sectionType!)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailApnCell", forIndexPath: indexPath)

        let type = ApnSummaryObject.ApnInfoColumn(rawValue: indexPath.section)!
        let column = ApnProfileObject.KeyAPNs(rawValue: indexPath.row)!
        cell.textLabel?.text = column.getTitle(type)
        cell.detailTextLabel?.text = myUtilHandleRLMObject.getKeptApnProfileColumnValue(type, column: column)
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard (segue.identifier != nil) else { return }
        switch segue.identifier! {
        case "EditApnViewController":
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! EditApnViewController
            controller.editingApnSummaryObj = myApnSummaryObject
            
        default:
            break
        }
    }

    func showEditApnViewController() {
        self.performSegueWithIdentifier("EditApnViewController", sender: self)
    }
}
