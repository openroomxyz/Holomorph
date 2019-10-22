//
//  DoubleExtension.swift
//  Holoss
//
//  Created by Rok Kosuta on 27/10/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import SceneKit

extension Double
{
    var CGFloat_value : CGFloat { return CGFloat(self) }
    var String_value : String {return String(self)}
    
    static func doubleEqual(_ a: Double, _ b: Double) -> Bool
    {
        return fabs(a - b) < Double.ulpOfOne
    }
}
