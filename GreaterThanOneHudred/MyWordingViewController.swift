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
    
    let tableRowCount: UInt = 3
    let WordingColors = [UIColor(red: 222.0/255.0, green: 30.0/255.0, blue: 16.0/255.0, alpha: 1.0),
                         UIColor(red: 238.0/255.0, green: 88.0/255.0, blue: 63.0/255.0, alpha: 1.0)]
    let TableRowHeight: Float = 250.0
    
    var wordings: [Wording] = []
    
    var endingTo: String? = nil
    var postCountWillRead = 0
    var postCountDidRead = 0
    var isPostExistWillRead = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.wordingTableView.register(UINib(nibName: "WordingTableViewCell", bundle: nil), forCellReuseIdentifier: "wordingCell")
        
        observeUpdates()
        retrivePostings()
    }
    
    func observeUpdates() {
        let ref = FIRDatabase.database().reference().child("\(DbConsts.Postings)").queryOrdered(byChild: "timestamp").queryStarting(atValue: Date().timeIntervalSince1970)
        
        ref.observe(.childAdded, with: { (snapshot) in
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
    
    func retrivePostings() {
        guard isPostExistWillRead else {
            return
        }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        if let endingTo = self.endingTo {
//            let ref = FIRDatabase.database().reference().child("\(DbConsts.Timelines)").child(uid).queryOrderedByKey().queryEnding(atValue: endingTo).queryLimited(toLast: self.tableRowCount + 1)
            let ref = FIRDatabase.database().reference().child("\(DbConsts.UserPostings)").child(uid).queryOrderedByKey().queryEnding(atValue: endingTo).queryLimited(toLast: self.tableRowCount + 1)
            runQueryRetrievePostings(query: ref)
        }
        else {
//            let ref = FIRDatabase.database().reference().child("\(DbConsts.Timelines)").child(uid).queryLimited(toLast: self.tableRowCount + 1)
            let ref = FIRDatabase.database().reference().child("\(DbConsts.UserPostings)").child(uid).queryLimited(toLast: self.tableRowCount + 1)
            runQueryRetrievePostings(query: ref)
        }
    }
    
    func runQueryRetrievePostings(query: FIRDatabaseQuery) {
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            var postLinks = Array(snapshot.children.reversed())
            var buf: [Wording] = []
            if postLinks.count > Int(self.tableRowCount) {
                if let endSnapshot = postLinks.remove(at: postLinks.count - 1) as? FIRDataSnapshot {
                    self.endingTo = endSnapshot.key
                }
            }
            else {
                self.isPostExistWillRead = false
            }
            
            self.postCountWillRead = postLinks.count
            
            for i in 0 ..< postLinks.count {
                if let postLink = postLinks[i] as? FIRDataSnapshot {
                    let refPost = FIRDatabase.database().reference().child("\(DbConsts.Postings)").child(postLink.key)
                    
                    refPost.observeSingleEvent(of: .value, with: {
                        (snapshotPost) in
                        if let post = self.convertWording(from: snapshotPost) {
                            buf.append(post)
                        }
                        
                        self.postCountDidRead = self.postCountDidRead + 1
                        
                        if self.postCountWillRead == self.postCountDidRead {
                            buf.sort { $0.timestamp!.compare($1.timestamp!) == .orderedDescending }
                            self.wordings.append(contentsOf: buf)
                            self.postCountWillRead = 0
                            self.postCountDidRead = 0
                            buf.removeAll()
                            
                            DispatchQueue.main.async {
                                self.wordingTableView.reloadData()
                            }
                        }
                    })
                }
            }
        })
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
            if let timestamp = wording.timestamp, let userName = wording.userName {
                var dateStr = ""
                let date = Date(timeIntervalSince1970: timestamp.doubleValue)
                if NSCalendar.current.isDateInToday(date) {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm a"
                    dateStr = "Today at \(formatter.string(from: date))"
                }
                else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMM dd"
                    dateStr = "\(formatter.string(from: date))"
                }
                
                cell?.dateAndWriter.text = "\(dateStr) ∙ Writed by \(userName)"
            }
            if let bookName = wording.bookName, let pageNumber = wording.pageNumber {
                cell?.bookNameAndPageNumber.text = "\(bookName) > \(pageNumber)page"
            }
        }
        
        cell?.backgroundColor = self.WordingColors[indexPath.row % self.WordingColors.count]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.TableRowHeight)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            retrivePostings()
        }
    }
    
}
