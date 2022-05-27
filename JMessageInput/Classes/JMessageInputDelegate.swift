//
//  JMessageInputDelegate.swift
//  JMessageInput
//
//  Created by Javad on 22.04.22.
//

@objc public protocol JMessageInputDelegate: AnyObject {
    
    func textDidChange(input: JMessageInput, text: String?)
    func inputDidComeIntoFocus(input: JMessageInput)
    func inputDidFallOutOfFocus(input: JMessageInput)
    func inputDidChangeFrame(input: JMessageInput)
    
    
    func plusButtonPressed(input: JMessageInput)
    func plusButtonReleased(input: JMessageInput)
    
    func micButtonPressed(input: JMessageInput)
    func micButtonReleased(input: JMessageInput)
    
    func cameraButtonPressed(input: JMessageInput)
    func cameraButtonReleased(input: JMessageInput)
    
    func sendButtonPressed(input: JMessageInput)
    func sendButtonReleased(input: JMessageInput)
    
    func stateDidChange(input: JMessageInput, oldState: JMessageInputState)
    func stateWillChange(input: JMessageInput, newState: JMessageInputState)
    
}
