//
//  JMessageInput+UIGestureRecognizerDelegate.swift
//  JMessageInput
//
//  Created by Javad on 30.03.22.
//

extension JMessageInput: UIGestureRecognizerDelegate {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touchLocation = touches.first?.location(in: self) else { return }
        
        initialTouchLocation = touchLocation
        
        if micButton.frame.contains(touchLocation) {
            micButtonPressed()
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let distance = initialTouchLocation!.x - location.x
        if (abs(distance) > 150) {
            micButtonReleased()
        }
        
        slideToCancelLabel.transform = CGAffineTransform(translationX: -distance/5 + 1, y: 0)
    
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if (state == .recordingAudio) {
            micButtonReleased()
        }
        
        slideToCancelLabel.transform = .identity
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if (state == .recordingAudio) {
            micButtonReleased()
        }
        
        slideToCancelLabel.transform = .identity
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }

}
