//
//  Menu_Main.swift
//  Holoss
//
//  Created by Rok Kosuta on 18/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

struct Menu_Main : Menu_Protocol
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
        return .main
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
        self.menu.isHidden = !self.menu.isHidden
    }
    
    var menu : U_G_Menu
    
    init(ui_controller : UI_Controller)
    {
        self.menu = Menu_Main.main_create(ui_controller : ui_controller)
        ui_controller.view.addSubview(self.menu)
    }
    
    //public
    
    
    //private
    private static func main_create(ui_controller : UI_Controller) -> U_G_Menu
    {
        func f_buttons_for_main_menu(f_callback : @escaping (My_Enums.Menu_Main_Option)->()) -> [U_G_Button]
        {
            var arr :  [U_G_Menu.B_Desc] = []
            
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .move_object ) }, txt: "🕹️"))
            arr.append( U_G_Menu.B_Desc(f: { f_callback(.move_world) }, txt: "🌐") )
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .select) }, txt: "☝🏻") )
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .create) }, txt:"🏗️"))//"Create") )
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .menu) }, txt: "🏠") )
            return U_G_Menu.Menu_Buttons.f_gen(d: arr, call_back_with_self: { (b : U_G_Button)->() in
                b.btn?.backgroundColor =  Global.Constants.Colors.menu_button_color() //UIColor.rgbaFrom0to255(r: 78, g: 99, b: 142, a: 100) //UIColor.orange //UIColor.rgbaFrom0to255(r: 119, g: 136, b: 170, a: 255)
                b.btn?.setTitleColor(UIColor.black, for: .normal)
                b.btn?.showsTouchWhenHighlighted = true
            })
        }
        
        func calculate_frame_of_view_for_main_menu(view_frame : CGRect)-> (()->CGRect)
        {
            let w = view_frame.width
            let h = view_frame.height * CGFloat(0.075)
            let x = view_frame.width * CGFloat(0.0)
            let y = (view_frame.height) - h
            
            return {() -> CGRect in return CGRect.init(x: x, y: y, width: w, height: h) }
        }
        
        var tmp = U_G_Menu.init(frame: ui_controller.view.frame.originAtZeroSameWidthHeight())
        tmp.vertical = false
        tmp.f_frame_of_view = calculate_frame_of_view_for_main_menu(view_frame: ui_controller.view.frame)
        
        
        tmp.buttons = f_buttons_for_main_menu(f_callback: { (command : My_Enums.Menu_Main_Option)->() in
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)} )
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.layer.cornerRadius = 10.0  } )
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.setTitleColor(UIColor.white, for: .normal)  } )
            ui_controller.callback_from_Menu_Main(command: command)
        })
        _ = tmp.create()
        
        //tmp.layer.cornerRadius = 50
        
        for button in tmp.buttons
        {
            button.btn?.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            button.btn?.layer.cornerRadius = 10.0
            button.btn?.setTitleColor(UIColor.white, for: .normal)
        }
        
        
        
        func lolek(menu : U_G_Menu, gesture : UIGestureRecognizer)
        {
            
            if let swipeGesture = gesture as? UISwipeGestureRecognizer
            {   switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                UIView.animate(withDuration: 1.0, animations: {
                    menu.frame = calculate_frame_of_view_for_main_menu(view_frame: ui_controller.view.frame)()
                    menu.update_to_fit_the_frame()
                    menu.layer.cornerRadius = 10.0
                }, completion: { (Bool)->Void  in  menu.update_to_fit_the_frame() } )
                
                
                
            case UISwipeGestureRecognizer.Direction.left:
                UIView.animate(withDuration: 1.0, animations: {
                    menu.frame = CGRect.init(x: menu.frame.origin.x, y: menu.frame.origin.y, width: ui_controller.view.frame.width * 0.5, height: menu.frame.height)
                    menu.layer.cornerRadius = 10.0
                    menu.update_to_fit_the_frame()
                }, completion: { (Bool)->Void  in  menu.update_to_fit_the_frame() } )
            default:
                break
                }
            }
            
            
        }
        
        tmp.addSwipeGesture()
        tmp.call_back_swipe.append( lolek )
        
        return tmp
    }
}

