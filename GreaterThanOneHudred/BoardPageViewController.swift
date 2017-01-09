//
//  BoardPageViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 4..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class BoardPageViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
