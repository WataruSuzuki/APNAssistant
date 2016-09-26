//
//  FavoriteApnListViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class FavoriteApnListViewController: ApnListViewController {

    var allFavoriteApnSummaryObjs: RLMResults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("FavoriteList", comment: "")
        allFavoriteApnSummaryObjs = ApnSummaryObject.getFavoriteLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(allFavoriteApnSummaryObjs.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return loadApnListFromResults(allFavoriteApnSummaryObjs, tableView: tableView, indexPath: indexPath)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteSeletedApn(allFavoriteApnSummaryObjs, indexPath: indexPath)
            
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

    // MARK: - UISearchDisplayDelegate
    override func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        loadTargetApnSummaryObjs(searchString!)
        return true
    }
    
    // MARK: - UISearchBarDelegate
    override func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = (text.isEmpty
            ? searchBar.text!.substringToIndex(searchBar.text!.startIndex.advancedBy(range.location))
            : searchBar.text!.substringToIndex(searchBar.text!.startIndex.advancedBy(range.location)) + text
        )
        loadTargetApnSummaryObjs(newText)
        return true
    }
    
    override func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        loadTargetApnSummaryObjs(searchText)
    }
    
    override func loadTargetApnSummaryObjs(searchString: String) {
        if searchString.isEmpty {
            allFavoriteApnSummaryObjs = ApnSummaryObject.getFavoriteLists()
        } else {
            allFavoriteApnSummaryObjs = ApnSummaryObject.getSearchedFavoriteLists(searchString)
        }
        self.tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "DetailApnViewController":
            let indexPath = self.tableView.indexPathForSelectedRow
            let destinationVC = segue.destinationViewController as! DetailApnViewController
            destinationVC.myApnSummaryObject = allFavoriteApnSummaryObjs.objectAtIndex(UInt((indexPath?.row)!)) as! ApnSummaryObject
            
        default:
            super.prepareForSegue(segue, sender: sender)
        }
    }
    

}
