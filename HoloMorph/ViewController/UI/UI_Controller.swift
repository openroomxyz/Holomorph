//
//  Controller_User_interface_new.swift
//  Holoss
//
//  Created by Rok Kosuta on 13/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit
import ARKit

struct UI_Controller
{
    
    var view : UIView
    var delegate : Controller_user_interface_new_Delegate
    var fs : Custom_full_screens = Custom_full_screens.init()
    
    var ui_slider : UI_RotationScaleSliders?
    var ui_statusSession : UI_StatusSession?
    
    
    init(main_view : UIView, delegate : Controller_user_interface_new_Delegate)
    {
        self.view = main_view
        self.delegate = delegate
        
        self.ui_statusSession = init_ui_statusSession(view: self.view)
        self.ui_slider = init_slider(view: self.view, f_on_change: self.delegate.delegate_user_interface_rotation_and_scale)
        
        fs.setup(view: self.view, delegate: self)
        UI_menu_Controller.setup(ui_controller: self)
        
        self.view.hideAllSubviews()
        UI_menu_Controller.cl_menu_main?.menu.isHidden = false
    }
}

//MARK: init objects
extension UI_Controller
{
    func init_ui_statusSession(view : UIView) -> UI_StatusSession
    {
        let status = UI_StatusSession()
        status.create(parent_view: view)
        status.visible()
        return status
    }
    
    func init_slider(view  : UIView, f_on_change : @escaping (SCNVector3, SCNVector3, Bool)->()) -> UI_RotationScaleSliders
    {
        let slider = UI_RotationScaleSliders.init()
        slider.create(frame: CGRect.init(x: view.frame.width * 0.65, y: view.frame.height * 0.1, width: view.frame.width * 0.35, height: 45 * 4))
        slider.add(view: self.view)
        slider.show()
        slider.f_slider_values_change = f_on_change
        return slider
    }
}

//MARK: method called when out of Full Screen
//TODO: change name of method
//TODO: why thay are 2 methods?
extension UI_Controller
{
    
    func state_out_of_full_screen()
    {
        self.view.hideAllSubviews()
        UI_menu_Controller.cl_menu_main?.menu.isHidden = false
        ui_slider?.show()
        ui_statusSession?.visible()
    }
    
