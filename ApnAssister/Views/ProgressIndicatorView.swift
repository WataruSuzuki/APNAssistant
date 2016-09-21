//
//  ProgressIndicatorView.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/09/21.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ProgressIndicatorView: UIView {
    
    @IBOutlet weak var progressBar: UIProgressView!

    class func instanceFromNib(frame: CGRect) -> ProgressIndicatorView {
        let nib = UINib(nibName: "ProgressIndicatorView", bundle: nil)
        let view = nib.instantiateWithOwner(nil, options: nil)[0] as! ProgressIndicatorView
        
        view.frame.size.width = frame.size.width
        view.frame.size.height = frame.size.height
        
        return view
    }
}
