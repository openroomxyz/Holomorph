//
//  UI_fullScreen_description.swift
//  Holoss
//
//  Created by Rok Kosuta on 22/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//


import Foundation
import UIKit

/*
 protocol UI_fullScreen_description_delegate
 {
 func description_FullScreen_delegate__close( description : Description)
 }
 */

struct Description : Codable
{
    private var des : String = ""
    
    mutating func update_desciption(str : String)
    {
        self.des = str
    }
    
    func get_description() -> String
    {
        return self.des
    }
}

class UI_fullScreen_description : UI_fullScreen_Generic, UITextViewDelegate, FullScreenProtocol
{
    //MARK: FullScreenProtocol method
    func delegate_show(parent_view: UIView)
    {
        //self.isHidden = false
        
        Global.Animate.full_screen_show_example(duration: Global.settings.length_of_hide_full_fs_view(), view: self, parent_view: parent_view, while_hiden_f: {(UIView) -> () in self.open()}, completion_f: nil)
    }
    
    func delegate_did_finish_hidding()
    {
        
    }
    
    //var delegate : UI_fullScreen_description_delegate?
    var des : Description = Description()
    var text_view : UITextView?
    
    func get_description() -> Description
    {
        return self.des
    }
    
    class func create(frame : CGRect, f_execute_before_closing : @escaping (UIView)->()) -> UI_fullScreen_description//, delegate : UI_fullScreen_description_delegate) -> UI_fullScreen_description
    {
        let res = UI_fullScreen_description.init()
        res.create_internal(frame: frame)//, delegate: delegate)
        res.execute_before_closing = f_execute_before_closing
        return res
    }
    
    private func create_internal(frame : CGRect)//, delegate : UI_fullScreen_description_delegate)
    {
        //self.delegate = delegate
        self.frame = frame.originAtZeroSameWidthHeight()
        self.backgroundColor = Global.Constants.Colors.standard_color_background_of_view()//UIColor.init(red: 0.0, green: 0.2, blue: 0.2, alpha: 1.0)
        
        create_button_close()
        create_title_label(string: "Description")
        
        
        //adding text
        self.text_view =  UITextView(frame: CGRect(x: 20, y: 100, width: self.frame.width-(20 * 2.0), height: self.frame.height * 0.5))//UITextField(frame: CGRect(x: 20, y: 100, width: self.frame.width-20, height: self.frame.height * 0.5))
        self.text_view!.font = UIFont.systemFont(ofSize: 15)
        self.text_view!.autocorrectionType = UITextAutocorrectionType.no
        self.text_view!.keyboardType = UIKeyboardType.default
        self.text_view!.returnKeyType = UIReturnKeyType.done
        self.text_view!.delegate = self
        self.text_view!.layer.cornerRadius = 5.0
        self.addSubview(self.text_view!)
        
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:  #selector(handleTap(gestureRecognize:))) )
    }
    
    @objc func handleTap(gestureRecognize : UIGestureRecognizer)
    {
        self.text_view?.resignFirstResponder()
    }
    
    @objc override func button_close_action()
    {
        self.text_view?.endEditing(true)
        
        on_SC()
        
        self.des.update_desciption(str: self.text_view!.text)
        
        self.execute_before_closing?(self)
        
        //delegate?.description_FullScreen_delegate__close(description: self.des)
        
        self.text_view?.text = ""
    }
    
    func open()//you should use thig
    {
        //self.isHidden = false;
        
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
        
        off_SC()
        
        self.text_view?.text = self.des.get_description()
        self.text_view?.reloadInputViews()
    }
    
    @objc func keyboardWillHide(_ notification: Notification)
    {
        print("keyboardWillHide")
        /*
         let f = frames_keybord_hidden()
         sampleTextField.frame = f.sample_text_field
         myTableView.frame = f.table_view
         button_add.frame = f.button_add
         */
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        /*
         if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
         {
         /*
         let keyboardRectangle = keyboardFrame.cgRectValue
         let keyboardHeight = keyboardRectangle.height
         print("keyboardHeight : ", keyboardHeight)
         
         
         var text_field_hight = sampleTextField.frame.height
         var h = self.frame.height - myTableView.frame.origin.y - keyboardHeight - text_field_hight
         
         myTableView.frame = CGRect.init(x: 0.0, y: myTableView.frame.origin.y, width: myTableView.frame.width, height: h)
         sampleTextField.frame = CGRect.init(x: 0, y: self.frame.height - keyboardHeight - sampleTextField.frame.height, width: sampleTextField.frame.width, height: sampleTextField.frame.height)
         button_add.frame = CGRect.init(x: button_add.frame.origin.x, y: self.frame.height - keyboardHeight - sampleTextField.frame.height, width: button_add.frame.width, height: button_add.frame.height)
         */
         }
         */
    }
    
    func set_description(description : Description)
    {
        self.des = description
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        print("UI_fullScreen_description textViewDidEndEditing")
        if textView.text.isEmpty
        {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
        self.text_view?.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        print("UI_fullScreen_description textViewDidBeginEditing")
        if textView.textColor == UIColor.lightGray
        {
            textView.text = nil
            textView.textColor = UIColor.black
            
        }
    }
    
    //MARK: -delegate methods
    /*
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     // return NO to disallow editing.
     print("TextField should begin editing method called")
     return true
     }
     
     func textFieldDidBeginEditing(_ textField: UITextField) {
     // became first responder
     print("TextField did begin editing method called")
     }
     
     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
     // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
     print("TextField should snd editing method called")
     return true
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
     // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
     print("TextField did end editing method called")
     }
     
     func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
     // if implemented, called in place of textFieldDidEndEditing:
     print("TextField did end editing with reason method called")
     }
     
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     // return NO to not change text
     print(textField.text)
     
     print("While entering the characters this method gets called")
     return true
     }
     
     func textFieldShouldClear(_ textField: UITextField) -> Bool {
     // called when clear button pressed. return NO to ignore (no notifications)
     print("TextField should clear method called")
     return true
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     // called when 'return' key pressed. return NO to ignore.
     print("TextField should return method called")
     textField.resignFirstResponder()
     // may be useful: textField.resignFirstResponder()
     return true
     }
     */
}

