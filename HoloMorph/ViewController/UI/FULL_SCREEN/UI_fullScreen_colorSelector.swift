//
//  UI_fullScreen_colorSelector.swift
//  Holoss
//
//  Created by Rok Kosuta on 22/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

/*
 protocol UI_FullScreen_ColorSelector_delegate
 {
 func colorSelector_FullScreen_delegate__selectedColor(color : UIColor)
 func colorSelector_FullScreen_delegate__close()
 }
 */

class UI_fullScreen_colorSelector : UI_fullScreen_Generic, FullScreenProtocol
{
    //MARK: FullScreenProtocol method
    func delegate_show(parent_view: UIView)
    {
        print("delegate_show")
        /*
         Global.animate.hide_full_screen_example(duration: 1.0,
         view: self,
         parent_view: parent_view,
         while_hiden_f: { (UIView)->() in self.show()},
         completion_f: nil)
         */
        
        Global.Animate.full_screen_show_example(duration: Global.settings.length_of_hide_full_fs_view(), view: self, parent_view: parent_view, while_hiden_f: { (UIView)->() in self.show()}, completion_f: nil)
        
        /*
         self.isHidden = true
         self.show()
         self.frame = CGRect.init(x: parent_view.frame.width, y: 0.0, width: parent_view.frame.width, height: parent_view.frame.height)
         self.isHidden = false
         UIView.animate(withDuration: 1.0,
         animations: { () -> Void in
         self.frame = parent_view.frame.originAtZeroSameWidthHeight()
         }, completion: { (Bool) -> Void in
         
         })
         */
    }
    
    func delegate_did_finish_hidding()
    {
        print("UI_fullScreen_colorSelector delegate_did_finish_hidding")
        self.on_SC()
        self.image_view?.removeFromSuperview()
        self.image_view = nil;
        self.was_color_selected = false
    }
    
    private var image_view : UIImageView?
    private var image_view_selected_color : UIImageView?
    private var button_select : UIButton?
    
    private var currently_selected_color : UIColor?
    private var out_sected_color : UIColor?
    //private var delegate : UI_FullScreen_ColorSelector_delegate?
    
    var  was_color_selected = false
    
    
    
    func color_for_x_y(x : CGFloat, y : CGFloat) -> UIColor
    {
        let point = CGPoint.init(x: x, y: y)
        /*
         return UIColor.init(red:( point.distance(toPoint: CGPoint.init(x: 0.5, y: 0.5)) * 0.8 ).limit_between_0_and_1(),
         green:( point.distance(toPoint: CGPoint.init(x: 0.3, y: 0.8)) * 0.8 ).limit_between_0_and_1(),
         blue:( point.distance(toPoint: CGPoint.init(x: 0.7, y: 0.8)) * 0.8 ).limit_between_0_and_1(),
         alpha: 1.0)
         */
        return UIColor.init(red:( point.distance(toPoint: CGPoint.init(x: 0.5, y: 0.1)) * 0.5 ).limit_between_0_and_1(),
                            green:( point.distance(toPoint: CGPoint.init(x: 0.1, y: 0.9)) * 0.5 ).limit_between_0_and_1(),
                            blue:( point.distance(toPoint: CGPoint.init(x: 0.9, y: 0.9)) * 0.5 ).limit_between_0_and_1(),
                            alpha: 1.0)
    }
    
    func get_selected_color() -> UIColor?
    {
        print("lolekbolek 000")
        return self.out_sected_color
    }
    
    private func createImageForColorPalete(color : UIColor, size : CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        for x in 0 ... Int(size.width)
        {
            for y in 0 ... Int(size.height)
            {
                color_for_x_y(x: (x.CGFloat_value / size.width), y: (y.CGFloat_value / size.height)).setFill()
                UIRectFill(CGRect.init(x: x.CGFloat_value, y: y.CGFloat_value, width: 1.0, height: 1.0))
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    @objc func handlePan(panGesture : UIPanGestureRecognizer)
    {
        let point = panGesture.location(in: self)
        
        self.currently_selected_color = color_for_x_y(x: (point.x / self.frame.width), y: (point.y / self.frame.height))
        
        print("PAN WOW" + String(describing: point)+" color: "+String(describing: self.currently_selected_color!))
        
        self.image_view_selected_color!.image = UIImage.createImageWithColor(color: self.currently_selected_color!, size: CGSize.init(width: 1, height: 1))
    }
    
    @objc func button_select_action(sender : UIButton!)
    {
        print("color selct __  button_select_action")
        
        self.was_color_selected = true
        self.out_sected_color = self.currently_selected_color;
        /*
         if let safe_delegate = self.delegate
         {
         safe_delegate.colorSelector_FullScreen_delegate__selectedColor(color: self.out_sected_color!)
         }
         */
        hide()
        
        //self.on_SC()
    }
    
    class func create(set_frame : CGRect, f_execute_before_closing : @escaping (UIView)->()) -> UI_fullScreen_colorSelector//, delegate : UI_FullScreen_ColorSelector_delegate) -> UI_fullScreen_colorSelector
    {
        let res = UI_fullScreen_colorSelector.init()
        res.execute_before_closing = f_execute_before_closing
        _ = res.create_internal(set_frame: set_frame)//, delegate: delegate)
        return res
    }
    
    private func create_internal(set_frame : CGRect) -> UI_fullScreen_colorSelector//, delegate : UI_FullScreen_ColorSelector_delegate) -> UI_fullScreen_colorSelector
    {
        //self.delegate = delegate
        self.backgroundColor = UIColor.blue
        self.frame = set_frame
        
        self.currently_selected_color = UIColor.orange
        self.out_sected_color = UIColor.orange
        
        hide()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(panGesture:)))
        self.addGestureRecognizer(panGesture)
        
        self.isUserInteractionEnabled = true
        
        self.button_select = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 60))
        button_select!.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        button_select!.setTitle("Select", for: .normal)
        button_select!.setTitleColor(UIColor.black, for: .normal)
        button_select!.addTarget(self, action:  #selector(button_select_action), for: .touchUpInside)
        self.addSubview(button_select!)
        
        
        create_button_close()
        create_title_label(string: "Color Full Screen")
        return self
        
    }
    
    private func show()
    {
        //self.isHidden = false
        
        self.off_SC()
        
        self.image_view = UIImageView.init(frame:  frame.originAtZeroSameWidthHeight())
        self.addSubview(self.image_view!)
        self.image_view?.image = createImageForColorPalete(color: UIColor.gray, size: CGSize.init(width: 350, height: 350))
        
        self.image_view_selected_color = UIImageView.init(frame : CGRect.init(x: 100, y: 30, width: 50, height: 50))
        self.image_view_selected_color?.image = UIImage.createImageWithColor(color: self.currently_selected_color!, size: CGSize.init(width: 1, height: 1))
        self.addSubview(self.image_view_selected_color!)
        
        create_button_close()
        self.bringSubviewToFront(button_select!)
        self.bringSubviewToFront(button_close!)
        self.bringSubviewToFront(self.image_view_selected_color!)
    }
    
    
    
    private func hide()
    {
        self.execute_before_closing?(self)
    }
    
    
    @objc override func button_close_action()
    {
        hide() //delegate?.colorSelector_FullScreen_delegate__close()
    }
    
    func selected_color() -> UIColor
    {
        return self.out_sected_color!
    }
}

/*
 private func hide()
 {
 //self.isHidden = true;
 
 
 self.on_SC()
 self.execute_before_closing?(self)
 
 self.image_view?.removeFromSuperview()
 self.image_view = nil;
 }
 */

