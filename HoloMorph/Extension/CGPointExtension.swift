//
//  CGPointExtension.swift
//  Holoss
//
//  Created by Rok Kosuta on 28/10/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import SceneKit

extension CGPoint
{
    func distance(toPoint p:CGPoint) -> CGFloat {
        return sqrt(pow(x - p.x, 2) + pow(y - p.y, 2))
    }
    
}
