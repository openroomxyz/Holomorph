//
//  Menu_Select.swift
//  Holoss
//
//  Created by Rok Kosuta on 18/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

class Menu_Select : Menu_Protocol
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
        return .select
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
    
    init(ui_controller : UI_Controller, forType : My_Enums.Node_Graph_Type_Of_Node)
    {
        self.menu = Menu_Select.create_select(ui_controller : ui_controller, forType:  forType)
        ui_controller.view.addSubview(self.menu)
    }
    
    //private
    private static func create_select(ui_controller : UI_Controller, forType : My_Enums.Node_Graph_Type_Of_Node) -> U_G_Menu
    {
        func f_buttons_for_menu_select(f_callback : @escaping (My_Enums.Select_Node_Options)->(), forType : My_Enums.Node_Graph_Type_Of_Node) -> [U_G_Button]
        {
            let arr :  [U_G_Menu.B_Desc] =
                [
                    U_G_Menu.B_Desc(f: { f_callback( .color) }, txt: "Color"),
                    U_G_Menu.B_Desc(f: { f_callback( .desciption) }, txt: "Desc"),
                    U_G_Menu.B_Desc(f: { f_callback( .tags) }, txt: "Tags"),
                    U_G_Menu.B_Desc(f: { f_callback( .duplicate) }, txt: "Dupli"),
                    U_G_Menu.B_Desc(f: { f_callback( .delete) }, txt: "Del"),
                    U_G_Menu.B_Desc(f: { f_callback( .info) }, txt: "Info")
            ]
            
            return U_G_Menu.Menu_Buttons.f_gen(d: arr, call_back_with_self: { (b : U_G_Button)->() in
                //happens on button click
                b.btn?.backgroundColor = Global.Constants.Colors.menu_button_color()//UIColor.orange
                b.btn?.setTitleColor(UIColor.black, for: .normal)
                b.btn?.showsTouchWhenHighlighted = true
            })
        }
        
        func calculate_frame_of_view_for_select_menu(view_frame : CGRect, type : Int) -> (()->CGRect)
        {
            let w = view_frame.width * 0.1
            var h = view_frame.height * 0.8
            let x = view_frame.width * 0.025
            let y = view_frame.height * 0.025
            
            if (type == 10) ||  (type == 11)
            {
                h = 0.5 * h
            }
            
            return {()->CGRect in return CGRect.init(x: x, y: y, width: w, height: h)}
        }
        
        let tmp = U_G_Menu.init(frame: ui_controller.view.frame.originAtZeroSameWidthHeight())
        tmp.f_frame_of_view = calculate_frame_of_view_for_select_menu(view_frame: ui_controller.view.frame, type : 0)
        //tmp.buttons = f_buttons_for_menu_select(f_callback: ui_controller.callback_from_Menu_Select, forType : forType)
        tmp.buttons = f_buttons_for_menu_select(f_callback: { (command : My_Enums.Select_Node_Options)->() in
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)} )
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.layer.cornerRadius = 12.0  } )
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.setTitleColor(UIColor.white, for: .normal)  } )
            ui_controller.callback_from_Menu_Select(command: command)
        }, forType: forType)
        
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

