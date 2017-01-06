//
//  RequestUserInfoPageViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 6..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit
import Firebase

class RequestUserInfoPageViewController : UIViewController, UITextFieldDelegate {
    @IBOutlet weak var eMailTextField: UITextFieldSingleLine!
    
    override func viewDidLoad() {
        eMailTextField.delegate = self
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
        sendResetPasswordEmail()
        dismiss(animated: true, completion: nil)
        return true
    }
    
    func sendResetPasswordEmail() {
        guard let eMail = eMailTextField.text else {
            return
        }
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: eMail) {
            (error) in
            
            if nil != error {
                print(error ?? "Sending password reset mail is failed")
            }
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        sendResetPasswordEmail()
    }
}
