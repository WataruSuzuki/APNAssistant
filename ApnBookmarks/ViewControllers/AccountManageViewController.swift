//
//  AccountManageViewController.swift
//  ApnBookmarks
//
//  Created by WataruSuzuki on 2016/09/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class AccountManageViewController: UITableViewController {
    
    @IBOutlet weak var signOnButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var passStr = ""
    var emailStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NSLocalizedString("account", comment: "")
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        registerCustomCell("TextFieldCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCustomCell(nibIdentifier: String) {
        let nib = UINib(nibName: nibIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: nibIdentifier)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SectionAccount.MAX.rawValue
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionAccount.Input.rawValue {
            return RowInput.MAX.rawValue
        } else {
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionAccount = SectionAccount(rawValue: indexPath.section)!
        switch sectionAccount {
        case .Input:
            return loadTextFieldCell(tableView, cellForRowAtIndexPath: indexPath)
            
        default:
            break
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountManageCell", forIndexPath: indexPath)
        cell.textLabel?.text = sectionAccount.getText()
        
        return cell
     }
    
    func loadTextFieldCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TextFieldCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell", forIndexPath: indexPath) as! TextFieldCell
        
        let rowInput = RowInput(rawValue: indexPath.row)!
        cell.myUILabel?.text = rowInput.getText()
        //cell.myUITextField.text =
        cell.myUITextField.placeholder = NSLocalizedString("no_settings", comment: "")
        
        switch rowInput {
        case .Email:
            cell.myUITextField.keyboardType = .EmailAddress
            cell.myUITextField.secureTextEntry = false
            
        case .Password:
            cell.myUITextField.keyboardType = .Default
            cell.myUITextField.secureTextEntry = true
            
        default:
            break
        }
        
        cell.didBeginEditing = {(textField) in
            //do nothing
        }
        cell.didEndEditing = {(textField) in
            self.didEndEditing(textField.text!, rowInput: rowInput)
        }
        cell.shouldChangeCharactersInRange = {(textField, range, string) in
            let newText = cell.getNewChangeCharactersInRange(textField, range: range, string: string)
            self.didEndEditing(newText, rowInput: rowInput)
            return true
        }
        
        return cell
    }
    
    func didEndEditing(text: String, rowInput: RowInput) {
        switch rowInput {
        case .Email:
            emailStr = text
            
        case .Password:
            passStr = text
            
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionAccount = SectionAccount(rawValue: indexPath.section)!
        switch sectionAccount {
        case .Input:
            let newTextFieldCell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
            return newTextFieldCell.frame.height
            
        default:
            if #available(iOS 8.0, *) {
                return tableView.rowHeight
            } else {
                return 44
            }
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    enum RowInput: Int {
        case Email = 0,
        Password,
        MAX
        
        func getText() -> String {
            return NSLocalizedString(String(self), comment: "")
        }
    }
    
    enum SectionAccount: Int {
        case Input = 0,
        SignIn,
        SignOn,
        SignOut,
        MAX
        
        func getText() -> String {
            return NSLocalizedString(String(self), comment: "")
        }
    }
}