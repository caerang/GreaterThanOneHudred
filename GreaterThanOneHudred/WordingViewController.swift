//
//  WordingViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 16..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class WordingViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    let inputWordingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let wordingTextField: UITextView = {
        let ui = UITextView()
        ui.textColor = UIColor.white
        ui.font = .systemFont(ofSize: 18.0)
        ui.backgroundColor = UIColor.gray
        ui.translatesAutoresizingMaskIntoConstraints = false
        return ui
    }()
    
    var inputWordingViewBottomAnchor: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let isSucceed = LoginManager.sharedInstance.loginWithExistingKey {
            (user, error) in
            
            if nil != error {
                self.performSegue(withIdentifier: "windToTitlePage", sender: self)
            }
        }
        
        if !isSucceed {
            LoginManager.sharedInstance.removeLoginInfo()
            perform(#selector(unwindToTitlePage), with: self, afterDelay: 0)
        }
        
        let myWordingViewController = MyWordingViewController(nibName: "MyWordingViewController", bundle: nil)
        self.addChildViewController(myWordingViewController)
        self.scrollView.addSubview(myWordingViewController.view)
        myWordingViewController.didMove(toParentViewController: self)
        
        let sharedViewController = SharedWordingViewController(nibName: "SharedWordingViewController", bundle: nil)
        var frameSharedView = sharedViewController.view.frame
        frameSharedView.origin.x = self.view.frame.size.width
        sharedViewController.view.frame = frameSharedView
        self.addChildViewController(sharedViewController)
        self.scrollView.addSubview(sharedViewController.view)
        sharedViewController.didMove(toParentViewController: self)
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width * 2, height: self.view.frame.height - 66)
        
        setupInputTextView()
        setupKeyboardObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func unwindToTitlePage() {
        performSegue(withIdentifier: "windToTitlePage", sender: self)
    }
    
    func setupInputTextView() {
        self.view.addSubview(self.inputWordingView)
        self.inputWordingView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.inputWordingView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.inputWordingViewBottomAnchor = inputWordingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.inputWordingViewBottomAnchor?.isActive = true
        self.inputWordingView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        self.inputWordingView.isHidden = true
        
        self.inputWordingView.addSubview(wordingTextField)
        wordingTextField.leftAnchor.constraint(equalTo: self.inputWordingView.leftAnchor, constant: 40.0).isActive = true
        wordingTextField.rightAnchor.constraint(equalTo: self.inputWordingView.rightAnchor, constant: -30.0).isActive = true
        wordingTextField.topAnchor.constraint(equalTo: self.inputWordingView.topAnchor, constant: 20.0).isActive = true
        wordingTextField.bottomAnchor.constraint(equalTo: self.inputWordingView.bottomAnchor, constant: -80.0).isActive = true
        
        let cancelBtn: UIButton = {
            let ui = UIButton()
            ui.backgroundColor = UIColor.white
            ui.translatesAutoresizingMaskIntoConstraints = false
            return ui
        }()
        
        self.inputWordingView.addSubview(cancelBtn)
        cancelBtn.rightAnchor.constraint(equalTo: self.inputWordingView.rightAnchor, constant: -20.0).isActive = true
        cancelBtn.bottomAnchor.constraint(equalTo: self.inputWordingView.bottomAnchor, constant: -20.0).isActive = true
        cancelBtn.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        cancelBtn.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        cancelBtn.addTarget(self, action: #selector(handleCancelInputWording), for: .touchUpInside)
    }
    
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(noti: Notification) {
        let keyboardFrame = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        self.inputWordingViewBottomAnchor?.constant = -keyboardFrame!.height
    }
    
    func handleKeyboardWillHide(noti: Notification) {
        self.inputWordingViewBottomAnchor?.constant = 0.0
    }
    
    func handleCancelInputWording() {
        self.inputWordingView.isHidden = true
        self.wordingTextField.resignFirstResponder()
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        LoginManager.sharedInstance.logout()
        performSegue(withIdentifier: "windToTitlePage", sender: self)
    }
    
    @IBAction func unwindToBoardPage(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func addBtnTabbed(_ sender: Any) {
        inputWordingView.isHidden = false
        self.wordingTextField.becomeFirstResponder()
    }
}
