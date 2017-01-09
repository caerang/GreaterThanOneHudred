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
    @IBOutlet weak var eMailTextField: UITextFieldSingleLine!
    @IBOutlet weak var passwordTextField: UITextFieldSingleLine!
    
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
                
                if nil == error {
                    if LoginManager.sharedInstance.saveLoginInfo(id: eMail, password: pwd) {
                        self.windToBoardPage()
                    }
                }
            }
        }
    }
    
    func windToBoardPage() {
        //self.performSegue(withIdentifier: "windFromLoginToBoardPage", sender: self)
        performSegue(withIdentifier: "unwindFromLoginToBoardPage", sender: self)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        beginLogin()
    }

    @IBAction func unwindToLoginPage(_ segue: UIStoryboardSegue) {
        
    }
}
