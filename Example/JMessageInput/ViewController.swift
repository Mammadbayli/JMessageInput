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
    
    private lazy var input: JMessageInput = {
        let input = JMessageInput()
        input.textView.layer.borderColor = UIColor.systemBlue.withAlphaComponent(1).cgColor
        input.textView.layer.borderWidth = 0.5

        input.delegate = self

        return input
    }()

    private var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let chatArea = UIView()
        chatArea.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        chatArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatArea)
        view.addSubview(input)

        if #available(iOS 11.0, *) {
            bottomConstraint = input.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
            NSLayoutConstraint.activate([
                bottomConstraint,
                input.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                input.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                chatArea.bottomAnchor.constraint(equalTo: input.bottomAnchor),
                chatArea.topAnchor.constraint(equalTo: view.topAnchor),
                chatArea.widthAnchor.constraint(equalTo: view.widthAnchor),
                chatArea.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            // Fallback on earlier versions
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )


        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        navigationController?.interactivePopGestureRecognizer?.delaysTouchesBegan = false
    }

    private lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return blurEffectView
    }()

    override func viewDidLayoutSubviews() {

        blurView.removeFromSuperview()
        blurView.frame = input.bounds
        input.insertSubview(blurView, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        [.left, .bottom, .right]
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if #available(iOS 11.0, *) {
            bottomConstraint?.constant = -endFrame.height + view.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
        }
        
    }
    @objc func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = 0
    }

}

extension ViewController: JMessageInputDelegate {
    func textDidChange(input: JMessageInput, text: String?) {
        if text?.isEmpty ?? true {
            input.state = .initial
        } else {
            input.state = .dirty
        }
    }
}

