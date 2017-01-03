//
//  SignUpPageViewControl.swift
//  GreaterThanOneHudred
//
//  Created by stonecoldjuice on 2017. 1. 2..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class SignUpPageViewController : UIViewController, UITextFieldDelegate {
    @IBOutlet weak var eMailTextField: UITextFieldSingleLine!
    @IBOutlet weak var passwordTextField: UITextFieldSingleLine!
    @IBOutlet weak var userNameTextField: UITextFieldSingleLine!
    @IBOutlet weak var nationalityTextField: UITextFieldSingleLine!
    
    override func viewDidLoad() {
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
}
