//
//  JMessageInputTextView.swift
//  Pods
//
//  Created by Javad on 29.03.22.
//

class JMessageInputTextView: UITextView {
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        
        textContainer.heightTracksTextView = true
        isScrollEnabled = false
        font = .systemFont(ofSize: 14)
        layer.cornerRadius = 18
        clipsToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
