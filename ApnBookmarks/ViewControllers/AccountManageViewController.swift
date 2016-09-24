//
//  AccountManageViewController.swift
//  ApnBookmarks
//
//  Created by WataruSuzuki on 2016/09/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class AccountManageViewController: UITableViewController {
    
    let appStatus = UtilAppStatus()
    
    var authInfo: FIRAuth?
    var passStr = ""
    var emailStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NSLocalizedString("account", comment: "")
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        registerCustomCell("TextFieldCell")
        authInfo = FIRAuth.auth()
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
            return getSectionRowByAuthStatus(section)
        }
    }
    
    func getSectionRowByAuthStatus(section: Int) -> Int {
        let sectionAccount = SectionAccount(rawValue: section)!
        switch sectionAccount {
        case .SignOut:
            return (appStatus.checkAccountAuth() ? 1 : 0)
        case .SignOn:
            if !UtilUserDefaults().isAvailableStore {
                return 0
            }
            fallthrough
        default:
            return (appStatus.checkAccountAuth() ? 0 : 1)
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
        cell.myUITextField.placeholder = NSLocalizedString("no_settings", comment: "")
        
        switch rowInput {
        case .Email:
            cell.myUITextField.keyboardType = .EmailAddress
            cell.myUITextField.secureTextEntry = false
            cell.myUITextField.text = authInfo?.currentUser?.email
            
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionAccount = SectionAccount(rawValue: indexPath.section)!
        switch sectionAccount {
        case .SignIn:
            signIn()
        case .SignOn:
            createUser()
        case .SignOut:
            signOut()
            
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sectionAccount = SectionAccount(rawValue: section)!
        switch sectionAccount {
        case .SignOn:
            if let email = authInfo?.currentUser?.email {
                return (appStatus.checkSignInSuccess(email) ? NSLocalizedString("message_signon", comment: "") : "")
            }
            fallthrough
        default:
            return ""
        }
        
    }
    
    func showOldAlert(title: String, message: String, buttonText: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: buttonText)
        alert.show()
    }
    
    func showAlertController(message: String, errorCode: String?){
        let buttonText = "OK"
        let title = (errorCode == nil ? NSLocalizedString("confirm", comment: "") : errorCode!)
        if #available(iOS 8.0, *) {
            let okAction = UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default){
                action in
                if nil == errorCode {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            
            let alertController = UIAlertController(title: title, message: (errorCode == nil ? message : NSLocalizedString(message, comment: "")), preferredStyle: .Alert)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            showOldAlert(title, message: message, buttonText: buttonText)
        }
    }
    
    func createUser() {
        FIRAuth.auth()?.createUserWithEmail(emailStr, password: passStr, completion: { (user:FIRUser?, error:NSError?) in
            if let error = error {
                print("Creating the user failed! \(error)")
                self.handleFIRAuthError(error)
                return
            }
            
            if let user = user {
                print("user : \(user.email) has been created successfully.")
                self.appStatus.checkSignInSuccess(user.email!)
            }
        })
    }
    
    func signIn() {
        FIRAuth.auth()?.signInWithEmail(emailStr, password: passStr, completion: { (user:FIRUser?, error:NSError?) in
            if let error = error {
                print("login failed! \(error)")
                self.handleFIRAuthError(error)
                return
            }
            
            if let user = user {
                print("user : \(user.email) has been signed in successfully.")
                if self.appStatus.checkSignInSuccess(user.email!) {
                    let message = NSLocalizedString("success", comment: "") + "\n" + NSLocalizedString("please_restart_app", comment: "")
                    self.showAlertController(message, errorCode: nil)
                    return
                }
            }
            self.showAlertController(NSLocalizedString("success", comment: ""), errorCode: nil)
        })
    }
    
    func handleFIRAuthError(error: NSError) {
        if let authErrorCode = FIRAuthErrorCode(rawValue: error.code) {
            let key: String!
            switch authErrorCode {
            case FIRAuthErrorCode.ErrorCodeInvalidCustomToken:
                key = "ErrorCodeInvalidCustomToken"
            case FIRAuthErrorCode.ErrorCodeCustomTokenMismatch:
                key = "ErrorCodeCustomTokenMismatch"
            case FIRAuthErrorCode.ErrorCodeInvalidCredential:
                key = "ErrorCodeInvalidCredential"
            case FIRAuthErrorCode.ErrorCodeUserDisabled:
                key = "ErrorCodeUserDisabled"
            case FIRAuthErrorCode.ErrorCodeOperationNotAllowed:
                key = "ErrorCodeOperationNotAllowed"
            case FIRAuthErrorCode.ErrorCodeEmailAlreadyInUse:
                key = "ErrorCodeEmailAlreadyInUse"
            case FIRAuthErrorCode.ErrorCodeInvalidEmail:
                key = "ErrorCodeInvalidEmail"
            case FIRAuthErrorCode.ErrorCodeWrongPassword:
                key = "ErrorCodeWrongPassword"
            case FIRAuthErrorCode.ErrorCodeTooManyRequests:
                key = "ErrorCodeTooManyRequests"
            case FIRAuthErrorCode.ErrorCodeUserNotFound:
                key = "ErrorCodeUserNotFound"
            case FIRAuthErrorCode.ErrorCodeRequiresRecentLogin:
                key = "ErrorCodeRequiresRecentLogin"
            case FIRAuthErrorCode.ErrorCodeNoSuchProvider:
                key = "ErrorCodeNoSuchProvider"
            case FIRAuthErrorCode.ErrorCodeProviderAlreadyLinked:
                key = "ErrorCodeProviderAlreadyLinked"
            case FIRAuthErrorCode.ErrorCodeInvalidUserToken:
                key = "ErrorCodeInvalidUserToken"
            case FIRAuthErrorCode.ErrorCodeNetworkError:
                key = "ErrorCodeNetworkError"
            case FIRAuthErrorCode.ErrorCodeUserTokenExpired:
                key = "ErrorCodeUserTokenExpired"
            case FIRAuthErrorCode.ErrorCodeInvalidAPIKey:
                key = "ErrorCodeInvalidAPIKey"
            case FIRAuthErrorCode.ErrorCodeUserMismatch:
                key = "ErrorCodeUserMismatch"
            case FIRAuthErrorCode.ErrorCodeCredentialAlreadyInUse:
                key = "ErrorCodeCredentialAlreadyInUse"
            case FIRAuthErrorCode.ErrorCodeWeakPassword:
                key = "ErrorCodeWeakPassword"
            case FIRAuthErrorCode.ErrorCodeAppNotAuthorized:
                key = "ErrorCodeAppNotAuthorized"
            case FIRAuthErrorCode.ErrorCodeKeychainError:
                key = "ErrorCodeKeychainError"
            default:
                key = "ErrorCodeInternalError"
            }
            showAlertController(key, errorCode: String(error.code))
        }
    }
    
    func signOut() {
        UtilUserDefaults().isSignInSuccess = false
        do {
            try FIRAuth.auth()?.signOut()
            showAlertController(NSLocalizedString("success", comment: ""), errorCode: nil)
        } catch {
            print(error)
        }
    }
    
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
