//
//  UI_fullScreen_Generic.swift
//  Holoss
//
//  Created by Rok Kosuta on 22/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

class UI_fullScreen_Generic : UIView
{
    var button_close : UIButton?
    var execute_before_closing : ((UIView)->())?
    
    func create_title_label(string : String)
    {
        let center_h = self.frame.width * 0.5
        let label = UILabel(frame: CGRect.init(x: center_h - 100, y: 28, width: 200, height: 21))
        label.text =  string
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    func create_button_close()  //TODO: - MAKE ROUDED CORNES or ca-layer
    {
        self.button_close = UIButton.init(frame: CGRect.init(x: self.frame.width - 100, y: 0, width: 100, height: 60))
        self.button_close!.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        self.button_close!.setTitle("Close", for: .normal)
        self.button_close!.setTitleColor(UIColor.black, for: .normal)
        self.button_close!.addTarget(self, action:  #selector(button_close_action), for: .touchUpInside)
        self.button_close!.layer.cornerRadius = 5.0
        self.addSubview(self.button_close!)
    }
    
    func on_SC()
    {
        let nc = NotificationCenter.default
        let myNotification = Notification.Name(rawValue:"MyNotification")
        
        nc.post(name:myNotification,
                object: nil,
                userInfo:["message":"SC_event_from_VC_ON", "date":Date()])
    }
    
    func off_SC()
    {
        let nc = NotificationCenter.default
        let myNotification = Notification.Name(rawValue:"MyNotification")
        
        nc.post(name:myNotification,
                object: nil,
                userInfo:["message":"SC_event_from_VC_OFF", "date":Date()])
    }
    
    @objc func button_close_action()
    {
        //you should override this
    }
}

