//
//  SegmentedCtrlCell.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/09/23.
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeSegmentedCtrl(sender: UISegmentedControl) {
        self.didChangeValue?(sender)
    }
    
    enum SegmentAuthType: Int {
        case CHAP = 0,
        PAP
        
        init(type: String) {
            switch type {
            case PAP.toString():  self = .PAP
            case CHAP.toString(): fallthrough
            default:
                self = .CHAP
            }
        }
        
        func toString() -> String {
            return String(self)
        }
    }
}
