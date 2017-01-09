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
    let ErrorMsgLoginIsFailed = "Sending email is failed"
    let ErrorMsgEmailAddressIsBadlyFormatted = "The email address is badly formatted."
    
    @IBOutlet weak var eMailTextField: UITextFieldSingleLine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        self.showErrorMessage(message: self.ErrorMsgEmailAddressIsBadlyFormatted)
                    default:
                        self.showErrorMessage(message: self.ErrorMsgLoginIsFailed)
                    }
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
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        sendResetPasswordEmail()
    }
}
