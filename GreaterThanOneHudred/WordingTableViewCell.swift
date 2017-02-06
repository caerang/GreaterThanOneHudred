//
//  WordingTableViewCell.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 16..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class WordingTableViewCell: UITableViewCell {
    @IBOutlet weak var wording: UILabel!
    @IBOutlet weak var dateAndWriter: UILabel!
    @IBOutlet weak var bookNameAndPageNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
