//
//  UI_RotationScaleSliders.swift
//  Holoss
//
//  Created by Rok Kosuta on 04/03/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class UI_RotationScaleSliders : NSObject
{
    private var view_slider : UIView?
    
    private var sliders_XYZ : SlidersXYZ?
    
    private var switch_scale_or_rotation : UISwitch?
    private var switch_scale_or_rotation_image_view : UIImageView?
    
    private var switch_multiplative_or_aditive_rotation : UISwitch?
    private var switch_multiplative_or_aditive_rotatioN_image_view : UIImageView?
    
    private var button_close : UIButton?
    public var f_slider_values_change : ( (SCNVector3, SCNVector3, Bool)->())?
    
    private var scale : SCNVector3 = SCNVector3.one
    private var rotation : SCNVector3 = SCNVector3.one
    
    func create(frame : CGRect)
    {
        let h_enota = frame.height * (1.0 / 4.0)
        let min_value : Float = Float.zero
        let max_value : Float = Float.one
        
        view_slider = UIView.init(frame: frame)
        view_slider?.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
        view_slider?.layer.cornerRadius = 5.0
        
        switch_scale_or_rotation = UISwitch()
        switch_scale_or_rotation?.setOn(false, animated: true)
        switch_scale_or_rotation?.tintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.2, alpha: 0.1)
        switch_scale_or_rotation?.onTintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
        switch_scale_or_rotation?.thumbTintColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
        switch_scale_or_rotation?.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
        switch_scale_or_rotation?.addTarget(self, action: #selector(switch_changed(sender:)), for: UIControl.Event.valueChanged)
        switch_scale_or_rotation!.frame = CGRect.init(x: 0, y: h_enota * 0.0, width: frame.width * 0.4, height: h_enota)
        switch_scale_or_rotation?.layer.cornerRadius = 5.0
        view_slider?.addSubview(switch_scale_or_rotation!)
        
        self.switch_scale_or_rotation_image_view = UIImageView.init(frame: CGRect.init(x: switch_scale_or_rotation!.frame.origin.x, y: switch_scale_or_rotation!.frame.height, width: switch_scale_or_rotation!.frame.width, height: 20) )
        self.switch_scale_or_rotation_image_view?.image =  Global.construct.generate_image_from_UILabel(text: Global.Constants.scale_unicode_string(), size:  CGSize.init(width: switch_scale_or_rotation!.frame.width, height: switch_scale_or_rotation!.frame.height))
        view_slider?.addSubview(self.switch_scale_or_rotation_image_view!)
        
        switch_multiplative_or_aditive_rotation = UISwitch()
        switch_multiplative_or_aditive_rotation?.setOn(false, animated: true)
        switch_multiplative_or_aditive_rotation?.tintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.2, alpha: 0.1)
        switch_multiplative_or_aditive_rotation?.onTintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
        switch_multiplative_or_aditive_rotation?.thumbTintColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
        switch_multiplative_or_aditive_rotation?.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
        switch_multiplative_or_aditive_rotation?.addTarget(self, action: #selector(switch_changed_mult_add(sender:)), for: UIControl.Event.valueChanged)
        switch_multiplative_or_aditive_rotation!.frame = CGRect.init(x: frame.width * 0.4, y:  h_enota * 0.0, width: frame.width * 0.25, height: h_enota)
        switch_multiplative_or_aditive_rotation?.layer.cornerRadius = 5.0
        view_slider?.addSubview(switch_multiplative_or_aditive_rotation!)
        
        switch_multiplative_or_aditive_rotatioN_image_view = UIImageView.init(frame: CGRect.init(x: switch_multiplative_or_aditive_rotation!.frame.origin.x, y: switch_multiplative_or_aditive_rotation!.frame.height, width: switch_multiplative_or_aditive_rotation!.frame.width, height: 20))
        switch_multiplative_or_aditive_rotatioN_image_view?.image = Global.construct.generate_image_from_UILabel(text: Global.Constants.locked_to_camera_string())
        view_slider?.addSubview(switch_multiplative_or_aditive_rotatioN_image_view!)
        
        func create_button_close(frame : CGRect) -> UIButton
        {
            let btn = UIButton()
            btn.frame = frame
            btn.layer.cornerRadius = 15.0
            btn.addTarget(self, action: #selector(self.button_event), for: .touchUpInside)
            btn.setTitle("X", for: .normal)
            btn.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            return btn
        }
        button_close = create_button_close(frame : CGRect.init(x: frame.width * 0.75, y: h_enota * 0.0, width: frame.width * 0.25, height: h_enota * 0.75))
        view_slider?.addSubview(button_close!)
        
        self.sliders_XYZ = SlidersXYZ.CreateSliders(frame: frame,
                                                   min_value: min_value,
                                                   max_value: max_value,
                                                   target: self,
                                                   s1: #selector(self.sliderXValueDidChange(_:)),
                                                   s2: #selector(self.sliderYValueDidChange(_:)),
                                                   s3: #selector(self.sliderZValueDidChange(_:)),
                                                   f_img_gen: Global.construct.generate_image_from_UILabel,
                                                   f_add_as_subview: view_slider!.addSubview)
    }
    
    @objc func button_event()
    {
        print("button_event")
        
        if self.sliders_XYZ!.isHidden()
        {
            self.sliders_XYZ?.visability(isHidden: false)
            self.view_slider?.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
            self.switch_multiplative_or_aditive_rotation?.isHidden = false
            self.switch_scale_or_rotation?.isHidden = false
            self.button_close?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
            self.switch_scale_or_rotation_image_view?.isHidden = false
            self.switch_multiplative_or_aditive_rotatioN_image_view?.isHidden = false
        }
        else
        {
            self.sliders_XYZ?.visability(isHidden: true)
            self.view_slider?.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.0)
            self.switch_multiplative_or_aditive_rotation?.isHidden = true
            self.switch_scale_or_rotation?.isHidden = true
            self.button_close?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
            self.switch_scale_or_rotation_image_view?.isHidden = true
            self.switch_multiplative_or_aditive_rotatioN_image_view?.isHidden = true
        }
    }
    
    
    @objc func switch_changed(sender: UISwitch!)
    {
        print("Switch value is \(sender.isOn)")
        if switch_scale_or_rotation!.isOn
        {
            self.sliders_XYZ!.set_value(vec: self.rotation)
            self.switch_scale_or_rotation_image_view?.image = Global.construct.generate_image_from_UILabel(text: Global.Constants.rotate_unicode_string(), size:  CGSize.init(width: switch_scale_or_rotation!.frame.width, height: switch_scale_or_rotation!.frame.height))
        }
        else
        {
            self.sliders_XYZ!.set_value(vec: self.scale)
            self.switch_scale_or_rotation_image_view?.image = Global.construct.generate_image_from_UILabel(text: Global.Constants.scale_unicode_string(), size:  CGSize.init(width: switch_scale_or_rotation!.frame.width, height: switch_scale_or_rotation!.frame.height))
        }
    }
    
    
    @objc func switch_changed_mult_add(sender : UISwitch!)
    {
        print("switch_changed_mult_add", sender.isOn)
        if sender.isOn
        {
            switch_multiplative_or_aditive_rotatioN_image_view?.image = Global.construct.generate_image_from_UILabel(text: Global.Constants.unlocked_to_camera_string())
        }
        else
        {
            switch_multiplative_or_aditive_rotatioN_image_view?.image = Global.construct.generate_image_from_UILabel(text: Global.Constants.locked_to_camera_string())
        }
        self.f_slider_values_change?(rotation, scale, switch_multiplative_or_aditive_rotation!.isOn)
        
    }
    
    @objc func sliderXValueDidChange(_ sender:UISlider!)
    {
        switch_scale_or_rotation!.isOn ? (self.rotation.x = sender.value) : (self.scale.x = sender.value)
        self.f_slider_values_change?(rotation, scale, switch_multiplative_or_aditive_rotation!.isOn)
    }
    
    @objc func sliderYValueDidChange(_ sender:UISlider!)
    {
        switch_scale_or_rotation!.isOn ? (self.rotation.y = sender.value) : ( self.scale.y = sender.value)
        self.f_slider_values_change?(rotation, scale, switch_multiplative_or_aditive_rotation!.isOn)
    }
    
    @objc func sliderZValueDidChange(_ sender:UISlider!)
    {
        switch_scale_or_rotation!.isOn ? (self.rotation.z = sender.value) : (self.scale.z = sender.value)
        self.f_slider_values_change?(rotation, scale, switch_multiplative_or_aditive_rotation!.isOn)
    }
    
    func show()
    {
        self.view_slider?.isHidden = false
    }
    
    func hide()
    {
        self.view_slider?.isHidden = true
    }
    
    func add(view : UIView)
    {
        view.addSubview(self.view_slider!)
    }
}


