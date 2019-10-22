//
//  Controller_User_interface_new_FS_Utility.swift
//  Holoss
//
//  Created by Rok Kosuta on 13/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit
import UIKit

class UI_Controller_Utility_FactoryOfFullScreens
{
    
    private class func create_generic_full_screen(vc : UI_Controller, text : String, close_selector : Selector) -> UIView
    {
        
        let out_view = UIView.init(frame: vc.view.frame.originAtZeroSameWidthHeight() )
        
        let center_h = vc.view.frame.width * 0.5
        
        let button_close = UIButton.init(frame: CGRect.init(x:10, y: 20, width: 50, height: 50))
        button_close.backgroundColor = UIColor.orange
        button_close.setTitle("X", for: .normal)
        button_close.setTitleColor(UIColor.black, for: .normal)
        button_close.addTarget(vc, action: close_selector, for: .touchUpInside)
        button_close.layer.cornerRadius = 5.0
        out_view.addSubview(button_close)
        
        let label = UILabel(frame: CGRect.init(x: center_h - 100, y: 28, width: 200, height: 21))
        label.text =  text
        //label.backgroundColor = UIColor.purple
        label.textAlignment = .center
        out_view.addSubview(label)
        
        out_view.backgroundColor = UIColor.gray
        
        return out_view
    }
    
    class func create_info_full_screen(vc : UI_Controller, close_selector : Selector) -> UIView
    {
        return create_generic_full_screen(vc: vc, text: "info", close_selector: close_selector)
    }
    
    class func create_fs_selectInfo(vc : UI_Controller, close_selector : Selector) -> UIView
    {
        return create_generic_full_screen(vc: vc, text: "Select Info", close_selector: close_selector)
    }
    
    class func create_fs_selectOther(vc : UI_Controller, close_selector : Selector) -> UIView
    {
        return create_generic_full_screen(vc: vc, text: "Select Other", close_selector: close_selector)
    }
    
}





