//
//  AboutThisAppViewController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/09/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

struct AboutThisApp {
    
    enum Section: Int {
        case Summary = 0,
        Apn,
        Profile,
        Contact,
        MAX
        
        func getText() -> String {
            return NSLocalizedString("AboutThisApp" + String(self), comment: "")
        }
    }
}

class AboutThisAppViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("AboutThisApp", comment: "")
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return AboutThisApp.Section.MAX.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AboutThisAppCell", forIndexPath: indexPath)

        // Configure the cell...
        let section = AboutThisApp.Section(rawValue: indexPath.section)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = section!.getText()
        
        if indexPath.section == 0 {
            cell.accessoryType = .None
        } else {
            cell.accessoryType = .DisclosureIndicator
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch AboutThisApp.Section(rawValue: indexPath.section)! {
        case .Summary:
            break
        default:
            self.performSegueWithIdentifier("EasyInfoViewController", sender: self)
        }
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destinationViewController as! EasyInfoViewController
            
            switch AboutThisApp.Section(rawValue: indexPath.section)! {
            case .Apn:
                controller.message = NSLocalizedString("HowAboutApn", comment: "")
                controller.nextUrl = NSURL(string: "https://wikipedia.org/wiki/APN")
                
            case .Profile:
                controller.message = NSLocalizedString("HowAboutConfigProfile", comment: "")
                controller.nextUrl = NSURL(string: "https://developer.apple.com/library/prerelease/content/documentation/NetworkingInternet/Conceptual/iPhoneOTAConfiguration/Introduction/Introduction.html")
                
            case .Contact:
                controller.message = NSLocalizedString("HowAboutConfigContact", comment: "")
                controller.nextUrl = NSURL(string: "https://twitter.com/DevJchanKchan")
                
            default:
                break
            }
        }
    }

}
