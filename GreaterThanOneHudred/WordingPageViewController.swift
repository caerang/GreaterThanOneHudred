//
//  WordingPageViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 19..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class WordingPageViewController: UIPageViewController {
    let logoutButton: UIButton = {
        let view = UIButton(type: UIButtonType.system)
        view.setTitle("Log out", for: .normal)
        view.setTitleColor(UIColor.init(white: 1.0, alpha: 0.5), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentHorizontalAlignment = .right
        return view
    }()
    
    let addButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "add"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    var orderedViewControllers: [UIViewController] = {
        return [MyWordingViewController(nibName: "MyWordingViewController", bundle: nil),
                SharedWordingViewController(nibName: "SharedWordingViewController", bundle: nil)]
    }()
    
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
        
        self.dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        setupSubViews()
        setupKeyboardObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func unwindToTitlePage() {
        performSegue(withIdentifier: "windToTitlePage", sender: self)
    }
    
    func setupSubViews() {
        self.view.addSubview(self.logoutButton)
        self.logoutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        self.logoutButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        self.logoutButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.logoutButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        self.view.addSubview(self.addButton)
        self.addButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        self.addButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10.0).isActive = true
        self.addButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        self.addButton.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        self.addButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
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
    
    func handleAddButton() {
        inputWordingView.isHidden = false
        self.wordingTextField.becomeFirstResponder()
    }
}

extension WordingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
//            return nil // 좌측 끝으로 이동한 경우 더이상 이동하지 못하도록
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
//            return nil // 우측 끝으로 이동한 경우 더이상 이동하지 못하도록
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
