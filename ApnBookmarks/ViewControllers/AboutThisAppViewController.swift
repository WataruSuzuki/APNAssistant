//
//  AboutThisAppViewController.swift
//  ApnBookmarks
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
        Account,
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
        
        if indexPath.section == 0 {
            cell.accessoryType = .None
            cell.textLabel?.text = section!.getText()
        } else {
            cell.accessoryType = .DetailButton
            switch AboutThisApp.Section(rawValue: indexPath.section)! {
            case .Apn:
                cell.textLabel?.text = section!.getText() + "\n\n" + NSLocalizedString("HowAboutApn", comment: "")
                
            case .Profile:
                cell.textLabel?.text = section!.getText() + "\n\n" + NSLocalizedString("HowAboutConfigProfile", comment: "")
                
            case .Contact:
                cell.textLabel?.text = section!.getText() + "\n\n" + NSLocalizedString("HowAboutContact", comment: "")
                
            case .Account:
                cell.textLabel?.text = section!.getText() + "\n\n" + NSLocalizedString("HowAboutAccount", comment: "")
                cell.accessoryType = .DisclosureIndicator
                
            default:
                break
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch AboutThisApp.Section(rawValue: indexPath.section)! {
        case .Account:
            self.performSegueWithIdentifier("AccountManageViewController", sender: self)
            
        default:
            break
        }
    }

    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        switch AboutThisApp.Section(rawValue: indexPath.section)! {
        case .Apn:
            let url = NSURL(string: "https://wikipedia.org/wiki/APN")
            UIApplication.sharedApplication().openURL(url!)
            
        case .Profile:
            let url = NSURL(string: "https://developer.apple.com/library/prerelease/content/documentation/NetworkingInternet/Conceptual/iPhoneOTAConfiguration/Introduction/Introduction.html")
            UIApplication.sharedApplication().openURL(url!)
            
        case .Contact:
            let url = NSURL(string: "https://twitter.com/DevJchanKchan")
            UIApplication.sharedApplication().openURL(url!)
            
        default:
            break
        }
    }
}
