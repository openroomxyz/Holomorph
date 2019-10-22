//
//  UI_menu_Controller.swift
//  Holoss
//
//  Created by Rok Kosuta on 13/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit


protocol Menu_Protocol
{
    func delegate_show(ui_controller : UI_Controller)
    func delegate_hide(ui_controller : UI_Controller)
    func delegate_togle(ui_controller : UI_Controller)
    func delegate_hide_if_not_equal_type(type : UI_menu_Controller.MenuType, ui_controller : UI_Controller)
}

struct UI_menu_Controller
{
    static var cl_menu_main : Menu_Main?
    static var cl_menu_create : Menu_create?
    static var cl_menu_menu : Menu_Menu?
    static var cl_menu_move : Menu_Move?
    static var cl_menu_select : Menu_Select?
    
    enum MenuType
    {
        case main
        case create
        case menu
        case select
        case move
    }
    
    static func setup(ui_controller : UI_Controller)
    {
        cl_menu_main = Menu_Main.init(ui_controller: ui_controller)
        cl_menu_create = Menu_create.init(ui_controller: ui_controller)
        cl_menu_move = Menu_Move.init(ui_controller: ui_controller)
        cl_menu_menu = Menu_Menu.init(ui_controller: ui_controller)
    }
    
    static func hide_all_beside(ui_controller : UI_Controller, menuType : MenuType, hide_also_main_menu : Bool)
    {
        print("hide_all_beside alica!")
        if hide_also_main_menu
        {
            UI_menu_Controller.cl_menu_main?.delegate_hide_if_not_equal_type(type: menuType, ui_controller: ui_controller)
        }
        
        UI_menu_Controller.cl_menu_create?.delegate_hide_if_not_equal_type(type: menuType, ui_controller: ui_controller)
        UI_menu_Controller.cl_menu_menu?.delegate_hide_if_not_equal_type(type: menuType, ui_controller: ui_controller)
        UI_menu_Controller.cl_menu_move?.delegate_hide_if_not_equal_type(type: menuType, ui_controller: ui_controller)
        UI_menu_Controller.cl_menu_select?.delegate_hide_if_not_equal_type(type: menuType, ui_controller: ui_controller)
    }
    
    static func hide_all_beside_main_menu(ui_controller : UI_Controller)
    {
        hide_all_beside(ui_controller: ui_controller, menuType: .main, hide_also_main_menu : false)
    }
    
    static func hide_all(ui_controller : UI_Controller)
    {
        print("hide_all")
        UI_menu_Controller.cl_menu_main?.delegate_hide(ui_controller: ui_controller)
        UI_menu_Controller.cl_menu_create?.delegate_hide(ui_controller: ui_controller)
        UI_menu_Controller.cl_menu_menu?.delegate_hide(ui_controller: ui_controller)
        UI_menu_Controller.cl_menu_move?.delegate_hide(ui_controller: ui_controller)
        UI_menu_Controller.cl_menu_select?.delegate_hide(ui_controller: ui_controller)
    }
    
    static func select_menu_on_fly_create(ui_controller : UI_Controller, forType : My_Enums.Node_Graph_Type_Of_Node)
    {
        if UI_menu_Controller.cl_menu_select != nil
        {
            UI_menu_Controller.cl_menu_select?.menu.removeFromSuperview()
            UI_menu_Controller.cl_menu_select = nil
        }
        UI_menu_Controller.cl_menu_select = Menu_Select(ui_controller: ui_controller, forType: forType)
    }
    
}

