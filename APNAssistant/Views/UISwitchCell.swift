//
//  UISwitchCell.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UISwitchCell: UITableViewCell {
    
    @IBOutlet weak var myUILabel: UILabel!
    @IBOutlet weak var myUISwitch: UISwitch!
    
    var switchValueChanged:((Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    func setTextIdentifier(_ id: String) {
        myUILabel.text = NSLocalizedString(id, comment: "")
        myUISwitch.accessibilityIdentifier = id
    }

    // MARK: - Action
    @IBAction func changeSwitch(_ sender: UISwitch) {
        self.switchValueChanged?(sender.isOn)
    }
}
