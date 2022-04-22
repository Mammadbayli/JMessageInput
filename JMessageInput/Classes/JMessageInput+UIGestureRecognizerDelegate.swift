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
        } else if plusButton.frame.contains(touchLocation) {
            plusButtonPressed()
        } else if cameraButton.frame.contains(touchLocation) {
            cameraButtonPressed()
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let distance = initialTouchLocation!.x - location.x
        if (abs(distance) > 150 && isMicButtonPressed) {
            micButtonReleased()
        }
        
        slideToCancelLabel.transform = CGAffineTransform(translationX: -distance/5 + 1, y: 0)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let touchLocation = touches.first?.location(in: self) else { return }
        
        if !micButton.frame.contains(touchLocation) && isMicButtonPressed {
            micButtonReleased()
        } else if !plusButton.frame.contains(touchLocation) && isPlusButtonPressed {
            plusButtonReleased()
        } else if !cameraButton.frame.contains(touchLocation) && isCameraButtonPressed {
            cameraButtonReleased()
        }
        
        slideToCancelLabel.transform = .identity
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if isMicButtonPressed {
            micButtonReleased()
        } else if isPlusButtonPressed {
            plusButtonReleased()
        } else if isCameraButtonPressed {
            cameraButtonReleased()
        }
        
        slideToCancelLabel.transform = .identity
    }
    
    func micButtonPressed() {
        isMicButtonPressed = true
        
        state = .recordingAudio
        
        self.delegate?.micButtonPressed(input: self)
    }
    
     func micButtonReleased() {
        isMicButtonPressed = false
        
        state = .initial
        
        self.delegate?.micButtonReleased(input: self)
    }

     func plusButtonPressed() {
        isPlusButtonPressed = true
        
//        state = .initial
        
        self.delegate?.plusButtonPressed(input: self)
    }
    
     func plusButtonReleased() {
        isPlusButtonPressed = false
        
//        state = .initial
        
        self.delegate?.plusButtonReleased(input: self)
   }
    
    
     func cameraButtonPressed() {
        isCameraButtonPressed = true
        
//        state = .initial
        
        self.delegate?.cameraButtonPressed(input: self)
    }
    
     func cameraButtonReleased() {
        isCameraButtonPressed = false
        
//        state = .initial
        
        self.delegate?.cameraButtonReleased(input: self)
    }
    
    @objc func sendButtonPressed() {
        self.delegate?.sendButtonPressed(input: self)
    }
    
    @objc func sendButtonReleased() {
        self.delegate?.sendButtonReleased(input: self)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }

}
