//
//  UITextFieldSingleLine.swift
//  GreaterThanOneHudred
//
//  Created by Hstonecoldjuice on 2017. 1. 2..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import UIKit

class UITextFieldSingleLine: UITextField, UITextFieldSingleLineProtocol {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    var myRect = CGRect.zero
//    
//    override func draw(_ rect: CGRect) {
//        myRect = rect
//        drawBottomLine(myRect)
//    }
//    
//    func drawBottomLine(_ rect: CGRect, isBeginEditing: Bool = false) {
//        let startingPoint = CGPoint(x: rect.minX, y: rect.maxY)
//        let endingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
//
//        let path = UIBezierPath()
//        
//        path.move(to: startingPoint)
//        path.addLine(to: endingPoint)
//        path.close()
//        path.lineWidth = 2.0
//        
//        UIColor.white.setStroke()
//        
//        if isBeginEditing {
//            path.stroke(with: CGBlendMode.normal, alpha: 1.0)
//        } else {
//            path.stroke(with: CGBlendMode.normal, alpha: 0.2)
//        }
//    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
    func didFocused() {
        if let border = self.layer.sublayers?.first {
            border.opacity = 1.0
        }
    }
    
    func didFocusReleased() {
        if let border = self.layer.sublayers?.first {
            border.opacity = 0.2
        }
    }
    
    override func awakeFromNib() {
        self.borderStyle = .none
        self.textColor = UIColor(colorLiteralRed: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
        
        setBottomLine()
    }
    
    func setBottomLine() {
        let border = CALayer()
        let width = CGFloat(1.0)
        
        border.borderColor = UIColor(colorLiteralRed: 255.0, green: 255.0, blue: 255.0, alpha: 0.2).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        border.opacity = 0.2
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
