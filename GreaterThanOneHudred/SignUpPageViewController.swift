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
        
        FIRAuth.auth()?.createUser(withEmail: eMail, password: pwd) { (user: FIRUser?, createUserErr) in
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
            let updatedData = ["\(DbConsts.Users)/\(uid)":["eMail":eMail,"name":name,"nationality":nationality]]
            
            ref.updateChildValues(updatedData) { (updateChildValueErr, ref) in
                if nil != updateChildValueErr {
                    print(updateChildValueErr ?? "Updating child values is failed")
                }
                
                LoginManager.sharedInstance.login(id: eMail, password: pwd) { (user, error) in
                    self.makeFollowers {
                        self.performSegue(withIdentifier: "unwindFromSignUpToBoardPage", sender: self)
                    }
                }
            }
        }
    }
    
    func makeFollowers(completion: @escaping () -> ()) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("\(DbConsts.Users)")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var users: [String] = []
            for userChild in snapshot.children {
                if let user = userChild as? FIRDataSnapshot {
                    users.append(user.key)
                }
            }
            var updatedData: [String:Any] = [:]
            for user in users {
                if uid == user {
                    for follower in users {
                        if user != follower {
                            updatedData["\(DbConsts.Followers)/\(user)/\(follower)"] = true
                        }
                    }
                }
                else {
                    updatedData["\(DbConsts.Followers)/\(user)/\(uid)"] = true
                }
            }
            
            let ref = FIRDatabase.database().reference()
            
            ref.updateChildValues(updatedData, withCompletionBlock: { (error, ref) in
                completion()
            })
        })
        
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
