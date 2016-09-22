//
//  ProgressIndicatorView.swift
//  ApnBookmarks
//
//  Created by WataruSuzuki on 2016/09/21.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ProgressIndicatorView: UIView {
    
    var didTapCancel:((UIButton) -> Void)?
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var cancelButton: UIButton!

    class func instanceFromNib(frame: CGRect) -> ProgressIndicatorView {
        let nib = UINib(nibName: "ProgressIndicatorView", bundle: nil)
        let view = nib.instantiateWithOwner(nil, options: nil)[0] as! ProgressIndicatorView
        
        view.frame.size.width = frame.size.width
        view.frame.size.height = frame.size.height
        
        return view
    }
    
    @IBAction func tapCancel(sender: UIButton) {
        self.didTapCancel?(sender)
    }
}
