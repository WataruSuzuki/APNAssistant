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
        //Contact,
        //Account,
        MAX
        
        func getText() -> String {
            let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
            let key = (self == .Summary
                ?"AboutThisApp" + String(self) + appName
                :"AboutThisApp" + String(self))
            print(key)
            return NSLocalizedString(key, comment: "")
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
        cell.textLabel?.numberOfLines = 0
        
        let aboutThis = AboutThisApp.Section(rawValue: indexPath.section)!
        if aboutThis == .Summary {
            cell.accessoryType = .None
            cell.textLabel?.text = aboutThis.getText()
        } else {
            cell.accessoryType = .DetailButton
            switch aboutThis {
            case .Apn:
                cell.textLabel?.text = NSLocalizedString("HowAboutApn", comment: "")
                
            case .Profile:
                cell.textLabel?.text = NSLocalizedString("HowAboutConfigProfile", comment: "")
                
//            case .Contact:
//                cell.textLabel?.text = NSLocalizedString("HowAboutContact", comment: "")
                
            default:
                break
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let aboutThisApp = AboutThisApp.Section(rawValue: section)
        if aboutThisApp == .Summary {
            return ""
        } else {
            return aboutThisApp!.getText()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch AboutThisApp.Section(rawValue: indexPath.section)! {
//        case .Account:
//            self.performSegueWithIdentifier("AccountManageViewController", sender: self)
            
        default:
            break
        }
    }

    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        switch AboutThisApp.Section(rawValue: indexPath.section)! {
        case .Apn:
            let url = NSURL(string: "https://en.m.wikipedia.org/wiki/APN")
            UIApplication.sharedApplication().openURL(url!)
            
        case .Profile:
            let url = NSURL(string: "https://developer.apple.com/library/prerelease/content/documentation/NetworkingInternet/Conceptual/iPhoneOTAConfiguration/Introduction/Introduction.html")
            UIApplication.sharedApplication().openURL(url!)
            
//        case .Contact:
//            let url = NSURL(string: "https://twitter.com/DevJchanKchan")
//            UIApplication.sharedApplication().openURL(url!)
            
        default:
            break
        }
    }
}
