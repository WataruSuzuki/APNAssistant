//
//  AccountManageViewController.swift
//  ApnAssister
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
    
    func registerCustomCell(_ nibIdentifier: String) {
        let nib = UINib(nibName: nibIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: nibIdentifier)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionAccount.max.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionAccount.input.rawValue {
            return RowInput.max.rawValue
        } else {
            return getSectionRowByAuthStatus(section)
        }
    }
    
    func getSectionRowByAuthStatus(_ section: Int) -> Int {
        let sectionAccount = SectionAccount(rawValue: section)!
        switch sectionAccount {
        case .signOut:
            return (appStatus.checkAccountAuth() ? 1 : 0)
        case .signOn:
            if !UtilUserDefaults().isAvailableStore {
                return 0
            }
            fallthrough
        default:
            return (appStatus.checkAccountAuth() ? 0 : 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionAccount = SectionAccount(rawValue: indexPath.section)!
        switch sectionAccount {
        case .input:
            return loadTextFieldCell(tableView, cellForRowAtIndexPath: indexPath)
            
        default:
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountManageCell", for: indexPath)
        cell.textLabel?.text = sectionAccount.getText()
        
        return cell
     }
    
    func loadTextFieldCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> TextFieldCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
        
        let rowInput = RowInput(rawValue: indexPath.row)!
        cell.myUILabel?.text = rowInput.getText()
        cell.myUITextField.placeholder = NSLocalizedString("no_settings", comment: "")
        
        switch rowInput {
        case .email:
            cell.myUITextField.keyboardType = .emailAddress
            cell.myUITextField.isSecureTextEntry = false
            cell.myUITextField.text = authInfo?.currentUser?.email
            
        case .password:
            cell.myUITextField.keyboardType = .default
            cell.myUITextField.isSecureTextEntry = true
            
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
    
    func didEndEditing(_ text: String, rowInput: RowInput) {
        switch rowInput {
        case .email:
            emailStr = text
            
        case .password:
            passStr = text
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionAccount = SectionAccount(rawValue: indexPath.section)!
        switch sectionAccount {
        case .input:
            let newTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            return newTextFieldCell.frame.height
            
        default:
            if #available(iOS 8.0, *) {
                return tableView.rowHeight
            } else {
                return 44
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionAccount = SectionAccount(rawValue: indexPath.section)!
        switch sectionAccount {
        case .signIn:
            signIn()
        case .signOn:
            createUser()
        case .signOut:
            signOut()
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sectionAccount = SectionAccount(rawValue: section)!
        switch sectionAccount {
        case .signOn:
            if let email = authInfo?.currentUser?.email {
                appStatus.checkSignInSuccess(email)
                if appStatus.isAvailableAllFunction() {
                    return NSLocalizedString("message_signon", comment: "")
                }
            }
            fallthrough
        default:
            return ""
        }
        
    }
    
    func showCompOldAlert(_ title: String, message: String, buttonText: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: buttonText)
        alert.show()
    }
    
    func showCompAlertController(_ message: String, errorCode: String?){
        let buttonText = "OK"
        let title = (errorCode == nil ? NSLocalizedString("confirm", comment: "") : errorCode!)
        if #available(iOS 8.0, *) {
            let okAction = UIAlertAction(title: buttonText, style: UIAlertActionStyle.default){
                action in
                if nil == errorCode {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            let alertController = UIAlertController(title: title, message: (errorCode == nil ? message : NSLocalizedString(message, comment: "")), preferredStyle: .alert)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            showCompOldAlert(title, message: message, buttonText: buttonText)
        }
    }
    
    func createUser() {
        FIRAuth.auth()?.createUser(withEmail: emailStr, password: passStr, completion: { (user, error) in
            if let error = error {
                print("Creating the user failed! \(error)")
                self.handleFIRAuthError(error as NSError)
                return
            }
            
            if let user = user {
                print("user : \(user.email) has been created successfully.")
                self.appStatus.checkSignInSuccess(user.email!)
            }
        })
    }
    
    func signIn() {
        FIRAuth.auth()?.signIn(withEmail: emailStr, password: passStr, completion: { (user, error) in
            if let error = error {
                print("login failed! \(error)")
                self.handleFIRAuthError(error as NSError)
                return
            }
            
            if let user = user {
                print("user : \(user.email) has been signed in successfully.")
                if self.appStatus.checkSignInSuccess(user.email!) {
                    let message = NSLocalizedString("success", comment: "") + "\n" + NSLocalizedString("please_restart_app", comment: "")
                    self.showCompAlertController(message, errorCode: nil)
                    return
                }
            }
            self.showCompAlertController(NSLocalizedString("success", comment: ""), errorCode: nil)
        })
    }
    
    func handleFIRAuthError(_ error: NSError) {
        if let authErrorCode = FIRAuthErrorCode(rawValue: error.code) {
            let key: String!
            switch authErrorCode {
            case FIRAuthErrorCode.errorCodeInvalidCustomToken:
                key = "ErrorCodeInvalidCustomToken"
            case FIRAuthErrorCode.errorCodeCustomTokenMismatch:
                key = "ErrorCodeCustomTokenMismatch"
            case FIRAuthErrorCode.errorCodeInvalidCredential:
                key = "ErrorCodeInvalidCredential"
            case FIRAuthErrorCode.errorCodeUserDisabled:
                key = "ErrorCodeUserDisabled"
            case FIRAuthErrorCode.errorCodeOperationNotAllowed:
                key = "ErrorCodeOperationNotAllowed"
            case FIRAuthErrorCode.errorCodeEmailAlreadyInUse:
                key = "ErrorCodeEmailAlreadyInUse"
            case FIRAuthErrorCode.errorCodeInvalidEmail:
                key = "ErrorCodeInvalidEmail"
            case FIRAuthErrorCode.errorCodeWrongPassword:
                key = "ErrorCodeWrongPassword"
            case FIRAuthErrorCode.errorCodeTooManyRequests:
                key = "ErrorCodeTooManyRequests"
            case FIRAuthErrorCode.errorCodeUserNotFound:
                key = "ErrorCodeUserNotFound"
            case FIRAuthErrorCode.errorCodeRequiresRecentLogin:
                key = "ErrorCodeRequiresRecentLogin"
            case FIRAuthErrorCode.errorCodeNoSuchProvider:
                key = "ErrorCodeNoSuchProvider"
            case FIRAuthErrorCode.errorCodeProviderAlreadyLinked:
                key = "ErrorCodeProviderAlreadyLinked"
            case FIRAuthErrorCode.errorCodeInvalidUserToken:
                key = "ErrorCodeInvalidUserToken"
            case FIRAuthErrorCode.errorCodeNetworkError:
                key = "ErrorCodeNetworkError"
            case FIRAuthErrorCode.errorCodeUserTokenExpired:
                key = "ErrorCodeUserTokenExpired"
            case FIRAuthErrorCode.errorCodeInvalidAPIKey:
                key = "ErrorCodeInvalidAPIKey"
            case FIRAuthErrorCode.errorCodeUserMismatch:
                key = "ErrorCodeUserMismatch"
            case FIRAuthErrorCode.errorCodeCredentialAlreadyInUse:
                key = "ErrorCodeCredentialAlreadyInUse"
            case FIRAuthErrorCode.errorCodeWeakPassword:
                key = "ErrorCodeWeakPassword"
            case FIRAuthErrorCode.errorCodeAppNotAuthorized:
                key = "ErrorCodeAppNotAuthorized"
            case FIRAuthErrorCode.errorCodeKeychainError:
                key = "ErrorCodeKeychainError"
            default:
                key = "ErrorCodeInternalError"
            }
            showCompAlertController(key, errorCode: String(error.code))
        }
    }
    
    func signOut() {
        UtilUserDefaults().isSignInSuccess = false
        do {
            try FIRAuth.auth()?.signOut()
            showCompAlertController(NSLocalizedString("success", comment: ""), errorCode: nil)
        } catch {
            print(error)
        }
    }
    
    enum RowInput: Int {
        case email = 0,
        password,
        max
        
        func getText() -> String {
            return NSLocalizedString(String(describing: self), comment: "")
        }
    }
    
    enum SectionAccount: Int {
        case input = 0,
        signIn,
        signOn,
        signOut,
        max
        
        func getText() -> String {
            return NSLocalizedString(String(describing: self), comment: "")
        }
    }
}
