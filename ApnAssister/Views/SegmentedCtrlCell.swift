//
//  SegmentedCtrlCell.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/08/18.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class SegmentedCtrlCell: UITableViewCell {

    @IBOutlet weak var myUILabel: UILabel!
    @IBOutlet weak var myUISegmentedControl: UISegmentedControl!
    
    var didChangeValue:((UISegmentedControl) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeSegmentedCtrl(_ sender: UISegmentedControl) {
        self.didChangeValue?(sender)
    }
    
    enum SegmentAuthType: Int {
        case chap = 0,
        pap
        
        init(type: String) {
            switch type {
            case SegmentAuthType.pap.toString():  self = .pap
            case SegmentAuthType.chap.toString(): fallthrough
            default:
                self = .chap
            }
        }
        
        func toString() -> String {
            return String(describing: self)
        }
    }
}
