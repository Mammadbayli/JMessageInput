//
//  ViewController.swift
//  JMessageInput
//
//  Created by mammadbayli on 03/29/2022.
//  Copyright (c) 2022 mammadbayli. All rights reserved.
//

import UIKit
import JMessageInput

class ViewController: UIViewController {
    
    let input = JMessageInput()
    var bottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(input)
        self.view.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11.0, *) {
            bottomConstraint = input.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
            NSLayoutConstraint.activate([
                bottomConstraint!,
                input.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                input.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                //                input.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else {
            // Fallback on earlier versions
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        self.navigationController?.interactivePopGestureRecognizer?.delaysTouchesBegan = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//
    override func preferredScreenEdgesDeferringSystemGestures() -> UIRectEdge {
        return [.left, .bottom, .right]
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if #available(iOS 11.0, *) {
            bottomConstraint?.constant = -endFrame.height + self.view.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
        }
        
    }
    @objc func keyboardWillHide(notification: Notification) {
//        let endFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        bottomConstraint?.constant = 0
        
    }

}

