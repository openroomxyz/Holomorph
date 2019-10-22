//
//  IntExtension.swift
//  Holoss
//
//  Created by Rok Kosuta on 28/10/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

extension Int
{
    static func random(min: Int, max:Int) -> Int
    {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}

extension Int
{
    var CGFloat_value : CGFloat { return CGFloat(self) }
    var Double_value : Double { return Double(self)}
}
