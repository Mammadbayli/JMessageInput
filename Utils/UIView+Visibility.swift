//
//  UIView+Visibility.swift
//  Pods
//
//  Created by Javad on 29.03.22.
//

extension UIView {
    func hide() {
        if (!isHidden) {
            isHidden = true
            alpha = 0
        }
    }
    
    func show() {
        if (isHidden) {
            isHidden = false
            alpha = 1
        }
    }
}
