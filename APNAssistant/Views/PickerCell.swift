//
//  PickerCell.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2017/12/07.
//  Copyright © 2017年 WataruSuzuki. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell,
    UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var picker: UIPickerView!
    var isExpanded = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AllowedProtocolMask.max.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let menu = AllowedProtocolMask(rawValue: row) {
            if row != 0 {
                return menu.toString()
            }
        }
        return ""
    }
}
