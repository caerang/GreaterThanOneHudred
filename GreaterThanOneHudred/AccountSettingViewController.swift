//
//  AccountSettingViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 2. 6..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit
import Firebase

class AccountSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reassign() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference()
        
        ref.observeSingleEvent(of: .value, with: { _ in
            ref.runTransactionBlock { (currentData: FIRMutableData) -> FIRTransactionResult in
                let userPostings = currentData.childData(byAppendingPath: "\(DbConsts.UserPostings)/\(uid)")
                var postingIDs:[String] = []
                for postingID in userPostings.children {
                    if let data = postingID as? FIRMutableData {
                        if let id = data.key {
                            postingIDs.append(id)
                            let posting = currentData.childData(byAppendingPath: "\(DbConsts.Postings)/\(id)")
                            posting.value = nil
                        }
                    }
                }
                userPostings.value = nil
                let followers = currentData.childData(byAppendingPath: "\(DbConsts.Followers)/\(uid)")
                for follower in followers.children {
                    if let data = follower as? FIRMutableData {
                        if let followerID = data.key {
                            for postingID in postingIDs {
                                let ret = currentData.childData(byAppendingPath: "\(DbConsts.Timelines)/\(followerID)/\(postingID)")
                                ret.value = nil
                            }
                            let myself = currentData.childData(byAppendingPath: "\(DbConsts.Timelines)/\(uid)")
                            myself.value = nil
                        }
                    }
                }
                
                return FIRTransactionResult.success(withValue: currentData)
            }
        })
    }

}
