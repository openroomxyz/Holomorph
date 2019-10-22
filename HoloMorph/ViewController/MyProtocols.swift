//
//  MyProtocols.swift
//  Holoss
//
//  Created by Rok Kosuta on 06/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit
import ARKit


//protocol new
protocol Controller_user_interface_new_Delegate //Controller_user_interface_new -> ViewController
{
    
    //func delegate_user_interface_entered_text(str : String)
    
    func delegate_user_interface_new_tag_list(tag_list : Tag_List)
    func delegate_user_interface_get_tag_list() -> Tag_List
    func delegate_user_interface_get_description() -> Description
    func delegate_user_interface_new_desription(desc : Description)
    
    func delegate_user_interface_get_info_data() -> Info_Data
    func delegate_selected_from_SC_Controller(sel : My_Enums.Node_Graph_Type_Of_Node)
    func delegate_user_interface__ObjectDependentSelectMenu__Selected(type: My_Enums.Select_Node_Options)
    
    //menu menu
    func delegate_UI_menu_menu_command(selected_option : My_Enums.Menu_Menu_Option)
    
    //menu move world
    func delegate_menu_move_command( command : My_Enums.Menu_World_Move_Option)
    
    //main menu
    func delegate_user_interface__MainMenu__command(command : My_Enums.Menu_Main_Option)
    
    //create menu
    func delegate_user_interface__CreateMenu__Create(type : My_Enums.Node_Graph_Type_Of_Node)
    
    
    //mode things
    func delegate_new_color_selected(color : UIColor)
    
    //rotation & scale
    func delegate_user_interface_rotation_and_scale(rotation : SCNVector3, scale : SCNVector3, additive_vs_multiplicative : Bool)
    
    func toggle_reaplay()
}

//UI views
protocol Controller_user_interface_Delegate
{
    func controller_user_interface_delegate_event(data : String)
    func controller_user_interface_delegate_event_colorSelected(color : UIColor)
    func controller_user_interface_delegate_event_select_tool(tool_index : Int)
    func delegate_user_interface_load_VC_show()
}

protocol Controller_user_interface_main_menu_delegate
{
    func controller_user_interface_main_menu_delegate__event_save()
    func controller_user_interface_main_menu_delegate__event_create()
    func controller_user_interface_main_menu_delegate__event_load()
    func controller_user_interface_main_menu_delegate__event_move()
    func controller_user_interface_main_menu_delegate__event_email()
    func controller_user_interface_main_menu_delegate__event_clear()
    func controller_user_interface_main_menu_delegate__event_menu()
}

protocol MyMenu_delegate
{
    func my_menu_delegate_photo()
    func my_menu_delegate_mod()
    func my_menu_delegate_color()
    func my_menu_delegate_move()
    func my_menu_delegate_create()
}

protocol MyColorSelectorMenu_delegate
{
    func myColorSelectorMenu_delegate__event_new_color_selected(color : UIColor)
}

protocol MyCreateMenu_delegate
{
    func myCreateMenu_delegate_selected_object(type : Int)
}
