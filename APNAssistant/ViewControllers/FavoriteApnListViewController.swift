//
//  FavoriteApnListViewController.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit
import Realm

class FavoriteApnListViewController: ApnListViewController {

    var allFavoriteApnSummaryObjs: RLMResults<RLMObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("favoriteList", comment: "")
        allFavoriteApnSummaryObjs = ApnSummaryObject.getFavoriteLists()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if 0 == Int(allFavoriteApnSummaryObjs.count) {
//            showNodataMessage()
//        } else {
//            dismissNodataMossage()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(allFavoriteApnSummaryObjs.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteSeletedApn(allFavoriteApnSummaryObjs, indexPath: indexPath)
            
        } else if editingStyle == .insert {
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

    // MARK: - UISearchBarDelegate
    override func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let toIndex = searchBar.text!.index(searchBar.text!.startIndex, offsetBy: range.location)
        let newText = (text.isEmpty
            ? String(searchBar.text![..<toIndex])
            : String(searchBar.text![..<toIndex]) + text
        )
        loadTargetApnSummaryObjs(newText)
        return true
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadTargetApnSummaryObjs(searchText)
    }
    
    override func loadTargetApnSummaryObjs(_ searchString: String) {
        if searchString.isEmpty {
            allFavoriteApnSummaryObjs = ApnSummaryObject.getFavoriteLists()
        } else {
            allFavoriteApnSummaryObjs = ApnSummaryObject.getSearchedFavoriteLists(searchString)
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
            destinationVC.myApnSummaryObject = allFavoriteApnSummaryObjs.object(at: UInt(((indexPath as NSIndexPath?)?.row)!)) as! ApnSummaryObject
            
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    

}
