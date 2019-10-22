//
//  UI_Load_VC_extension.swift
//  Holoss
//
//  Created by Rok Kosuta on 02/02/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

extension UI_Load_VC
{
    
    class ButtonSave
    {
        var btm : UIButton?
        var method : (()->())?
        
        static func create(frame : CGRect) -> ButtonSave
        {
            let b = ButtonSave.init()
            b.btm = UIButton.init()
            b.btm?.frame = CGRect.init(x: 0.0, y: 80-50, width: frame.width * 0.30, height: 50)
            b.btm?.layer.cornerRadius = 5.0
            b.btm?.addTarget(b, action: #selector(self.action), for: .touchUpInside)
            b.btm?.setTitle("Save & New", for: .normal)
            b.btm?.backgroundColor = UIColor.rgbaFrom0to255(r: 21, g: 43, b: 85, a: 255)
            b.btm?.setTitleColor(UIColor.rgbaFrom0to255(r: 119, g: 136, b: 170, a: 255), for: .normal)
            b.btm?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            return b
        }
        
        @objc func action()
        {
            self.method?()
        }
        
    }
    
    class ButtonClose
    {
        var btm : UIButton?
        var method : (()->())?
        
        static func create(frame : CGRect) -> ButtonClose
        {
            let b = ButtonClose.init()
            b.btm = UIButton.init()
            b.btm?.frame = CGRect.init(x: frame.width - frame.width * 0.30, y: 80-50, width: frame.width * 0.30, height: 50)
            b.btm?.layer.cornerRadius = 5.0
            b.btm?.addTarget(b, action: #selector(self.action), for: .touchUpInside)
            b.btm?.setTitle("Close", for: .normal)
            b.btm?.backgroundColor = UIColor.rgbaFrom0to255(r: 21, g: 43, b: 85, a: 255)
            b.btm?.setTitleColor(UIColor.rgbaFrom0to255(r: 119, g: 136, b: 170, a: 255), for: .normal)
            b.btm?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            return b
        }
        
        @objc func action()
        {
            self.method?()
        }
        
    }
}


