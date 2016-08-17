//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by WataruSuzuki on 2016/08/14.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var labelApnName: UILabel!
    //@IBOutlet weak var buttonOpenApp: UIButton!
    
    let myUtilCocoaHTTPServer = UtilCocoaHTTPServer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        labelTitle.text = NSLocalizedString("latest_set_profile", comment: "")
        
        myUtilCocoaHTTPServer.didEndParse = {(parse, obj) in
            self.labelProfileName.text = obj.name
            if obj.name == NSLocalizedString("unknown", comment: "") {
                self.labelApnName.hidden = true
            } else {
                self.labelApnName.hidden = false
                self.labelApnName.text = obj.apnProfile.attachApnName
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        myUtilCocoaHTTPServer.readLatestSavedMobileConfigProfile()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    @IBAction func tapOpenAppButton(sender: UIButton) {
        self.extensionContext?.openURL(NSURL(string: "jchankchanapnassister://")!, completionHandler: nil)
    }
}
