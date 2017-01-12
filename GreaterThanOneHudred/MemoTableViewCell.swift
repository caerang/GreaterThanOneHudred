//
//  MemoTableViewCell.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 12..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    let bodyText: UILabel? = {
        let NumOfLines = 6
        let label = UILabel()
        
        label.textColor = UIColor.white
        label.font = label.font.withSize(18.0)
        label.numberOfLines = NumOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Never seem more learned than the people you are with. Wear your learning like a pocket watch and keep it hidden. Do not pull it out to count the hours, but give the time when you are asked."
        
        return label
    }()
    
    let dateAndWriter: UILabel? = {
        let label = UILabel()
        
        label.textColor = UIColor.init(white: 1.0, alpha: 0.6)
        label.font = label.font.withSize(13.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Today at 11:02 am ・ Writed by Youngwook"
        
        return label
    }()
    
    let bookTitleAndPage: UILabel? = {
        let label = UILabel()
        
        label.textColor = UIColor.init(white: 1.0, alpha: 0.6)
        label.font = label.font.withSize(13.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "The Rules > 1,328page"
        
        return label
    }()
    
//  Storyboard 에 정의 된 UITableViewCell 에서 콜 되는 경우는 required init?(coder aDecoder: NSCoder) 가 호출된다,
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addSubview(self.bodyText!)
        
        self.bodyText!.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 44.5).isActive = true
        self.bodyText!.topAnchor.constraint(equalTo: self.topAnchor, constant: 30.0).isActive = true
        self.bodyText!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -86).isActive = true
        self.bodyText!.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -38.5).isActive = true
        
        self.addSubview(self.dateAndWriter!)
        
        self.dateAndWriter!.leftAnchor.constraint(equalTo: self.bodyText!.leftAnchor).isActive = true
        self.dateAndWriter!.topAnchor.constraint(equalTo: self.bodyText!.bottomAnchor, constant: 28).isActive = true
        self.dateAndWriter!.heightAnchor.constraint(equalToConstant: 15.0)
        self.dateAndWriter!.rightAnchor.constraint(equalTo: self.bodyText!.rightAnchor).isActive = true
        
        self.addSubview(self.bookTitleAndPage!)
        
        self.bookTitleAndPage!.leftAnchor.constraint(equalTo: self.bodyText!.leftAnchor).isActive = true
        self.bookTitleAndPage!.topAnchor.constraint(equalTo: self.dateAndWriter!.bottomAnchor, constant: 2.0).isActive = true
        self.bookTitleAndPage!.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        self.bookTitleAndPage!.rightAnchor.constraint(equalTo: self.bodyText!.rightAnchor).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
