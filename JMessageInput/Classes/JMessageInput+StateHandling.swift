//
//  JMessageInput+StateHandling.swift
//  JMessageInput
//
//  Created by Javad on 22.04.22.
//

extension JMessageInput {
    func processState() {
        switch(state) {
        case .dirty:
            UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionFlipFromBottom], animations: {
                self.layoutForDirtyState()
                self.stackView.layoutIfNeeded()
                self.slideToCancelLabel.stopShimmering()
            }, completion: nil)
        case .recordingAudio:
            UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionFlipFromBottom], animations: {
                self.layoutForRecordingAudioState()
                self.stackView.layoutIfNeeded()
                self.slideToCancelLabel.startShimmering()
            }, completion: nil)
        default:
            UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionFlipFromBottom], animations: {
                self.layoutForInitialState()
                self.stackView.layoutIfNeeded()
                self.slideToCancelLabel.stopShimmering()
            }, completion: nil)
        }
    }
    
    func layoutForDirtyState() {
        recordingIndicatorImageView.hide()
        recordingDurationLabel.hide()
        slideToCancelLabel.hide()
        plusButton.show()
        textField.show()
        micButton.hide()
        cameraButton.hide()
        sendButton.show()
        
        stopAnimatingRedMic()
    }
    
    func layoutForInitialState() {
        recordingIndicatorImageView.hide()
        recordingDurationLabel.hide()
        slideToCancelLabel.hide()
        plusButton.show()
        textField.show()
        micButton.show()
        cameraButton.show()
        sendButton.hide()
        
        stopAnimatingRedMic()
    }
    
    func layoutForRecordingAudioState() {
        recordingIndicatorImageView.show()
        recordingDurationLabel.show()
        slideToCancelLabel.show()
        plusButton.hide()
        textField.hide()
        micButton.show()
        cameraButton.hide()
        sendButton.hide()
        
        animateRedMic()
    }
}
