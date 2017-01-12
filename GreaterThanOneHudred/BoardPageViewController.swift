//
//  BoardPageViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 4..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class BoardPageViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var memoTableView: UITableView!
    
    let NumOfRows = 3
    let MemoColors = [UIColor(red: 222.0/255.0, green: 30.0/255.0, blue: 16.0/255.0, alpha: 1.0),
                      UIColor(red: 238.0/255.0, green: 88.0/255.0, blue: 63.0/255.0, alpha: 1.0)]
    let TableRowHeight: Float = 250.0
    
    var tableTotalRowNumber: Int = 3
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableTotalRowNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell") as? MemoTableViewCell

        cell?.backgroundColor = self.MemoColors[indexPath.row % self.MemoColors.count]
        
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.TableRowHeight)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            tableTotalRowNumber += 3
            memoTableView.reloadData()
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        LoginManager.sharedInstance.logout()
        performSegue(withIdentifier: "windToTitlePage", sender: self)
    }
    
    @IBAction func unwindToBoardPage(_ segue: UIStoryboardSegue) {
        
    }
}
