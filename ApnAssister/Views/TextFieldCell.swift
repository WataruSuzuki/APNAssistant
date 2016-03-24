//
//  TextFieldCell.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate {
    func textFieldCellShouldBeginEditing(sender: UITextField) -> Bool
    func textFieldCellShouldEndEditing(sender: UITextField) -> Bool
    func textFieldCellShouldClear(sender: UITextField) -> Bool
    func textFieldCellShouldReturn(sender: UITextField) -> Bool
    func textFieldCellDidBeginEditing(sender: UITextField)
    func textFieldCellDidEndEditing(sender: UITextField)
    func textFieldCellShouldChangeCharactersInRange(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
}

class TextFieldCell: UITableViewCell,
    UITextFieldDelegate
{

    @IBOutlet weak var myUILabel: UILabel!
    @IBOutlet weak var myUITextField: UITextField!
    
    var delegate: TextFieldCellDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return self.delegate.textFieldCellShouldBeginEditing(textField)
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return self.delegate.textFieldCellShouldEndEditing(textField)
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return self.delegate.textFieldCellShouldClear(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return self.delegate.textFieldCellShouldReturn(textField)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate.textFieldCellShouldEndEditing(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.delegate.textFieldCellDidEndEditing(textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return self.delegate.textFieldCellShouldChangeCharactersInRange(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
}
