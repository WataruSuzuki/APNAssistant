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
    @IBOutlet weak var myTitleLabel: UILabel!
    @IBOutlet weak var myDetailField: UITextField!
    var isExpanded = false {
        didSet {
            self.myDetailField.isHidden = isExpanded
            self.picker.isHidden = !isExpanded
        }
    }
    var didSelectRow:((AllowedProtocolMask) -> Void)?

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
            return menu.toString()
        }
        return NSLocalizedString("no_settings", comment: "")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let menu = AllowedProtocolMask(rawValue: row) {
            self.myDetailField.placeholder = menu.toString()
            didSelectRow?(menu)
        }
    }
}
