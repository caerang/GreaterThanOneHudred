//
//  WordingPageViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 19..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class WordingPageViewController: UIPageViewController, UIScrollViewDelegate {
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
    
    var orderedViewControllers: [UIViewController] = {
        return [MyWordingViewController(nibName: "MyWordingViewController", bundle: nil),
                SharedWordingViewController(nibName: "SharedWordingViewController", bundle: nil)]
    }()
    
    var myIsFirstTimeViewAppeared = true
    
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
        
        for view in self.view.subviews {
            if let view = view as? UIScrollView {
                view.delegate = self
                break
            }
        }
        
        setupSubViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.myIsFirstTimeViewAppeared {
            for vc in self.orderedViewControllers {
                if let fvp = vc as? FeedViewProtocol {
                    fvp.resetView()
                }
            }
        }
        else {
            self.myIsFirstTimeViewAppeared = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.addButton.isHidden = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.addButton.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func unwindToTitlePage() {
        for vc in self.orderedViewControllers {
            if let fvp = vc as? FeedViewProtocol {
                fvp.viewDidUnloaded()
            }
        }
        performSegue(withIdentifier: "windToTitlePage", sender: self)
    }
    
    func setupSubViews() {
        self.view.addSubview(self.logoutButton)
        self.logoutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        self.logoutButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        self.logoutButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.logoutButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        self.logoutButton.addTarget(self, action: #selector(handleLogoutButton), for: .touchUpInside)
        
        self.view.addSubview(self.addButton)
        self.addButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        self.addButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10.0).isActive = true
        self.addButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        self.addButton.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        self.addButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
    }
    
    func handleLogoutButton() {
        LoginManager.sharedInstance.logout()
        unwindToTitlePage()
    }
    
    func handleAddButton() {
        performSegue(withIdentifier: "windToWordingInput", sender: self)
    }
    
    @IBAction func unwindToBoardPage(_ segue: UIStoryboardSegue) {
        
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
//            return nil // 좌측 끝으로 이동한 경우 더이상 이동하지 못하도록 하고 싶을때 아래 문장을 주석처리 한다.
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
//            return nil // 우측 끝으로 이동한 경우 더이상 이동하지 못하도록 하고 싶을때 아래 문장을 주석처리 한다.
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
