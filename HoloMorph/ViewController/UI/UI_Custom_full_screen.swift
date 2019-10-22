//
//  UI_Custom_full_screen.swift
//  Holoss
//
//  Created by Rok Kosuta on 15/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

protocol FullScreenProtocol
{
    func delegate_show(parent_view : UIView)
    func delegate_did_finish_hidding()
}

struct Custom_full_screens
{
    var color_selector : UI_fullScreen_colorSelector?
    var export : UI_fullScreen_export?
    var settings : UI_fullScreen_settings?
    var info : UI_fullScreen_info?
    var description : UI_fullScreen_description?
    var tags : UI_fullScreen_tags?
    var text_keybord : UI_keybord_textCreate?
    
    func show(option : My_Enums.FullScreen_option?, ui_controller : UI_Controller)
    {
        if let safe_option = option
        {
            if safe_option == .color_selection
            {
                self.color_selector?.delegate_show(parent_view: ui_controller.view)
            }
            else if safe_option == .info
            {
                self.info?.info = ui_controller.delegate.delegate_user_interface_get_info_data()
                self.info?.delegate_show(parent_view: ui_controller.view)
            }
            else if safe_option == .description
            {
                self.description?.set_description(description: ui_controller.delegate.delegate_user_interface_get_description())
                self.description?.delegate_show(parent_view: ui_controller.view)
            }
            else if safe_option == .tags
            {
                self.tags?.set_tag_list(tag_list : ui_controller.delegate.delegate_user_interface_get_tag_list())
                self.tags?.delegate_show(parent_view: ui_controller.view)
            }
            else if safe_option == .color_selection
            {
                self.color_selector?.delegate_show(parent_view: ui_controller.view)
            }
            else if safe_option == .settings
            {
                self.settings?.delegate_show(parent_view: ui_controller.view)
            }
            else if safe_option == .export
            {
                self.export?.delegate_show(parent_view: ui_controller.view)
            }
        }
        
        
    }
    
    mutating func setup(view : UIView, delegate : UI_Controller)
    {
        let frame = view.frame
        
        color_selector = UI_fullScreen_colorSelector.create(set_frame: frame, f_execute_before_closing:  delegate.state_out_of_full_screen_from_fs_view)
        export = UI_fullScreen_export.create(frame: frame, f_execute_before_closing:  delegate.state_out_of_full_screen_from_fs_view)
        settings = UI_fullScreen_settings.create(frame: frame, f_execute_before_closing:  delegate.state_out_of_full_screen_from_fs_view)
        info = UI_fullScreen_info.create(frame: frame, f_execute_before_closing:  delegate.state_out_of_full_screen_from_fs_view)
        description = UI_fullScreen_description.create(frame: frame, f_execute_before_closing:  delegate.state_out_of_full_screen_from_fs_view)
        tags = UI_fullScreen_tags.create(frame: frame, f_execute_before_closing:  delegate.state_out_of_full_screen_from_fs_view)
        text_keybord = UI_keybord_textCreate.create(frame: frame, f_execute_before_closing:  delegate.state_out_of_full_screen_from_fs_view)
        
        view.addSubview(color_selector!)
        view.addSubview(export!)
        view.addSubview(settings!)
        view.addSubview(info!)
        view.addSubview(description!)
        view.addSubview(tags!)
        view.addSubview(text_keybord!)
    }
    
    
}

