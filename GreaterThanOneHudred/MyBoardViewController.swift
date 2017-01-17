//
//  MyBoardViewController.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 16..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class MyBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var memoTableView: UITableView!
    
    let NumOfRows = 3
    let MemoColors = [UIColor(red: 222.0/255.0, green: 30.0/255.0, blue: 16.0/255.0, alpha: 1.0),
                      UIColor(red: 238.0/255.0, green: 88.0/255.0, blue: 63.0/255.0, alpha: 1.0)]
    let TableRowHeight: Float = 250.0
    
    var tableTotalRowNumber: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        memoTableView.register(UINib(nibName: "MemoTableViewCell", bundle: nil), forCellReuseIdentifier: "memoCell")
//        memoTableView.tableFooterView?.addSubview(UIView())
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
}
