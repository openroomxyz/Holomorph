//
//  Menu_Move.swift
//  Holoss
//
//  Created by Rok Kosuta on 18/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

struct Menu_Move : Menu_Protocol
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
        return .move
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
        if self.menu.isHidden
        {
            self.menu.isHidden = false
        }
        else
        {
            self.menu.isHidden = true
        }
    }
    
    var menu : U_G_Menu
    
    init(ui_controller : UI_Controller)
    {
        self.menu = Menu_Move.move_create(ui_controller: ui_controller)
        ui_controller.view.addSubview(self.menu)
    }
    
    //private
    private static func move_create(ui_controller : UI_Controller) -> U_G_Menu
    {
        //func delegate_menu_move_command( command : Menu_World_Move_Option)
        func calculate_frame_of_view_for_menu_move_world(view_frame : CGRect) -> (()->CGRect)
        {
            let w = view_frame.width * 0.1
            let h = view_frame.height * 0.4
            let x = view_frame.width * 0.025
            let y = view_frame.height * 0.025
            
            return {()->CGRect in return CGRect.init(x: x, y: y, width: w, height: h) }
        }
        
        func f_buttons_for_menu_move(f_callback : @escaping (My_Enums.Menu_World_Move_Option)->()) -> [U_G_Button]
        {
            func emogy_forward() -> String
            {
                return "⬆️"
            }
            
            func emogy_back() ->String
            {
                return "⬇️"
            }
            
            func emogy_world_grab() -> String
            {
                return "🤚🏻🌍"
            }
            
            var arr :  [U_G_Menu.B_Desc] = []
            
            /*
             arr.append(U_G_Menu.B_Desc(f: { f_callback( .forward) }, txt: "Forw"))
             arr.append(U_G_Menu.B_Desc(f: { f_callback( .back) }, txt: "Back"))
             arr.append(U_G_Menu.B_Desc(f: { f_callback( .world_grab) }, txt: "WorldG"))
             */
            
            arr.append(U_G_Menu.B_Desc(f: { f_callback( .forward) }, txt: emogy_forward()))
            arr.append(U_G_Menu.B_Desc(f: { f_callback( .back) }, txt: emogy_back()))
            arr.append(U_G_Menu.B_Desc(f: { f_callback( .world_grab) }, txt: emogy_world_grab()))
            
            
            return U_G_Menu.Menu_Buttons.f_gen(d: arr, call_back_with_self: { (b : U_G_Button)->() in
                //happens on button click
                b.btn?.backgroundColor = Global.Constants.Colors.menu_button_color()//UIColor.orange
                b.btn?.setTitleColor(UIColor.black, for: .normal)
                b.btn?.showsTouchWhenHighlighted = true
            })
            // return U_G_Menu.Menu_Buttons.f_gen(d: arr, call_back_with_self: nil)
        }
        
        let tmp = U_G_Menu.init(frame: ui_controller.view.frame.originAtZeroSameWidthHeight())
        tmp.f_frame_of_view = calculate_frame_of_view_for_menu_move_world(view_frame: ui_controller.view.frame)
        //tmp.buttons = f_buttons_for_menu_move(f_callback: ui_controller.callback_from_Menu_Move)
        tmp.buttons = f_buttons_for_menu_move(f_callback:  { (command : My_Enums.Menu_World_Move_Option) -> () in
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)} )
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.layer.cornerRadius = 12.0  } )
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.setTitleColor(UIColor.white, for: .normal)  } )
            ui_controller.callback_from_Menu_Move(command: command)
        })
        _ = tmp.create()
        tmp.layer.cornerRadius = 12.0
        
        for button in tmp.buttons
        {
            button.btn?.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            button.btn?.layer.cornerRadius = 12.0
            button.btn?.setTitleColor(UIColor.white, for: .normal)
        }
        
        return tmp
    }
}

