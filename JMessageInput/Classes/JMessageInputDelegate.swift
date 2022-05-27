//
//  JMessageInputDelegate.swift
//  JMessageInput
//
//  Created by Javad on 22.04.22.
//

@objc public protocol JMessageInputDelegate: AnyObject {
    
    @objc optional func textDidChange(input: JMessageInput, text: String?)
    @objc optional func inputDidComeIntoFocus(input: JMessageInput)
    @objc optional func inputDidFallOutOfFocus(input: JMessageInput)
    @objc optional func inputDidChangeFrame(input: JMessageInput, frame: CGRect)
    
    
    @objc optional func plusButtonPressed(input: JMessageInput)
    @objc optional func plusButtonReleased(input: JMessageInput)
    
    @objc optional func micButtonPressed(input: JMessageInput)
    @objc optional func micButtonReleased(input: JMessageInput)
    
    @objc optional func cameraButtonPressed(input: JMessageInput)
    @objc optional func cameraButtonReleased(input: JMessageInput)
    
    @objc optional func sendButtonPressed(input: JMessageInput)
    @objc optional func sendButtonReleased(input: JMessageInput)
    
    @objc optional func stateDidChange(input: JMessageInput, oldState: JMessageInputState)
    @objc optional func stateWillChange(input: JMessageInput, newState: JMessageInputState)
    
}
