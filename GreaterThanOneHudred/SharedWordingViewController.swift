//
//  SharedWordingViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 17..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit
import Firebase

class SharedWordingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FeedViewProtocol {
    @IBOutlet weak var wordingTableView: UITableView!
    
    let tableRowCount: UInt = 3
    let WordingColors = [UIColor(red: 153.0/255.0, green: 142.0/255.0, blue: 99.0/255.0, alpha: 1.0),
                         UIColor(red: 105.0/255.0, green: 84.0/255.0, blue: 57.0/255.0, alpha: 1.0)]
    let TableRowHeight: Float = 250.0
    
    var wordings: [Wording] = []
    
    var myFirstPostingKey: String? = nil
    var lastPostingKey: String? = nil
    var isPostExistWillRead = true
    var refreshControl = UIRefreshControl()
    var myIsViewLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.wordingTableView.register(UINib(nibName: "WordingTableViewCell", bundle: nil), forCellReuseIdentifier: "wordingCell")
        self.wordingTableView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(handleDidPullDown), for: .valueChanged)
        retrivePostings()
        
        self.myIsViewLoaded = true
    }
    
    func viewDidUnloaded() {
        if self.myIsViewLoaded {
            wordings.removeAll()
            self.wordingTableView.reloadData()
        }
    }
    
    func resetView() {
        retrivePostings()
    }
    
    func handleDidPullDown() {
        self.refreshControl.endRefreshing()
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        if let firstPostingKey = self.myFirstPostingKey {
            let ref = FIRDatabase.database().reference().child("\(DbConsts.Timelines)").child(uid).queryOrderedByKey().queryStarting(atValue: firstPostingKey)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                var postLinks = Array(snapshot.children.reversed())
                var buf: [Wording] = []
                
                _ = postLinks.remove(at: postLinks.count - 1)
                
                if 0 != postLinks.count  {
                    if let nextFirstPosting = postLinks[postLinks.count - 1] as? FIRDataSnapshot {
                        self.myFirstPostingKey = nextFirstPosting.key
                    }
                }
                else {
                    return
                }
                
                let postCountWillRead = postLinks.count
                var postCountDidRead = 0
                
                for i in 0 ..< postLinks.count {
                    if let postLink = postLinks[i] as? FIRDataSnapshot {
                        let refPost = FIRDatabase.database().reference().child("\(DbConsts.Postings)").child(postLink.key)
                        
                        refPost.observeSingleEvent(of: .value, with: { (snapshotPost) in
                            if let post = self.convertWording(from: snapshotPost) {
                                buf.append(post)
                            }
                            
                            postCountDidRead = postCountDidRead + 1
                            
                            if postCountWillRead == postCountDidRead {
                                buf.sort { $0.timestamp!.compare($1.timestamp!) == .orderedDescending }
                                self.wordings.insert(contentsOf: buf, at: 0)
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
    }
    
    func retrivePostings() {
        guard isPostExistWillRead else {
            return
        }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        if let endingTo = self.lastPostingKey {
            let ref = FIRDatabase.database().reference().child("\(DbConsts.Timelines)").child(uid).queryOrderedByKey().queryEnding(atValue: endingTo).queryLimited(toLast: self.tableRowCount + 1)
            runQueryRetrievePostings(query: ref)
        }
        else {
            let ref = FIRDatabase.database().reference().child("\(DbConsts.Timelines)").child(uid).queryLimited(toLast: self.tableRowCount + 1)
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
            
            let postCountWillRead = postLinks.count
            var postCountDidRead = 0
            
            for i in 0 ..< postLinks.count {
                if let postLink = postLinks[i] as? FIRDataSnapshot {
                    let refPost = FIRDatabase.database().reference().child("\(DbConsts.Postings)").child(postLink.key)
                    
                    if nil == self.myFirstPostingKey {
                        self.myFirstPostingKey = postLink.key
                    }
                    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            retrivePostings()
        }
    }
}
