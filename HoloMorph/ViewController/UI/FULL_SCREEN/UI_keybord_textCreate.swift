//
//  UI_keybord_textCreate.swift
//  Holoss
//
//  Created by Rok Kosuta on 09/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

/*
 protocol UI_keybord_textCreate_delegate
 {
 func keybord_FullScreen_delegate__close()
 func keybord_FullScreen_delegate__text(str : String)
 }
 */
class UI_keybord_textCreate : UI_fullScreen_Generic, UITextFieldDelegate, FullScreenProtocol
{
    var current_entered_text : String = ""
    var sampleTextField : UITextField?
    
    //MARK: FullScreenProtocol method
    func delegate_show(parent_view: UIView)
    {
        self.isHidden = false
        print("BBBB")
        self.sampleTextField?.becomeFirstResponder()
    }
    
    func delegate_did_finish_hidding()
    {
        
    }
    
    func get_text() -> String
    {
        return self.current_entered_text
    }
    
    class func create(frame : CGRect, f_execute_before_closing : @escaping (UIView)->()) -> UI_keybord_textCreate//, delegate : UI_keybord_textCreate_delegate) -> UI_keybord_textCreate
    {
        let res = UI_keybord_textCreate.init()
        res.create_internal(frame: frame)//, delegate: delegate)
        res.execute_before_closing = f_execute_before_closing
        return res
    }
    
    private func create_internal(frame : CGRect)//, delegate : UI_keybord_textCreate_delegate)
    {
        //self.delegate = delegate
        self.frame = frame.originAtZeroSameWidthHeight()
        self.backgroundColor = UIColor.init(red: 0.0, green: 0.2, blue: 0.2, alpha: 1.0)
        create_button_close()
        create_title_label(string: "Save Full Screen")
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
        
        //adding text
        print("AAAAA")
        self.sampleTextField =  UITextField(frame: CGRect(x: 0.0, y: self.frame.height-40, width: self.frame.width, height: 40))
        self.sampleTextField!.placeholder = "Enter text here"
        self.sampleTextField!.font = UIFont.systemFont(ofSize: 15)
        self.sampleTextField!.borderStyle = UITextField.BorderStyle.roundedRect
        self.sampleTextField!.autocorrectionType = UITextAutocorrectionType.no
        self.sampleTextField!.keyboardType = UIKeyboardType.default
        self.sampleTextField!.returnKeyType = UIReturnKeyType.done
        self.sampleTextField!.clearButtonMode = UITextField.ViewMode.whileEditing;
        self.sampleTextField!.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.sampleTextField!.delegate = self
        self.addSubview(self.sampleTextField!)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        //aded who knows what is does self.sampleTextField?.becomeFirstResponder()
        
    }
    
    @objc internal func keyboardWillHide(_ notification: Notification)
    {
        print("keyboardWillHide")
        self.sampleTextField?.frame = CGRect(x: 0.0, y: self.frame.height - self.sampleTextField!.frame.height, width: self.frame.width, height: self.sampleTextField!.frame.height)
    }
    
    
    @objc internal func keyboardWillShow(_ notification: Notification)
    {
        print("keyboardWillShow")
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.sampleTextField?.frame = CGRect.init(x: 0, y: self.frame.height - (keyboardHeight  + self.sampleTextField!.frame.height) , width: self.frame.width, height: self.sampleTextField!.frame.height)
        }
    }
    
    @objc internal override func button_close_action()
    {
        self.execute_before_closing?(self)
        self.sampleTextField?.text = ""
        self.current_entered_text = ""
        //delegate?.keybord_FullScreen_delegate__close()
    }
    
    //MARK: -delegate methods
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }
    
    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField)
    {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
        
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
        button_close_action()
        //self.delegate?.keybord_FullScreen_delegate__text(str: self.current_entered_text)
    }
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // return NO to not change text
        //print(textField.text)
        
        print("While entering the characters this method gets called :",current_entered_text)
        if let safe_text = textField.text
        {
            
            current_entered_text = safe_text+string
        }
        else
        {
            current_entered_text = ""
        }
        return true
    }
    
    internal func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        textField.resignFirstResponder()
        // may be useful: textField.resignFirstResponder()
        return true
    }
}

