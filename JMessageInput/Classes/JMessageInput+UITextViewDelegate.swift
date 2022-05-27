//
//  JMessageInput+UITextViewDelegate.swift
//  Pods
//
//  Created by Javad on 29.03.22.
//

extension JMessageInput: UITextViewDelegate {
//    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if (text == "\n") {
//            textView.endEditing(true)
//            textView.text = nil
////            state = .initial
//            
//            resizeTextViewToFitText(textView: textView)
//        }
//        
//        return true
//    }
    
    public func textViewDidChange(_ textView: UITextView) {
//        if let text = textView.text, text.count > 0 {
//            state = .dirty
//        } else {
//            state = .initial
//        }
        
        resizeTextViewToFitText(textView: textView)
        
        self.delegate?.textDidChange(input: self, text: textView.text)
    }
    
    func resizeTextViewToFitText(textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let expectedSize = textView.sizeThatFits(size)
        self.textViewHeightConstraint?.constant = max(min(expectedSize.height, self.maxTextHeight), self.minTextHeight)
        
        UIView.animate(withDuration: animationDuration) {
            textView.isScrollEnabled = expectedSize.height > self.maxTextHeight
        }
        
        self.delegate?.inputDidChangeFrame(input: self)
    }
}
