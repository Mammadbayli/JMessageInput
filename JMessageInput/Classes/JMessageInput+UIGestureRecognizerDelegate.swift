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
        
        if state == .dirty {
            if sendButton.frame.contains(touchLocation) {
                sendButtonPressed()
            } else if plusButton.frame.contains(touchLocation) {
                plusButtonPressed()
            }
        } else if state == .initial {
            if micButton.frame.contains(touchLocation) {
                micButtonPressed()
            }  else if cameraButton.frame.contains(touchLocation) {
                cameraButtonPressed()
            } else if plusButton.frame.contains(touchLocation) {
                plusButtonPressed()
            }
        }
     
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let distance = initialTouchLocation!.x - location.x
        if (abs(distance) > 150) {
            micButtonReleased(canceled: true)
        }
        
        slideToCancelLabel.transform = CGAffineTransform(translationX: -distance/5 + 1, y: 0)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if isSendButtonPressed {
            sendButtonReleased()
        } else if isMicButtonPressed {
            micButtonReleased(canceled: false)
        } else if isPlusButtonPressed {
            plusButtonReleased()
        } else if isCameraButtonPressed {
            cameraButtonReleased()
        }
        
        slideToCancelLabel.transform = .identity
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if isSendButtonPressed {
            sendButtonReleased()
        } else if isMicButtonPressed {
            micButtonReleased(canceled: true)
        } else if isPlusButtonPressed {
            plusButtonReleased()
        } else if isCameraButtonPressed {
            cameraButtonReleased()
        }
        
        slideToCancelLabel.transform = .identity
    }
    
    func micButtonPressed() {
        if !isMicButtonPressed {
            isMicButtonPressed = true
            
            state = .recordingAudio
            if self.delegate?.micButtonPressed != nil {
                self.delegate?.micButtonPressed!(input: self)
            }
        }
    }
    
    func micButtonReleased(canceled: Bool) {
        if isMicButtonPressed {
            isMicButtonPressed = false
            
            state = .initial
            
            if self.delegate?.micButtonPressed != nil {
                self.delegate?.micButtonReleased!(input: self, canceled: canceled)
            }
        }
    }

     func plusButtonPressed() {
         if !isPlusButtonPressed {
             isPlusButtonPressed = true
             
             if self.delegate?.plusButtonPressed != nil {
                 self.delegate?.plusButtonPressed!(input: self)
             }
         }
    }
    
     func plusButtonReleased() {
         if isPlusButtonPressed {
             isPlusButtonPressed = false
             
             if self.delegate?.plusButtonReleased != nil {
                 self.delegate?.plusButtonReleased!(input: self)
             }
         }
   }
    
    
     func cameraButtonPressed() {
         if !isCameraButtonPressed {
             isCameraButtonPressed = true
             
             if self.delegate?.cameraButtonPressed != nil {
                 self.delegate?.cameraButtonPressed!(input: self)
             }
         }

    }
    
     func cameraButtonReleased() {
         if isCameraButtonPressed {
             isCameraButtonPressed = false
             
             if self.delegate?.cameraButtonReleased != nil {
                 self.delegate?.cameraButtonReleased!(input: self)
             }
         }
    }
    
    func sendButtonPressed() {
        if !isSendButtonPressed {
            isSendButtonPressed = true
            
            if self.delegate?.sendButtonPressed != nil {
                self.delegate?.sendButtonPressed!(input: self)
            }
        }
    }
    
    func sendButtonReleased() {
        if isSendButtonPressed {
            isSendButtonPressed = false
            
            if self.delegate?.sendButtonReleased != nil {
                self.delegate?.sendButtonReleased!(input: self)
            }
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizerToFail = self.gestureRecognizerToFail else {
            return false
        }
        
        guard gestureRecognizerToFail.isKind(of: type(of: otherGestureRecognizer)) else {
            return false
        }
        
        return true
    }

}
