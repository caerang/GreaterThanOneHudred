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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func unwindToTitlePage() {
        performSegue(withIdentifier: "windToTitlePage", sender: self)
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        LoginManager.sharedInstance.logout()
        performSegue(withIdentifier: "windToTitlePage", sender: self)
    }
    
    @IBAction func unwindToBoardPage(_ segue: UIStoryboardSegue) {
        
    }
}
