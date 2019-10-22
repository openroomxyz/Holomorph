//
//  CGRect_Extension.swift
//  Holoss
//
//  Created by Rok Kosuta on 18/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

extension CGRect
{
    func originAtZeroSameWidthHeight() -> CGRect
    {
        return CGRect.init(x: 0, y: 0, width: self.width, height: self.height)
    }
}
