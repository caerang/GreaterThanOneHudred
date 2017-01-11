//
//  UITextFieldSingleLine.swift
//  GreaterThanOneHudred
//
//  Created by Hstonecoldjuice on 2017. 1. 2..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class TextFieldSingleLine: UITextField, UITextFieldSingleLineProtocol {
    let singleLineView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        uiView.translatesAutoresizingMaskIntoConstraints = false // 자동으로 생성되는 Constraints 들과 코드에서 추가한 Constraints 와 충돌 방지 위해 false 설정
        return uiView
    }()
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
    func didFocused() {
        singleLineView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    }
    
    func didFocusReleased() {
        singleLineView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
    }
    
    override func awakeFromNib() {
        self.borderStyle = .none
        self.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        setBottomLine()
    }
    
    func setBottomLine() {
        self.addSubview(singleLineView)
        
        singleLineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        singleLineView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        singleLineView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        singleLineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
}
