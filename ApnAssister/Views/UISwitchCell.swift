//
//  UISwitchCell.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

protocol UISwitchCellDelegate {
    func changeMyUiSwitch(sender: UISwitch)
}

class UISwitchCell: UITableViewCell {
    
    @IBOutlet weak var myUILabel: UILabel!
    @IBOutlet weak var myUISwitch: UISwitch!
    
    var delegate: UISwitchCellDelegate! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Action
    @IBAction func changeSwitch(sender: UISwitch) {
        self.delegate.changeMyUiSwitch(sender)
    }
}
