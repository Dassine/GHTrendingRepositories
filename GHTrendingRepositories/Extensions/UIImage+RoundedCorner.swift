//
//  UIImage+RoundedCorner.swift
//  GHTrendingRepositories
//
//  Created by Lilia Dassine Belaid on 2018-09-02.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var borderWidth:CGFloat {
        
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor:UIColor! {
        
        get {
            guard let color = self.layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        
        set {
            self.layer.borderColor = newValue.cgColor
        }
        
    }
    
    @IBInspectable var layerCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if newValue > 0 {
                layer.masksToBounds = true
            }
        }
    }
    
}
