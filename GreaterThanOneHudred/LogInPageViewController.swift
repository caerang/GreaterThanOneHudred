//
//  LogInPageViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 3..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit
import Firebase

class LoginPageViewController : UIViewController, UITextFieldDelegate {
    let ErrorMsgLoginIsFailed = "Login is failed"
    let ErrorMsgEmailAddressIsBadlyFormatted = "The email address is badly formatted."
    let ErrorMsgPasswordIsInvalid = "The password is invalid or the user does not have a password."
    
    @IBOutlet weak var eMailTextField: TextFieldSingleLine!
    @IBOutlet weak var passwordTextField: TextFieldSingleLine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eMailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textFieldSingleLine = textField as? UITextFieldSingleLineProtocol {
            textFieldSingleLine.didFocused()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if let textFieldSingleLine = textField as? UITextFieldSingleLineProtocol {
            textFieldSingleLine.didFocusReleased()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.eMailTextField == textField {
            self.passwordTextField.becomeFirstResponder()
        } else if self.passwordTextField == textField {
            self.beginLogin()
        }
        return true
    }
    
    func beginLogin() {
        if let eMail = self.eMailTextField.text, let pwd = self.passwordTextField.text {
            LoginManager.sharedInstance.login(id: eMail, password: pwd) {
                (user, error) in
                
                if nil != error {
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .errorCodeInvalidEmail:
                            self.showErrorMessage(message: self.ErrorMsgEmailAddressIsBadlyFormatted)
                        case .errorCodeWrongPassword:
                            self.showErrorMessage(message: self.ErrorMsgPasswordIsInvalid)
                        default:
                            self.showErrorMessage(message: self.ErrorMsgLoginIsFailed)
                        }
                    }
                    
                    return
                }
                
                if LoginManager.sharedInstance.saveLoginInfo(id: eMail, password: pwd) {
                    self.windToBoardPage()
                }
            }
        }
    }
    
    func windToBoardPage() {
        performSegue(withIdentifier: "unwindFromLoginToBoardPage", sender: self)
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: false)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        beginLogin()
    }

    @IBAction func unwindToLoginPage(_ segue: UIStoryboardSegue) {
        
    }
}
