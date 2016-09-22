//
//  EasyInfoViewController.swift
//  ApnBookmarks
//
//  Created by WataruSuzuki on 2016/09/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class EasyInfoViewController: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var infoButton: UIButton!
    
    var nextUrl: NSURL!
    var message = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        infoTextView.text = message
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @IBAction func tapInfoButton() {
        UIApplication.sharedApplication().openURL(nextUrl)
    }
}
