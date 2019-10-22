//
//  UIViewExtension.swift
//  Holoss
//
//  Created by Rok Kosuta on 14/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    var screenshot: UIImage{
        
        UIGraphicsBeginImageContext(self.bounds.size);
        let context = UIGraphicsGetCurrentContext();
        self.layer.render(in: context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot!
    }
}


extension UIView
{
    func hideAllSubviews()
    {
        for i in self.subviews
        {
            i.isHidden = true
        }
    }
    
    func toggleHidden()
    {
        if self.isHidden
        {
            self.isHidden = false
        }
        else
        {
            self.isHidden = true
        }
    }
    
}


