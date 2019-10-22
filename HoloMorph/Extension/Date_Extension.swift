//
//  Data_Extension.swift
//  Holoss
//
//  Created by Rok Kosuta on 23/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation

extension Date
{
    func toMillis() -> Int64!
    {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func toMillis_String() -> String
    {
        return String(toMillis())
    }
}
