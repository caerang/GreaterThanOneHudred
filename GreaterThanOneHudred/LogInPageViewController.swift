//
//  LogInPageViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 3..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class LoginPageViewController : UIViewController, UITextFieldDelegate {
    @IBOutlet weak var eMailTextField: UITextFieldSingleLine!
    @IBOutlet weak var passwordTextField: UITextFieldSingleLine!
    
    override func viewDidLoad() {
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
            if let eMail = self.eMailTextField.text, let pwd = self.passwordTextField.text {
                if login(id: eMail, password: pwd) {
                    windToBoardPage()
                }
            }
        }
        return true
    }
    
    func login(id: String, password: String) -> Bool {
        return true
    }
    
    func windToBoardPage() {
        self.performSegue(withIdentifier: "WindToBoardPage", sender: self)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        windToBoardPage()
    }

}
