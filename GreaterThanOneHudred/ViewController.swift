//
//  ViewController.swift
//  GreaterThanOneHudred
//
//  Created by stonecoldjuice on 2016. 12. 19..
//  Copyright © 2016년 dreamFactory. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if LoginManager.sharedInstance.loginWithExistingKey() {
            perform(#selector(windToBoardPage), with: nil, afterDelay: 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func windToBoardPage() {
        performSegue(withIdentifier: "windFromMainToBoard", sender: self)
    }
    
    @IBAction func unwindToMainPage(_ segue: UIStoryboardSegue) {
        
    }
}

