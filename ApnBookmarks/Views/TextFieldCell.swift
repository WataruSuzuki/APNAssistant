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
        
        myUITextField.returnKeyType = .Next
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
        var searchedView = self.superview
        var tableView: UITableView? = nil
        
        while ((searchedView) != nil) {
            if searchedView!.isKindOfClass(UITableView) {
                tableView = searchedView as? UITableView
                break
            }
            searchedView = searchedView!.superview
        }
        
        if nil != tableView {
            let indexPath = tableView?.indexPathForCell(self)
            let nextIndexPath = NSIndexPath(forRow: (indexPath?.row)! + 1, inSection: (indexPath?.section)!)
            if !becomeCellTextFieldResponder(tableView!, nextIndexPath: nextIndexPath) {
                let section = (indexPath?.section)! + 1
                let fallbackIndexPath = NSIndexPath(forRow: (indexPath?.section)!, inSection: section)
                if !becomeCellTextFieldResponder(tableView!, nextIndexPath: fallbackIndexPath) {
                    print("Not found next target myUITextField...")
                }
            }
        }
        
        return true
    }
    
    func becomeCellTextFieldResponder(tableView: UITableView, nextIndexPath: NSIndexPath) -> Bool {
        if let nextCell = tableView.cellForRowAtIndexPath(nextIndexPath) as? TextFieldCell {
            nextCell.myUITextField.becomeFirstResponder()
            return true
        } else {
            return false
        }
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
