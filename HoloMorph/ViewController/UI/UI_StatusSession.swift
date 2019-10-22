//
//  UI_StatusSession.swift
//  Holoss
//
//  Created by Rok Kosuta on 04/03/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

class UI_StatusSession
{
    var view : UIView?
    
    var label_1 : UILabel?
    
    var max_value : Int?
    
    func create(parent_view : UIView)
    {
        let pw = parent_view.frame.width
        //let ph = parent_view.frame.height
        
        self.view = UIView.init(frame: CGRect.init(x:pw * 0.90 , y: 0.0, width: pw * 0.10, height: 40))
        self.view?.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
        self.view?.layer.cornerRadius = 5.0
        parent_view.addSubview(self.view!)
        
        label_1 = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: pw * 0.25, height: 40))
        label_1?.text = "100%"
        self.view?.addSubview(label_1!)
    }
    
    func update_for_value(value : Int)
    {
        if let safe_max_value = max_value
        {
            if safe_max_value > 0
            {
                let c = Int(100 * (Float(value) / Float(safe_max_value)))
                self.label_1?.text = String(c)+"%"
            }
            
            struct Memory
            {
                static var was_shown = false
            }
            
            if value == (safe_max_value - 1)
            {
                print("You have reached the limit of the number of element that is posibile to draw, save drawing start new, one or delete some")
                func alert_limit_reached(message: String, title: String = "") {
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let action_ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in } )
                    alertController.addAction(action_ok)
                    Global.GlobalVariables.vc!.present(alertController, animated: true, completion: nil)
                }
                
                if Memory.was_shown
                {
                    
                }
                else
                {
                    alert_limit_reached(message: "You have reached the limit of the number of element that is posibile to draw, save drawing start new, one or delete some")
                    Memory.was_shown = true
                }
                
            }
            else if value < (safe_max_value - 1)
            {
                Memory.was_shown = false
            }
        }
        
    }
    
    func visible()
    {
        self.view?.isHidden = false
    }
}

