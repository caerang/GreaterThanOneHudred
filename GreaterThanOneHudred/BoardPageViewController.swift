//
//  BoardPageViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 4..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class BoardPageViewController : UIViewController {
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        LoginInfoManager.sharedInstance.removeLoginInfo()
    }
}
