//
//  WordingInputViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 20..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit
import Firebase

class WordingInputViewController: UIViewController {
    @IBOutlet weak var wordingInputView: UIView!
    @IBOutlet weak var wordingTextField: UITextView!
    @IBOutlet weak var yesShareButton: UIButton!
    @IBOutlet weak var noShareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.wordingTextField.becomeFirstResponder()
        toggleButton(self.noShareButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(noti: Notification) {
        let keyboardFrame = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        self.wordingInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(keyboardFrame?.height)!).isActive = true
    }
    
    func handleKeyboardWillHide(noti: Notification) {
        self.wordingInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    }

    func toggleButton(_ sender: Any) {
        if let button = sender as? UIButton {
            button.isSelected = !button.isSelected
            if button.isSelected {
                button.setTitleColor(UIColor.init(white: 1.0, alpha: 1.0), for: .normal)
            }
            else {
                button.setTitleColor(UIColor.init(white: 1.0, alpha: 0.5), for: .normal)
            }
        }
    }
    
    func writeWording() {
        let wordings = FIRDatabase.database().reference().child("wordings")
        let child = wordings.childByAutoId()
        
        guard let wording = wordingTextField.text,
            let user = FIRAuth.auth()?.currentUser?.uid else {
                return
        }
        
        let timestamp = NSNumber(value: Date().timeIntervalSince1970)
        let kv: [String: Any] = ["text": wording, "user": user, "timestamp": timestamp]
        child.updateChildValues(kv)
    }
    
    @IBAction func inputButtonPressed(_ sender: Any) {
        writeWording()
        performSegue(withIdentifier: "unwindFromInputViewToBoardPage", sender: self)
    }
    
    @IBAction func shareYesButtonPressed(_ sender: Any) {
        toggleButton(self.yesShareButton)
        toggleButton(self.noShareButton)
    }
    
    @IBAction func shareNoButtonPressed(_ sender: Any) {
        toggleButton(self.yesShareButton)
        toggleButton(self.noShareButton)
    }
}
