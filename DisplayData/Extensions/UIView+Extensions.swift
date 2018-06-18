//
//  UIView+Extensions.swift
//  Kollectin
//
//  Created by Umair Ali on 5/11/17.
//  Copyright © 2017 Pablo. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius : CGFloat {get {
    
            return layer.cornerRadius
        }
        
        set {
        
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

