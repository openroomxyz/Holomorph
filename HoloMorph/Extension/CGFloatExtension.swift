//
//  File.swift
//  Holoss
//
//  Created by Rok Kosuta on 27/10/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import SceneKit

extension CGFloat
{
    var Double_value: Double { return Double(self) }
    var Int_value : Int { return Int(self)}
    
    func limit_between_0_and_1() -> CGFloat
    {
        if self < 0
        {
            return CGFloat.init(0.0)
        }
        else if self > 1
        {
            return CGFloat.init(1.0)
        }
        return self
    }
}
