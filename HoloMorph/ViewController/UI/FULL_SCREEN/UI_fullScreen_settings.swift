//
//  UI_fullScreen_settings.swift
//  Holoss
//
//  Created by Rok Kosuta on 22/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class UI_fullScreen_settings : UI_fullScreen_Generic, FullScreenProtocol
{
    private var label_grid = UILabel()
    private var seg_con_TDT : UISegmentedControl?
    private var seg_con_dTime : UISegmentedControl?
    private var seg_con_dDistance : UISegmentedControl?
    private var switch_feature_points : UISwitch?
    private var label_feature_points = UILabel()
    
    let switch_grid = UISwitch()
    
    //MARK: FullScreenProtocol method
    func delegate_show(parent_view: UIView)
    {
        Global.Animate.full_screen_show_example(duration: Global.settings.length_of_hide_full_fs_view(), view: self, parent_view: parent_view, while_hiden_f:  nil, completion_f: nil)
    }
    
    func delegate_did_finish_hidding()
    {
        
    }
    
    class func create(frame : CGRect, f_execute_before_closing : @escaping (UIView)->()) -> UI_fullScreen_settings
    {
        let res = UI_fullScreen_settings.init()
        res.create_internal(frame: frame)
        res.execute_before_closing = f_execute_before_closing
        return res
    }
    
    private func create_internal(frame : CGRect)
    {
        self.frame = frame.originAtZeroSameWidthHeight()
        self.backgroundColor = Global.Constants.Colors.standard_color_background_of_view()
        
        create_button_close()
        create_title_label(string: "Settings")
        
        switch_grid.setOn(false, animated: true)
        switch_grid.tintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        switch_grid.onTintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        switch_grid.thumbTintColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        switch_grid.addTarget(self, action: #selector(switch_grid_action(sender:)), for: UIControl.Event.valueChanged)
        switch_grid.frame = CGRect.init(x: frame.width * 0.05, y:  100, width: frame.width * 0.25, height: 50)
        switch_grid.layer.cornerRadius = 5.0
        switch_grid.setOn(true, animated: false)
        self.addSubview(switch_grid)
        
        label_grid.text = "Grid off"
        label_grid.frame = CGRect.init(x: frame.width * 0.05 + 70, y:  90, width: frame.width * 0.25, height: 50)
        self.addSubview(label_grid)
        
        //segment controll
        seg_con_TDT = UISegmentedControl(items: ["Tap","Time Dif"])
        seg_con_TDT?.center = CGPoint.init(x: self.frame.width * 0.5, y: label_grid.frame.origin.y + label_grid.frame.height + 20)
        seg_con_TDT?.backgroundColor = UIColor.gray
        seg_con_TDT?.tintColor = UIColor.white
        seg_con_TDT?.addTarget(self, action: #selector(segconChanged(_:)), for: UIControl.Event.valueChanged)
        seg_con_TDT?.selectedSegmentIndex = 0
        self.addSubview(seg_con_TDT!)
        seg_con_TDT?.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "seg_con_TDT_selectedSegmentIndex")
        segconChanged_update(v : UserDefaults.standard.integer(forKey: "seg_con_TDT_selectedSegmentIndex"))
        
        seg_con_dTime = UISegmentedControl(items: ["1s","0.5s","0.25s","0.1s","smalest"])
        seg_con_dTime?.center = CGPoint.init(x: self.frame.width * 0.5, y: seg_con_TDT!.center.y + 70)
        seg_con_dTime?.backgroundColor = UIColor.gray
        seg_con_dTime?.tintColor = UIColor.white
        seg_con_dTime?.addTarget(self, action: #selector(segconChanged_time(_:)), for: UIControl.Event.valueChanged)
        seg_con_dTime?.selectedSegmentIndex = 0
        
        if(UserDefaults.standard.integer(forKey: "seg_con_TDT_selectedSegmentIndex") == 0)
        {
            seg_con_dTime?.isHidden = true
        }
        else if(UserDefaults.standard.integer(forKey: "seg_con_TDT_selectedSegmentIndex") == 1)
        {
            seg_con_dTime?.isHidden = false
        }
        
        self.addSubview(seg_con_dTime!)
        
        seg_con_dTime?.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "seg_con_dTime_selectedSegmentIndex")
        update_segconChanged_time(v : UserDefaults.standard.integer(forKey: "seg_con_dTime_selectedSegmentIndex"))
        
        //feature points
        switch_feature_points = UISwitch.init()
        switch_feature_points?.tintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        switch_feature_points?.onTintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        switch_feature_points?.thumbTintColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        switch_feature_points?.frame = CGRect.init(x: self.frame.width * 0.1, y: seg_con_dTime!.frame.origin.y + 80, width: 50, height: 30)
        switch_feature_points?.addTarget(self, action: #selector(switch_fp_action(sender:)), for: UIControl.Event.valueChanged)
        self.addSubview(switch_feature_points!)
        
        label_feature_points.frame = CGRect.init(x: switch_feature_points!.frame.origin.x +  switch_feature_points!.frame.width + 10, y: switch_feature_points!.frame.origin.y, width: 150, height: 30)
        self.addSubview(label_feature_points)
        update_from_memory_switch_feature_points()
    }
    
    //FP
    @objc func switch_fp_action( sender : UISwitch)
    {
        update_new_state_feature_points()
    }
    
    func update_from_memory_switch_feature_points()
    {
        let fp = UserDefaults.standard.bool(forKey: "FP_show")
        if fp
        {
            label_feature_points.text = "FP Visibile"
            Global.GlobalVariables.vc?.sceneView.debugOptions =  [SCNDebugOptions.showFeaturePoints, SCNDebugOptions.showWorldOrigin]
        }
        else
        {
            label_feature_points.text = "FP Hidden"
            Global.GlobalVariables.vc?.sceneView.debugOptions =  []
        }
    }
    
    func update_new_state_feature_points()
    {
        if let safe_switch_feature_point = switch_feature_points
        {
            UserDefaults.standard.set(safe_switch_feature_point.isOn, forKey: "FP_show")
        }
        update_from_memory_switch_feature_points()
    }
    
    // called when the value of SegmentedControl is changed.
    func segconChanged_update(v : Int)
    {
        switch v
        {
        case 0:
            print("case : Tap")
            seg_con_dTime?.isHidden = true
            seg_con_dDistance?.isHidden = true
            Global.GlobalVariables.object_creation_mode = .on_tap_event
            
        case 1:
            print("case : Time Dif")
            seg_con_dTime?.isHidden = false
            seg_con_dDistance?.isHidden = true
            Global.GlobalVariables.object_creation_mode = .on_time_difference
        default:
            print("Error")
        }
    }
    
    @objc func segconChanged(_ segcon: UISegmentedControl){
        
        UserDefaults.standard.set(segcon.selectedSegmentIndex, forKey: "seg_con_TDT_selectedSegmentIndex")
        segconChanged_update(v : segcon.selectedSegmentIndex)
        
    }
    
    func update_segconChanged_time( v : Int)
    {
        switch v
        {
        case 0:
            print("case 0: 1s ")
            Global.GlobalVariables.object_creation_time_difference = 1.0
        case 1:
            print("case 1: 0.5s")
            Global.GlobalVariables.object_creation_time_difference = 0.5
        case 2:
            print("case 2: 0.25s")
            Global.GlobalVariables.object_creation_time_difference = 0.25
        case 3:
            print("case 3: 0.125s")
            Global.GlobalVariables.object_creation_time_difference = 0.125
        case 4:
            print("case 4: smalest")
            Global.GlobalVariables.object_creation_time_difference = 0.0
        default:
            print("Error")
        }
    }
    
    @objc func segconChanged_time(_ segcon: UISegmentedControl)
    {
        UserDefaults.standard.set(segcon.selectedSegmentIndex, forKey:"seg_con_dTime_selectedSegmentIndex")
        update_segconChanged_time(v : segcon.selectedSegmentIndex)
    }
    
    func update_on_start()
    {
        Global.GlobalVariables.grid_should_be_desplayed = UserDefaults.standard.bool(forKey: "display_grid")
        switch_grid.setOn(Global.GlobalVariables.grid_should_be_desplayed , animated: true)
        
        
    }
    
    @objc func switch_grid_action( sender : UISwitch)
    {
        print("switch_grid_action is : ",sender.isOn)
        if sender.isOn
        {
            label_grid.text = "Grid on"
            UserDefaults.standard.set(true,forKey: "display_grid")
        }
        else
        {
            label_grid.text = "Grid off"
            UserDefaults.standard.set(false,forKey: "display_grid")
        }
        
        Global.GlobalVariables.grid_should_be_desplayed = sender.isOn
        
    }
    
    @objc override func button_close_action()
    {
        self.execute_before_closing?(self)
        //delegate?.settings_FullScreen_delegate__close()
    }
}

