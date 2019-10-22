//
//  UI_fullScreen_tags.swift
//  Holoss
//
//  Created by Rok Kosuta on 22/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

//global object
struct Tag : Codable
{
    var tag : String
    
    static func contains(arr : [Tag], tag : Tag) -> Bool
    {
        for i in arr
        {
            if Tag.isEqual(i, tag)
            {
                return true
            }
        }
        return false
    }
    
    static func isEqual(_ a : Tag, _  b  : Tag) -> Bool
    {
        if (a.tag == b.tag)
        {
            return true
        }
        return false
    }
}

//global object
struct Tag_List : Codable
{
    var tags : [Tag] = []
    
    mutating func add_tag(tag : Tag)
    {
        if Tag.contains(arr: self.tags, tag: tag)
        {
            
        }
        else
        {
            self.tags.append(tag)
        }
        
    }
    
    func tag_at_index(index : Int) -> Tag
    {
        return self.tags[index]
    }
    
    func count() -> Int
    {
        return self.tags.count
    }
    
    mutating func update(tag_list : Tag_List)
    {
        self.tags = tag_list.tags
        
        //we changed add to we dont need all this code
        /*
         var tmp = Set<String>()
         for i in tag_list.arr
         {
         tmp.insert(i.tag)
         }
         for j in self.arr
         {
         tmp.insert(j.tag)
         }
         
         var t = Array(tmp)
         
         var new_arr : [Tag] = []
         for ti in t
         {
         new_arr.append(Tag.init(tag: ti))
         }
         */
    }
}

/*
 protocol UI_fullScreen_tags_delegate
 {
 func tags_FullScreen_delegate__close(tag_list : Tag_List)
 }
 */

class UI_fullScreen_tags : UI_fullScreen_Generic, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FullScreenProtocol
{
    //MARK: FullScreenProtocol method
    func delegate_show(parent_view: UIView)
    {
        Global.Animate.full_screen_show_example(duration: Global.settings.length_of_hide_full_fs_view(), view: self, parent_view: parent_view, while_hiden_f: {(v : UIView)->() in self.open()}, completion_f: nil)
    }
    
    func delegate_did_finish_hidding()
    {
        
    }
    //var delegate : UI_fullScreen_tags_delegate?
    
    //private var myArr : NSMutableArray = ["first","second","third"]
    private var tag_list : Tag_List = Tag_List.init()
    
    private var myTableView : UITableView!
    private var sampleTextField : UITextField!
    private var button_add : UIButton!
    
    private var current_entered_text : String = ""
    
    func get_taglist() -> Tag_List
    {
        return self.tag_list
    }
    
    class func create(frame : CGRect, f_execute_before_closing : @escaping (UIView)->()) -> UI_fullScreen_tags//, delegate : UI_fullScreen_tags_delegate) -> UI_fullScreen_tags
    {
        let res = UI_fullScreen_tags.init()
        res.create_internal(frame: frame)//, delegate: delegate)
        res.execute_before_closing = f_execute_before_closing
        return res
    }
    
    func set_tag_list(tag_list : Tag_List)
    {
        self.tag_list = tag_list
        myTableView.reloadData()
    }
    
    func frames_keybord_hidden() -> (table_view : CGRect, sample_text_field : CGRect, button_add : CGRect)
    {
        //let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        //myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight - 100))
        
        let displayWidth: CGFloat = self.frame.width
        let displayHeight: CGFloat = self.frame.height
        let h = self.button_close!.frame.origin.y + self.button_close!.frame.height
        
        let a = CGRect(x: 0, y: h, width: displayWidth, height: displayHeight - h - 80)
        
        let calculated_h_of_label = self.frame.height - ((displayHeight - h - 80) + h)
        let b = CGRect(x:0 , y: (displayHeight - h - 80) + h, width: frame.width * 0.8, height: calculated_h_of_label)
        
        
        let c = CGRect.init(x: frame.width * 0.8, y: (displayHeight - h - 80) + h, width: frame.width * 0.2, height: calculated_h_of_label)
        
        return (table_view : a, sample_text_field : b, button_add : c)
    }
    
    
    
