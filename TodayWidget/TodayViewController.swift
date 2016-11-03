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
    @IBOutlet weak var buttonOpenApp: UIButton!
    
    let myUtilCocoaHTTPServer = UtilCocoaHTTPServer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        labelTitle.text = NSLocalizedString("latest_set_profile", comment: "")
        buttonOpenApp.setTitle(NSLocalizedString("openApp", comment: ""), for: UIControlState())
        
        myUtilCocoaHTTPServer.didEndParse = {(parse, obj) in
            self.labelProfileName.text = obj.name
            if obj.name == NSLocalizedString("unknown", comment: "") {
                self.labelApnName.isHidden = true
            } else {
                self.labelApnName.isHidden = false
                self.labelApnName.text = obj.apnProfile.attachApnName
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myUtilCocoaHTTPServer.readLatestSavedMobileConfigProfile()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func tapOpenAppButton(_ sender: UIButton) {
        self.extensionContext?.open(URL(string: "jchankchanapnassistant://")!, completionHandler: nil)
    }
}