extension UI_RotationScaleSliders
{
    private struct SlidersXYZ
    {
        let x : UISlider
        let y : UISlider
        let z : UISlider
        
        func set_value(vec : SCNVector3)
        {
            self.x.value = vec.x
            self.y.value = vec.y
            self.z.value = vec.z
        }
        
        func get_value() -> SCNVector3
        {
            return SCNVector3.init(x: self.x.value, y: self.y.value, z: self.z.value)
        }
        
        func visability(isHidden : Bool)
        {
            self.x.isHidden = isHidden
            self.y.isHidden = isHidden
            self.z.isHidden = isHidden
        }
        
        func isHidden() -> Bool
        {
            return self.x.isHidden
        }
        
        static func CreateSliders(frame : CGRect, min_value : Float, max_value : Float, target : Any?, s1 : Selector, s2 : Selector, s3 : Selector, f_img_gen : @escaping (String, CGSize, UIColor)->UIImage, f_add_as_subview : (UIView)->()) -> SlidersXYZ
        {
            func create_slider(letter : String, frame : CGRect, min_value : Float, max_value : Float, target : Any?, action : Selector) -> UISlider
            {
                let sl = UISlider.init(frame: frame)
                let img = f_img_gen(letter, CGSize.init(width: 30, height: 30), UIColor.rgbaFrom0to255(r: 119, g: 136, b: 170, a: 255))
                sl.minimumValue = min_value
                sl.maximumValue = max_value
                sl.isContinuous = true
                sl.tintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.5, alpha: 0.15)
                sl.thumbTintColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
                sl.setThumbImage(img, for: .normal)
                sl.setThumbImage(img, for: .highlighted)
                sl.addTarget(target, action: action, for: .valueChanged)
                return sl
            }
            
            let h_enota = frame.height * (1.0 / 4.0)
            
            let n = SlidersXYZ(x: create_slider(letter: "X", frame: CGRect.init(x: 0, y: h_enota * 1.0, width: frame.width, height: h_enota), min_value: min_value, max_value: max_value, target: target, action: s1),
                               y: create_slider(letter: "Y", frame: CGRect.init(x: 0, y: h_enota * 2.0, width: frame.width, height: h_enota), min_value: min_value, max_value: max_value, target: target, action: s2),
                               z: create_slider(letter: "Z", frame: CGRect.init(x: 0, y: h_enota * 3.0, width: frame.width, height: h_enota), min_value: min_value, max_value: max_value, target: target, action: s3))
            
            f_add_as_subview(n.x)
            f_add_as_subview(n.y)
            f_add_as_subview(n.z)
            return n
        }
    }
}
