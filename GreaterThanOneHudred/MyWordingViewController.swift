//
//  MyWordingViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 16..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit
import Firebase

class MyWordingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FeedViewProtocol {
    @IBOutlet weak var wordingTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let tableRowCount: UInt = 3
    let WordingColors = [UIColor(red: 222.0/255.0, green: 30.0/255.0, blue: 16.0/255.0, alpha: 1.0),
                         UIColor(red: 238.0/255.0, green: 88.0/255.0, blue: 63.0/255.0, alpha: 1.0)]
    let TableRowHeight: Float = 250.0
    
    var wordings: [Wording] = []
    
    var lastPostingKey: String? = nil
    var isPostExistWillRead = true
    var myIsPostDidReadFirstTime = true
    
    var myUpdatingObserverQuery: FIRDatabaseQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.wordingTableView.register(UINib(nibName: "WordingTableViewCell", bundle: nil), forCellReuseIdentifier: "wordingCell")
        
        observeUpdates()
        retrivePostings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.activityIndicator.isHidden {
            self.activityIndicator.startAnimating()
        }
    }
    
    func viewDidUnloaded() {
        self.myIsPostDidReadFirstTime = true
        self.activityIndicator.isHidden = false
        self.myUpdatingObserverQuery?.removeAllObservers()
        wordings.removeAll()
        self.wordingTableView.reloadData()
    }
    
    func resetView() {
        self.activityIndicator.startAnimating()
        observeUpdates()
        retrivePostings()
    }
    
    func observeUpdates() {
        self.myUpdatingObserverQuery = FIRDatabase.database().reference().child("\(DbConsts.Postings)").queryOrdered(byChild: "timestamp").queryStarting(atValue: Date().timeIntervalSince1970)
        
        self.myUpdatingObserverQuery?.observe(.childAdded, with: { (snapshot) in
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
        
        if let endingTo = self.lastPostingKey {
            let ref = FIRDatabase.database().reference().child("\(DbConsts.UserPostings)").child(uid).queryOrderedByKey().queryEnding(atValue: endingTo).queryLimited(toLast: self.tableRowCount + 1)
            runQueryRetrievePostings(query: ref)
        }
        else {
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
                    self.lastPostingKey = endSnapshot.key
                }
            }
            else {
                self.isPostExistWillRead = false
            }
            
            if 0 == postLinks.count {
                self.hideActivityIndicator()
                return
            }
            
            let postCountWillRead = postLinks.count
            var postCountDidRead = 0
            
            for i in 0 ..< postLinks.count {
                if let postLink = postLinks[i] as? FIRDataSnapshot {
                    let refPost = FIRDatabase.database().reference().child("\(DbConsts.Postings)").child(postLink.key)
                    
                    refPost.observeSingleEvent(of: .value, with: {
                        (snapshotPost) in
                        if let post = self.convertWording(from: snapshotPost) {
                            buf.append(post)
                        }
                        
                        postCountDidRead = postCountDidRead + 1
                        
                        if postCountWillRead == postCountDidRead {
                            buf.sort { $0.timestamp!.compare($1.timestamp!) == .orderedDescending }
                            self.wordings.append(contentsOf: buf)
                            buf.removeAll()
                            
                            DispatchQueue.main.async {
                                self.reloadWordings()
                            }
                        }
                    })
                }
            }
        })
    }
    
    func reloadWordings() {
        self.wordingTableView.reloadData()
        hideActivityIndicator()
    }
    
    func hideActivityIndicator() {
        if self.myIsPostDidReadFirstTime {
            self.myIsPostDidReadFirstTime = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
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
