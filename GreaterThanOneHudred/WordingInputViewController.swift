//
//  WordingInputViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 20..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class WordingInputViewController: UIViewController {
    @IBOutlet weak var wordingInputView: UIView!
    @IBOutlet weak var wordingTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.wordingTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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

    @IBAction func inputButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromInputViewToBoardPage", sender: self)
    }
}
