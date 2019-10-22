//
//  FloatExtension.swift
//  Holoss
//
//  Created by Rok Kosuta on 27/10/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import SceneKit

extension Float
{
    static var zero : Float
    {
        return 0.0
    }
    
    static var one : Float
    {
        return 1.0
    }
}

extension Float
{
    var Double_value: Double { return Double(self) }
    var CGFloat_value : CGFloat{ return CGFloat(self)}
    var isPositiveNumber : Bool { if self>0 { return true}else{return false}}
}
