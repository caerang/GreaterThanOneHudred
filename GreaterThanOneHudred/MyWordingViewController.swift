//
//  MyWordingViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 16..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit
import Firebase

class MyWordingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var wordingTableView: UITableView!
    
    let NumOfRows = 3
    let WordingColors = [UIColor(red: 222.0/255.0, green: 30.0/255.0, blue: 16.0/255.0, alpha: 1.0),
                         UIColor(red: 238.0/255.0, green: 88.0/255.0, blue: 63.0/255.0, alpha: 1.0)]
    let TableRowHeight: Float = 250.0
    
    var wordings: [Wording] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.wordingTableView.register(UINib(nibName: "WordingTableViewCell", bundle: nil), forCellReuseIdentifier: "wordingCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        observeUpdates()
        retriveWordings()
    }
    
    func retriveWordings() {
        let ref = FIRDatabase.database().reference().child("wordings").queryOrdered(byChild: "user").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).queryLimited(toLast: 3)
        
        ref.observeSingleEvent(of: .value, with: {
            (snapshots) in
            var temp: [Wording] = []
            for children in snapshots.children {
                if let snapshot = children as? FIRDataSnapshot {
                    if let wording = self.convertWording(from: snapshot) {
                        temp.insert(wording, at: 0)
                    }
                }
            }
            self.wordings.append(contentsOf: temp)
            DispatchQueue.main.async {
                self.wordingTableView.reloadData()
            }
        })
    }
    
    func observeUpdates() {
        let ref = FIRDatabase.database().reference().child("wordings").queryOrdered(byChild: "timestamp").queryStarting(atValue: Date().timeIntervalSince1970)
        
        ref.observe(.childAdded, with: {
            (snapshot) in
            if let wording = self.convertWording(from: snapshot) {
                if FIRAuth.auth()?.currentUser?.uid == wording.user {
                    self.wordings.insert(wording, at: 0)
                    DispatchQueue.main.async {
                        self.wordingTableView.reloadData()
                    }
                }
            }
        }, withCancel: nil)
    }
    
    func convertWording(from snapshot: FIRDataSnapshot) -> Wording? {
        if let dictionary = snapshot.value as? [String: Any] {
            let wording = Wording()
            wording.setValuesForKeys(dictionary)
            return wording
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordingCell") as? WordingTableViewCell
        
        if self.wordings.count > indexPath.row {
            let wording = self.wordings[indexPath.row]
            cell?.wording.text = wording.text
        }
        
        cell?.backgroundColor = self.WordingColors[indexPath.row % self.WordingColors.count]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.TableRowHeight)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
//            tableTotalRowNumber += 3
//            wordingTableView.reloadData()
        }
    }
    
}