    func state_out_of_full_screen_from_fs_view(view : UIView)
    {
        
        if view is UI_fullScreen_colorSelector
        {
            let cs = (view as! UI_fullScreen_colorSelector)
            if let safe_color = cs.get_selected_color()
            {
                if cs.was_color_selected
                {
                    self.delegate.delegate_new_color_selected(color: safe_color)
                }
            }
        }
        else if view is UI_fullScreen_description
        {
            self.delegate.delegate_user_interface_new_desription(desc: (view as! UI_fullScreen_description).get_description())
        }
        else if (view is UI_fullScreen_tags)
        {
            self.delegate.delegate_user_interface_new_tag_list(tag_list: (view as! UI_fullScreen_tags).get_taglist())
        }
        
        UIView.animate(withDuration: 0.2,
                       animations: { () -> Void in
                        view.frame = CGRect.init(x: view.frame.origin.x + view.frame.width, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
        }, completion: { (Bool) -> Void in
            (view as? FullScreenProtocol)?.delegate_did_finish_hidding()
            self.state_out_of_full_screen()
            view.frame = self.view.frame.originAtZeroSameWidthHeight()
        })
        
        ui_slider?.show()
        ui_statusSession?.visible()
    }
    
}

//MARK: -calls from VC
extension UI_Controller
{
    func callback_from_ViewController_inSelectModeSelectedObjectOf(type : My_Enums.Node_Graph_Type_Of_Node)
    {
        print("show_select_object_menu_for_object_of_type :",type)
        UI_menu_Controller.select_menu_on_fly_create(ui_controller: self, forType: type)
    }
}

//MARK: Update number of object in current scene
extension UI_Controller
{
    func update_number_of_objects_in_current_scene(v : Int, max_number : Int)
    {
        self.ui_statusSession?.max_value = max_number
        self.ui_statusSession?.update_for_value(value: v)
    }
}

//MARK: Menu Menu Callback
extension UI_Controller
{
    func callback_from_Menu_Menu(selected_option: My_Enums.Menu_Menu_Option)
    {
        print("UIController delegate_UI_menu_menu_command : ", selected_option)
        
        if  Bool.or( (selected_option == .photo), (selected_option == .email) )
        {
            delegate.toggle_reaplay()
        }
        else if selected_option == .load_save_send
        {
            
        }
        else if selected_option == .delete_all
        {
            UI_menu_Controller.hide_all_beside_main_menu(ui_controller: self)
        }
        else
        {
            UI_menu_Controller.hide_all(ui_controller: self)
            fs.show(option: My_Enums.FullScreen_option.calculate_from__Menu_Menu_option(selected_option), ui_controller: self)
        }
        self.delegate.delegate_UI_menu_menu_command(selected_option: selected_option)
        ui_slider?.show()
        ui_statusSession?.visible()
    }
}


//MARK: Select Menu Callback
extension UI_Controller
{
    func callback_from_Menu_Select(command: My_Enums.Select_Node_Options)
    {
        print("UI_Controller callback_from_Menu_Select : ", command)
        if !Bool.or( (command == .duplicate), (command == .delete) )
        {
            print("hidde ! UI_Controller callback_from_Menu_Select : ", command)
            UI_menu_Controller.hide_all(ui_controller: self)
        }
        
        fs.show(option: My_Enums.FullScreen_option.calculate_from__select_node_options(command: command), ui_controller: self)
        delegate.delegate_user_interface__ObjectDependentSelectMenu__Selected(type: command)
    }
}

//MARK: Move Menu Callback
extension UI_Controller
{
    func callback_from_Menu_Move(command: My_Enums.Menu_World_Move_Option)
    {
        self.delegate.delegate_menu_move_command(command: command)
    }
}

//MARK: Create Menu Callback
extension UI_Controller
{
    func callback_from_Create_Menu(create_node_of_type: My_Enums.Node_Graph_Type_Of_Node)
    {
        print("UIController callback_from_Create_Menu :",create_node_of_type)
        delegate.delegate_user_interface__CreateMenu__Create(type: create_node_of_type)
    }
}

//MARK: Main Menu Callback
extension UI_Controller
{
    func callback_from_Menu_Main(command: My_Enums.Menu_Main_Option)
    {
        print("UI_Controller callback_from_Menu_Main : ", command)
        
        switch command
        {
        case .create :
            UI_menu_Controller.cl_menu_create?.delegate_togle(ui_controller: self)
            UI_menu_Controller.hide_all_beside(ui_controller: self, menuType: .create, hide_also_main_menu: false)
            self.ui_slider?.show()
        case .menu :
            UI_menu_Controller.cl_menu_menu?.delegate_togle(ui_controller: self)
            UI_menu_Controller.hide_all_beside(ui_controller: self, menuType: .menu, hide_also_main_menu: false)
            self.ui_slider?.hide()
        case .select :
            state_out_of_full_screen()
            UI_menu_Controller.hide_all_beside_main_menu(ui_controller: self)
            self.ui_slider?.hide()
        case .move_world :
            UI_menu_Controller.cl_menu_move?.delegate_togle(ui_controller: self)
            UI_menu_Controller.hide_all_beside(ui_controller: self, menuType: .move, hide_also_main_menu: false)
            self.ui_slider?.hide()
        case .move_object :
            UI_menu_Controller.hide_all_beside_main_menu(ui_controller: self)
            self.ui_slider?.hide()
        }
        
        delegate.delegate_user_interface__MainMenu__command(command: command)
    }
}

//MARK: Video Recording
extension UI_Controller
{
    func recording_video_on()
    {
        UI_menu_Controller.cl_menu_menu?.menu.buttons[1].btn?.setTitle(Global.Constants.Emoji.video_recording_press_to_stop(), for: .normal)
    }
    
    func recording_video_off()
    {
        UI_menu_Controller.cl_menu_menu?.menu.buttons[1].btn?.setTitle(Global.Constants.Emoji.video_recording_press_to_record(), for: .normal)
    }
}
