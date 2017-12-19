//
//  TextFieldCell.swift
//  APNAssistant
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
        
        myUITextField.returnKeyType = .next
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var searchedView = self.superview
        var tableView: UITableView? = nil
        
        while ((searchedView) != nil) {
            if searchedView!.isKind(of: UITableView.self) {
                tableView = searchedView as? UITableView
                break
            }
            searchedView = searchedView!.superview
        }
        
        if nil != tableView {
            let indexPath = tableView?.indexPath(for: self)
            let nextIndexPath = IndexPath(row: ((indexPath as NSIndexPath?)?.row)! + 1, section: ((indexPath as NSIndexPath?)?.section)!)
            if !becomeCellTextFieldResponder(tableView!, nextIndexPath: nextIndexPath) {
                let section = ((indexPath as NSIndexPath?)?.section)! + 1
                let fallbackIndexPath = IndexPath(row: ((indexPath as NSIndexPath?)?.section)!, section: section)
                if !becomeCellTextFieldResponder(tableView!, nextIndexPath: fallbackIndexPath) {
                    print("Not found next target myUITextField...")
                }
            }
        }
        
        return true
    }
    
    func becomeCellTextFieldResponder(_ tableView: UITableView, nextIndexPath: IndexPath) -> Bool {
        if let nextCell = tableView.cellForRow(at: nextIndexPath) as? TextFieldCell {
            nextCell.myUITextField.becomeFirstResponder()
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.didBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.didEndEditing?(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (self.shouldChangeCharactersInRange?(textField, range, string))!
    }
    
    func getNewChangeCharactersInRange(_ textField: UITextField, range: NSRange, string: String) -> String {
        let toIndex = textField.text!.index(textField.text!.startIndex, offsetBy: range.location)
        let newText = (string.isEmpty
            ? String(textField.text![..<toIndex])
            : String(textField.text![..<toIndex]) + string
        )
        return newText
    }
}
