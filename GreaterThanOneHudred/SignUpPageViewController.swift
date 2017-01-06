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
    @IBOutlet weak var eMailTextField: UITextFieldSingleLine!
    @IBOutlet weak var passwordTextField: UITextFieldSingleLine!
    @IBOutlet weak var userNameTextField: UITextFieldSingleLine!
    @IBOutlet weak var nationalityTextField: UITextFieldSingleLine!
    
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
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: eMail, password: pwd) {
            (user: FIRUser?, createUserErr) in
            
            if nil != createUserErr {
                print(createUserErr ?? "Creating user is failed")
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
            }
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        register()
    }
    
    
}
