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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(input)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                input.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                input.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                input.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//                input.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else {
            // Fallback on earlier versions
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

