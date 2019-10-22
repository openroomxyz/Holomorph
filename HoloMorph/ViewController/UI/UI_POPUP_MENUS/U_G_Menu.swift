//
//  UI_G_Menu.swift
//  Holoss
//
//  Created by Rok Kosuta on 14/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

class U_G_Button
{
    var btn : UIButton?
    var method : (()->())?
    
    var method_with_self : ((U_G_Button)->())?
    
    func defaul_button(title_normal : String, bg_color : UIColor, title_color : UIColor) -> U_G_Button
    {
        self.btn = UIButton.init()
        self.btn!.setTitle(title_normal, for: .normal)
        self.btn!.backgroundColor = bg_color
        self.btn!.setTitleColor(title_color, for: .normal)
        
        self.btn!.addTarget(self, action: #selector(self.action), for: .touchUpInside)
        self.btn!.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        return self
    }
    
    @objc func action()
    {
        self.method?()
        self.method_with_self?(self)
    }
    
    func add(view : UIView) -> U_G_Button
    {
        if let safe_b = self.btn
        {
            view.addSubview(safe_b)
        }
        return self
    }
    
}

class U_G_Menu : UIView
{
    var buttons : [U_G_Button] = []
    var vertical : Bool = true
    
    var f_frame_of_view : (()-> CGRect)?
    var f_add_to_view : (()-> UIView)?
    
    var call_back_swipe : [((U_G_Menu, UIGestureRecognizer)->())] = []
    
    func create() -> U_G_Menu
    {
        if let safe_f_frame_of_view = f_frame_of_view
        {
            self.frame = safe_f_frame_of_view()
        }
        
        if let safe_f_add_to_view = f_add_to_view
        {
            safe_f_add_to_view().addSubview(self)
        }
        
        self.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.2, alpha: 0.3)
        
        for i in 0 ..< buttons.count
        {
            buttons[i].btn?.frame = U_G_Menu.calculate_button_frame(number_of_buttons: buttons.count, frame: frame, element: i, vertical: vertical)
            self.addSubview(buttons[i].btn!)
        }
        
        return self
    }
    
    func update_to_fit_the_frame()
    {
        for i in 0 ..< buttons.count
        {
            buttons[i].btn?.frame = U_G_Menu.calculate_button_frame(number_of_buttons: buttons.count, frame: frame, element: i, vertical: vertical)
        }
    }
    
    static func calculate_button_frame(number_of_buttons : Int, frame : CGRect, element : Int, vertical : Bool) -> CGRect
    {
        if vertical
        {
            let width_of_button : CGFloat = frame.width
            let height_of_button : CGFloat = frame.height / CGFloat(number_of_buttons)
            return CGRect.init(x: 0.0, y: height_of_button * CGFloat(element), width: width_of_button, height: height_of_button)
        }
        
        let width_of_button : CGFloat = frame.width / CGFloat(number_of_buttons)
        let height_of_button : CGFloat = frame.height
        return CGRect.init(x: width_of_button * CGFloat(element), y: 0.0, width: width_of_button, height: height_of_button)
    }
    
    func addSwipeGesture()
    {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.addGestureRecognizer(swipeLeft)
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        print("respondToSwipeGesture")
        _ = call_back_swipe.map{ $0(self, gesture) }
    }
    
    struct Menu_Buttons
    {
        static func f_gen(d : [B_Desc], call_back_with_self : ((U_G_Button)->())? )  -> [U_G_Button]
        {
            var n : [U_G_Button] = []
            for i in d
            {
                let tmp = U_G_Button.init().defaul_button(title_normal: i.txt, bg_color: UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2), title_color: UIColor.gray)
                tmp.method = i.f
                tmp.method_with_self = call_back_with_self
                n.append(tmp)
            }
            return n
        }
    }
    
    struct B_Desc
    {
        var f : ()->()
        var txt : String
        
    }
    
}



