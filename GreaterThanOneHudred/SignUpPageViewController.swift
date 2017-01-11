//
//  SignUpPageViewControl.swift
//  GreaterThanOneHudred
//
//  Created by stonecoldjuice on 2017. 1. 2..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit
import Firebase

class SignUpPageViewController : UIViewController, UITextFieldDelegate {
    let ErrorMsgRegisterFormIsNotValid = "Register form is not valid."
    let ErrorMsgEmailAddressIsBadlyFormatted = "The email address is badly formatted."
    let ErrorMsgEmailAddressIsAlreadyInUse = "The email address is already in use by another account."
    let ErrorMsgPasswordMustBeSixCharactersLongOrMore = "The password mest be 6 characters long or more."
    let ErrorMsgUserRegistrationIsFailedByUnknownIssue = "User registration is failed."
    
    @IBOutlet weak var eMailTextField: TextFieldSingleLine!
    @IBOutlet weak var passwordTextField: TextFieldSingleLine!
    @IBOutlet weak var userNameTextField: TextFieldSingleLine!
    @IBOutlet weak var nationalityTextField: TextFieldSingleLine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eMailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.userNameTextField.delegate = self
        self.nationalityTextField.delegate = self
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
        textField.resignFirstResponder()
        return true
    }
    
    func register() {
        guard let eMail = eMailTextField.text,
            let pwd = passwordTextField.text,
            let name = userNameTextField.text,
            let nationality = nationalityTextField.text else {
                return
        }
        
        guard !eMail.isEmpty && !pwd.isEmpty && !name.isEmpty && !nationality.isEmpty else {
            showErrorMessage(message: ErrorMsgRegisterFormIsNotValid)
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: eMail, password: pwd) {
            (user: FIRUser?, createUserErr) in
            
            if nil != createUserErr {
                if let errCode = FIRAuthErrorCode(rawValue: createUserErr!._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        self.showErrorMessage(message: self.ErrorMsgEmailAddressIsBadlyFormatted)
                    case .errorCodeEmailAlreadyInUse:
                        self.showErrorMessage(message: self.ErrorMsgEmailAddressIsAlreadyInUse)
                    case .errorCodeWeakPassword:
                        self.showErrorMessage(message: self.ErrorMsgPasswordMustBeSixCharactersLongOrMore)
                    default:
                        self.showErrorMessage(message: self.ErrorMsgUserRegistrationIsFailedByUnknownIssue)
                    }
                }

                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = FIRDatabase.database().reference(fromURL: "https://greaterthanonehundred.firebaseio.com/")
            let childRef = ref.child("users").child(uid)
            let values = ["eMail":eMail,"name":name,"nationality":nationality]
            
            childRef.updateChildValues(values) {
                (updateChildValueErr, ref) in
                
                if nil != updateChildValueErr {
                    print(updateChildValueErr ?? "Updating child values is failed")
                }
                
                LoginManager.sharedInstance.login(id: eMail, password: pwd) {
                    (user, error) in
                    self.performSegue(withIdentifier: "unwindFromSignUpToBoardPage", sender: self)
                }
            }
        }
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: false)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        register()
    }
    
    
}