    private func create_internal(frame : CGRect)//, delegate : UI_fullScreen_tags_delegate)
    {
        //self.delegate = delegate
        self.frame = frame.originAtZeroSameWidthHeight()
        self.backgroundColor = UIColor.black
        //self.backgroundColor = UIColor.init(red: 0.0, green: 0.2, blue: 0.2, alpha: 1.0)
        
        let v : UIView = UIView.init(frame: frame.originAtZeroSameWidthHeight())
        v.backgroundColor = Global.Constants.Colors.standard_color_background_of_view()//UIColor.gray
        self.addSubview(v)
        self.bringSubviewToFront(v)
        
        create_button_close()
        
        let f = frames_keybord_hidden()
        
        //think about this ?? UIViewController.init()
        
        myTableView = UITableView(frame: f.table_view)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.addSubview(myTableView)
        self.bringSubviewToFront(myTableView)
        
        //adding text
        self.sampleTextField =  UITextField(frame: f.sample_text_field)
        self.sampleTextField.placeholder = "Enter text here"
        self.sampleTextField.font = UIFont.systemFont(ofSize: 15)
        self.sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        self.sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        self.sampleTextField.keyboardType = UIKeyboardType.default
        self.sampleTextField.returnKeyType = UIReturnKeyType.done
        self.sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        self.sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.sampleTextField.delegate = self
        self.addSubview(self.sampleTextField)
        self.bringSubviewToFront(self.sampleTextField)
        
        self.button_add = UIButton.init(frame: f.button_add)
        self.button_add.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.button_add.setTitle("Add", for: .normal)
        self.button_add.setTitleColor(UIColor.orange, for: .normal)
        self.button_add.addTarget(self, action:  #selector(button_add_tag), for: .touchUpInside)
        self.addSubview(self.button_add)
        self.bringSubviewToFront(self.button_add)
        
        create_title_label(string: "Tags")
        
        //TODO:- think about how ot remove and add me so that you dont get crash
        
        
    }
    
    func open()
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
        
        let f = frames_keybord_hidden()
        self.button_add.frame = f.button_add
        self.sampleTextField.frame = f.sample_text_field
        self.myTableView.frame = f.table_view
        
        let nc = NotificationCenter.default
        let myNotification = Notification.Name(rawValue:"MyNotification")
        
        nc.post(name:myNotification,
                object: nil,
                userInfo:["message":"SC_event_from_VC_OFF", "date":Date()])
    }
    
    @objc func keyboardWillHide(_ notification: Notification)
    {
        print("keyboardWillHide")
        let f = frames_keybord_hidden()
        sampleTextField.frame = f.sample_text_field
        myTableView.frame = f.table_view
        button_add.frame = f.button_add
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print("keyboardHeight : ", keyboardHeight)
            
            
            let text_field_hight = sampleTextField.frame.height
            let h = self.frame.height - myTableView.frame.origin.y - keyboardHeight - text_field_hight
            
            myTableView.frame = CGRect.init(x: 0.0, y: myTableView.frame.origin.y, width: myTableView.frame.width, height: h)
            sampleTextField.frame = CGRect.init(x: 0, y: self.frame.height - keyboardHeight - sampleTextField.frame.height, width: sampleTextField.frame.width, height: sampleTextField.frame.height)
            button_add.frame = CGRect.init(x: button_add.frame.origin.x, y: self.frame.height - keyboardHeight - sampleTextField.frame.height, width: button_add.frame.width, height: button_add.frame.height)
        }
    }
    //MARK Button Add
    @objc func button_add_tag()
    {
        print("button_add_tag : ", self.current_entered_text)
        tag_list.add_tag(tag: Tag.init(tag: self.current_entered_text)) //myArr.add(self.current_entered_text)
        //print("myArr : ", myArr)
        myTableView.reloadData()
        sampleTextField.text = ""
    }
    
    //MARK: -table delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        //print("Value: \(myArr[indexPath.row])")
        
        print("Value :", tag_list.tag_at_index(index: indexPath.row).tag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return myArr.count
        return tag_list.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        //cell.textLabel!.text = "\(myArr[indexPath.row])"
        cell.backgroundColor = Global.Constants.Colors.standard_color_table_cell_background()
        cell.textLabel!.text = "\(tag_list.tag_at_index(index: indexPath.row).tag)"
        return cell
    }
    
    
    @objc override func button_close_action()
    {
        sampleTextField.resignFirstResponder() //hide keybord
        NotificationCenter.default.removeObserver(self) //TODO:- this works but the problem it is that you dont have open method you are using view .hide = false ... to on open you sould add Notification center
        
        
        
        let nc = NotificationCenter.default
        let myNotification = Notification.Name(rawValue:"MyNotification")
        
        nc.post(name:myNotification,
                object: nil,
                userInfo:["message":"SC_event_from_VC_ON", "date":Date()])
        self.execute_before_closing?(self)
        //delegate?.tags_FullScreen_delegate__close(tag_list: self.tag_list)
    }
    
    //MARK: -delegate methods
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
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        //print(textField.text)
        if let safe_text = textField.text
        {
            
            current_entered_text = safe_text+string
        }
        else
        {
            current_entered_text = ""
        }
        
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
    
}

