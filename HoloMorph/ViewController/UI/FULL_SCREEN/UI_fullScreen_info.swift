//
//  UI_fullScreen_info.swift
//  Holoss
//
//  Created by Rok Kosuta on 22/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

/*
 protocol UI_fullScreen_info_delegate
 {
 func info_FullScreen_delegate__close()
 }
 */
struct Info_Data
{
    var txt : String
    
    func from_node() -> String
    {
        return ""
    }
}

class UI_fullScreen_info : UI_fullScreen_Generic, UITextViewDelegate, FullScreenProtocol
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
    //var delegate : UI_fullScreen_info_delegate?
    var info : Info_Data = Info_Data(txt: "no info")
    var text_view : UITextView?
    
    class func create(frame : CGRect, f_execute_before_closing : @escaping (UIView)->()) -> UI_fullScreen_info//, delegate : UI_fullScreen_info_delegate) -> UI_fullScreen_info
    {
        let res = UI_fullScreen_info.init()
        res.create_internal(frame: frame)//, delegate: delegate)
        res.execute_before_closing = f_execute_before_closing
        return res
    }
    
    private func create_internal(frame : CGRect)//, delegate : UI_fullScreen_info_delegate)
    {
        //self.delegate = delegate
        self.frame = frame.originAtZeroSameWidthHeight()
        self.backgroundColor = Global.Constants.Colors.standard_color_background_of_view()//UIColor.init(red: 0.0, green: 0.2, blue: 0.2, alpha: 1.0)
        
        create_button_close()
        create_title_label(string: "Info")
        
        //adding text
        self.text_view =  UITextView(frame: CGRect(x: 20, y: 100, width: self.frame.width-(20 * 2.0), height: self.frame.height * 0.5))//UITextField(frame: CGRect(x: 20, y: 100, width: self.frame.width-20, height: self.frame.height * 0.5))
        self.text_view!.font = UIFont.systemFont(ofSize: 15)
        self.text_view!.autocorrectionType = UITextAutocorrectionType.no
        self.text_view!.keyboardType = UIKeyboardType.default
        self.text_view!.returnKeyType = UIReturnKeyType.done
        self.text_view!.delegate = self
        self.text_view!.isEditable = false
        self.addSubview(self.text_view!)
    }
    
    private func open()
    {
        off_SC()
        //self.isHidden = false
        self.text_view?.text = info.txt
        self.text_view?.reloadInputViews()
    }
    
    @objc override func button_close_action()
    {
        on_SC()
        
        self.execute_before_closing?(self)
        //delegate?.info_FullScreen_delegate__close()
    }
}

