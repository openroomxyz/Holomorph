//
//  Menu_create.swift
//  Holoss
//
//  Created by Rok Kosuta on 18/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

struct Menu_create : Menu_Protocol
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
        return .create
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
        Menu_create.menu_create_togle(ui_controller, m: self.menu, call_back_on_open:{ (U_G_Menu)->() in print("call_back_on_open menu_create")})
    }
    
    var menu : U_G_Menu
    
    init(ui_controller : UI_Controller)
    {
        self.menu = Menu_create.menu_create(ui_controller: ui_controller)
        ui_controller.view.addSubview(self.menu)
    }
    
    //private
    private static func menu_create(ui_controller : UI_Controller) -> U_G_Menu
    {
        
        func f_buttons_for_create_menu(f_callback : @escaping (My_Enums.Node_Graph_Type_Of_Node)->()) -> [U_G_Button]
        {
            var arr :  [U_G_Menu.B_Desc] = []
            
            arr.append( U_G_Menu.B_Desc(f: { f_callback(.box) }, txt: "Box") )
            arr.append( U_G_Menu.B_Desc(f: { f_callback(.sphere) }, txt: "Sphere") )
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .cone) }, txt: "Cone") )
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .cylinder) }, txt: "Cylinder") )
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .plane) }, txt: "Plane") )
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .pyramid) }, txt: "Pyramid") )
            arr.append( U_G_Menu.B_Desc(f: { f_callback(.torus) }, txt: "Torus") )
            arr.append( U_G_Menu.B_Desc(f: { f_callback( .tube) }, txt: "Tube") )
            
            //calll back here is on every button and we get reference to a button
            return U_G_Menu.Menu_Buttons.f_gen(d: arr, call_back_with_self: { (b : U_G_Button)->() in
                //happens on button click
                b.btn?.backgroundColor = Global.Constants.Colors.menu_button_color()
                b.btn?.setTitleColor(UIColor.black, for: .normal)
                b.btn?.showsTouchWhenHighlighted = true
            })
            //return U_G_Menu.Menu_Buttons.f_gen(d: arr, call_back_with_self: nil)
        }
        
        func f_create_menu(view_frame : CGRect) -> (()->CGRect)
        {
            let w = view_frame.width * 0.1
            let h = view_frame.height * 0.8
            let x = view_frame.width * 0.025
            let y = view_frame.height * 0.025
            
            return {() -> CGRect in return CGRect.init(x: x, y: y, width: w, height: h) }
        }
        
        
        let tmp = U_G_Menu.init(frame: ui_controller.view.frame.originAtZeroSameWidthHeight())
        tmp.f_frame_of_view = f_create_menu(view_frame: ui_controller.view.frame)
        //tmp.buttons = f_buttons_for_create_menu(f_callback: ui_controller.callback_from_Create_Menu)
        tmp.buttons = f_buttons_for_create_menu(f_callback: { (command : My_Enums.Node_Graph_Type_Of_Node)->() in
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)} )
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.layer.cornerRadius = 12.0  } )
            _ = tmp.buttons.map( { (b : U_G_Button) -> () in b.btn?.setTitleColor(UIColor.white, for: .normal)  } )
            ui_controller.callback_from_Create_Menu(create_node_of_type: command)
        } )
        
        for button in tmp.buttons
        {
            button.btn?.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            button.btn?.layer.cornerRadius = 12.0
            button.btn?.setTitleColor(UIColor.white, for: .normal)
        }
        
        _ = tmp.create()
        tmp.layer.cornerRadius = 12.0
        
        return tmp
    }
    
    private static func menu_create_togle(_ ui_controller : UI_Controller, m : U_G_Menu, call_back_on_open : @escaping (U_G_Menu)->())
    {
        func f_n(_ a : U_G_Menu,f : ()->()) { let h = !a.isHidden; f(); a.isHidden = h }
        
        func f_create_menu(view_frame : CGRect) -> (()->CGRect)
        {
            let w = view_frame.width * 0.1
            let h = view_frame.height * 0.8
            let x = view_frame.width * 0.025
            let y = view_frame.height * 0.025
            
            return {() -> CGRect in return CGRect.init(x: x, y: y, width: w, height: h) }
        }
        
        
        
        
        /*
         func something(length_in_time : Double, view : UIView, stateSelector : (UIView)->Bool, f_state_a : @escaping (UIView)->(), f_stabe_b : @escaping (UIView)->(), completion_f_a : @escaping (UIView)->(), completion_f_b : @escaping (UIView)->())
         {
         struct Running { static var running = false }
         
         func f(view : UIView, length : Double, f : @escaping (UIView)->(), completion_f : @escaping (UIView)->())
         {
         UIView.animate(withDuration: length_in_time,
         animations: { () -> Void in
         f(view)
         }, completion: { (Bool)-> Void in
         completion_f(view)
         })
         }
         
         if Running.running { }
         else
         {
         if stateSelector(view)
         {
         f(view: view, length: length_in_time, f: f_state_a, completion_f: completion_f_a)
         }
         else
         {
         f(view: view, length: length_in_time, f: f_stabe_b, completion_f: completion_f_b)
         }
         }
         }
         */
        //lol+
        /*
         something(length_in_time: 5,
         view: m,
         stateSelector: { return $0.isHidden },
         f_state_a: { (v : UIView)->() in
         Running.running = true
         m.frame = f_create_menu(view_frame: ui_controller.view.frame)()
         m.update_to_fit_the_frame()
         m.layer.cornerRadius = 10.0
         }, f_stabe_b: <#T##(UIView) -> ()#>, completion_f_a: <#T##(UIView) -> ()#>, completion_f_b: <#T##(UIView) -> ()#>)
         */
        //this is big deel now you can write code that waits to finish
        struct Running
        {
            static var running = false
            
            static var count = 0
            
            static func lol()
            {
                Running.count += 1
                print(Running.count)
            }
        }
        //TODO: this is a concept you will have to reuse look at closures captured values you have not been eyable todo until not big problem
        //Running.lol()
        
        /*
         func animateWithUIImageSnapst(uiview : UIView, to_frame : UIView)
         {
         
         }
         */
        
        if Running.running == false {
            
            if m.isHidden
            {
                m.isHidden = false
                call_back_on_open(m) //close opened menus
                
                UIView.animate(withDuration: 0.5, animations: {
                    Running.running = true
                    m.frame = f_create_menu(view_frame: ui_controller.view.frame)()
                    m.update_to_fit_the_frame()
                    m.layer.cornerRadius = 10.0
                }, completion: { (Bool)->Void  in
                    m.isHidden = false
                    Running.running = false
                } )
                
                
                
            }
            else
            {
                let n = m.screenshot
                var imageView : UIImageView?
                imageView = UIImageView.init(frame: m.frame.originAtZeroSameWidthHeight())
                imageView!.image = n
                imageView?.alpha = 1.0
                //imageView?.backgroundColor = UIColor.black
                
                m.addSubview( imageView! )
                m.bringSubviewToFront(imageView!)
                
                UIView.animate(withDuration: 0.5, animations: {
                    Running.running = true
                    m.frame = CGRect.init(x: 0, y: 0, width: m.frame.width, height: 10)
                    m.update_to_fit_the_frame()
                    imageView?.frame = CGRect.init(x: 0, y: 0, width: m.frame.width, height: 10)
                    
                }, completion: { (Bool)->Void  in
                    m.isHidden = true
                    imageView!.removeFromSuperview()
                    imageView!.image = nil
                    imageView = nil
                    Running.running = false
                } )
                // m.isHidden = true
            }
        }
    }
}

