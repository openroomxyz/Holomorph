//
//  Menu_Menu.swift
//  Holoss
//
//  Created by Rok Kosuta on 18/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

struct Menu_Menu : Menu_Protocol
{
    func delegate_hide_if_not_equal_type(type: UI_menu_Controller.MenuType, ui_controller: UI_Controller)
    {
        if get_type() != type
        {
            delegate_hide(ui_controller: ui_controller)
        }
    }
    
    func get_type() -> UI_menu_Controller.MenuType
    {
        return .menu
    }
    
    func delegate_show(ui_controller: UI_Controller)
    {
        if self.menu.isHidden
        {
            delegate_togle(ui_controller: ui_controller)
        }
    }
    
    func delegate_hide(ui_controller: UI_Controller)
    {
        if self.menu.isHidden
        {
            
        }
        else
        {
            delegate_togle(ui_controller: ui_controller)
        }
    }
    
    func delegate_togle(ui_controller: UI_Controller)
    {
        Menu_Menu.menu_menu_toggle(ui_controller: ui_controller, menu: self.menu, call_back_on_open: { (U_G_Menu)->() in print("call_back_on_open menu_menu")} )
    }
    
    var menu : U_G_Menu
    
    init(ui_controller : UI_Controller)
    {
        self.menu = Menu_Menu.create_menu_menu(ui_controller: ui_controller) //Menu_create.menu_create(ui_controller: ui_controller)
        ui_controller.view.addSubview(self.menu)
    }
    
    //private
    private static func menu_menu_toggle(ui_controller : UI_Controller, menu : U_G_Menu, call_back_on_open : @escaping (U_G_Menu)->())
    {
        /*
         UIView.animate(withDuration: 1.0, animations: {
         menu.frame = calculate_frame_of_view_for_main_menu(view_frame: ui_controller.view.frame)()
         menu.update_to_fit_the_frame()
         menu.layer.cornerRadius = 10.0
         }, completion: { (Bool)->Void  in  menu.update_to_fit_the_frame() } )
         */
        
        func calculate_frame_of_view_for_menu_menu_open(view_frame : CGRect) -> (()->CGRect)
        {
            let w = view_frame.width * 0.2
            let h = view_frame.height * 0.5
            let x = view_frame.width * 0.80
            let y = view_frame.height * (0.22 + 0.2)
            
            return {()-> CGRect in return CGRect.init(x: x, y: y, width: w, height: h) }
        }
        
        func calculate_frame_of_view_for_menu_menu_closed(view_frame : CGRect) -> (()->CGRect)
        {
            let w = view_frame.width * 0.2
            let h = view_frame.height * 0.5
            let x = view_frame.width * 1.00
            let y = view_frame.height * (0.22 + 0.2)
            
            return {()-> CGRect in return CGRect.init(x: x, y: y, width: w, height: h) }
        }
        
        struct Running
        {
            static var running = false
        }
        
        if Running.running {
            
        }
        else
        {
            Running.running = true
            
            if menu.isHidden
            {
                call_back_on_open(menu)
                
                UIView.animate(withDuration: 0.3,
                               animations: { () -> Void in
                                menu.isHidden = false
                                menu.frame = calculate_frame_of_view_for_menu_menu_open(view_frame: ui_controller.view.frame)()
                }, completion: { (Bool) -> Void in
                    menu.isHidden = false
                    Running.running = false
                })
                
                
                
            }
            else
            {
                UIView.animate(withDuration: 0.3,
                               animations: { () -> Void in
                                menu.frame = calculate_frame_of_view_for_menu_menu_closed(view_frame: ui_controller.view.frame)()
                }, completion: { (Bool) -> Void in
                    menu.isHidden = true
                    Running.running = false
                })
            }
        }
        
        
    }
    
    private static func create_menu_menu(ui_controller : UI_Controller) -> U_G_Menu
    {
        
        func load_save_send_emogy_string() -> String
        {
            return "📂💾📧"
        }
        
        
        func settings_emogy() -> String
        {
            return "⚙️"
        }
        
        func color_emogy() -> String
        {
            return "🎨"
        }
        
        func f_buttons_for_menu_menu(f_callback : @escaping (My_Enums.Menu_Menu_Option)->()) -> [U_G_Button]
        {
            var arr :  [U_G_Menu.B_Desc] = []
            //arr.append( U_G_Menu.B_Desc(f: { f_callback( .load_save_send) }, txt: "Load/Save/Send"))
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .load_save_send) }, txt: load_save_send_emogy_string()))
            //arr.append( U_G_Menu.B_Desc(f: { f_callback( .photo) }, txt: "Photo"))
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .photo) }, txt: Global.Constants.Emoji.video_recording_press_to_record()))
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .delete_all) }, txt: "Delete all"))
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .export) }, txt: "Export"))
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .color) }, txt: color_emogy()))
            //arr.append( U_G_Menu.B_Desc(f: { f_callback( .settings)}, txt: "Settings"))
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .settings)}, txt: settings_emogy()))
            return U_G_Menu.Menu_Buttons.f_gen(d: arr, call_back_with_self: nil)
        }
        
        func calculate_frame_of_view_for_menu_menu(view_frame : CGRect) -> (()->CGRect)
        {
            let w = view_frame.width * 0.2
            let h = view_frame.height * 0.5
            let x = view_frame.width * 0.80
            let y = view_frame.height * (0.22 + 0.2)
            
            return {()-> CGRect in return CGRect.init(x: x, y: y, width: w, height: h) }
        }
        
        func color_neutral_state(_ menu : U_G_Menu)
        {
            for button in menu.buttons
            {
                button.btn?.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
                button.btn?.layer.cornerRadius = 12.0
                button.btn?.setTitleColor(UIColor.white, for: .normal)
            }
        }
        
        let tmp = U_G_Menu.init(frame: ui_controller.view.frame.originAtZeroSameWidthHeight())
        tmp.f_frame_of_view = calculate_frame_of_view_for_menu_menu(view_frame: ui_controller.view.frame)
        tmp.buttons = f_buttons_for_menu_menu(f_callback: ui_controller.callback_from_Menu_Menu)
        _ = tmp.create()
        
        color_neutral_state(tmp)
        
        tmp.layer.cornerRadius = 15
        
        return tmp
    }
}

