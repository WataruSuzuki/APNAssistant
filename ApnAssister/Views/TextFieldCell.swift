//
//  TextFieldCell.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/03/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell,
    UITextFieldDelegate
{

    @IBOutlet weak var myUILabel: UILabel!
    @IBOutlet weak var myUITextField: UITextField!
    
    var didBeginEditing:((UITextField) -> Void)?
    var didEndEditing:((UITextField) -> Void)?
    var shouldChangeCharactersInRange:((UITextField, NSRange, String) -> Bool)?
    
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
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.didBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.didEndEditing?(textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return (self.shouldChangeCharactersInRange?(textField, range, string))!
    }
}
