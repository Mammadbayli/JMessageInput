//
//  UIView+Disable.swift
//  JMessageInput
//
//  Created by Javad on 28.05.22.
//

extension UIView {
    
    func enable() {
        self.isHidden = false
        self.alpha = 0
    }
    
    func disble() {
        self.isHidden = true
        self.alpha = 1
    }
    
}
