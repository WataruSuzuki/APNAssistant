//
//  MsgNoDataView.swift
//  ApnAssister2
//
//  Created by WataruSuzuki on 2016/10/03.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class MsgNoDataView: UIView {
    
    @IBOutlet weak var labelMsgNoData: UILabel!

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    class func instanceFromNib(_ frame: CGRect) -> MsgNoDataView {
        let nib = UINib(nibName: "MsgNoDataView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! MsgNoDataView
        
        view.frame.size.width = frame.size.width
        view.frame.size.height = frame.size.height
        
        return view
    }
}
