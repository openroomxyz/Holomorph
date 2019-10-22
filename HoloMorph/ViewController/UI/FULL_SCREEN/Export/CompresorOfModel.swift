//
//  CompresorOfModel.swift
//  Holoss
//
//  Created by Rok Kosuta on 01/03/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

extension Translater.Array_of_Fix_Lenght
{
    func last_element() -> [Float]?
    {
        if( self.count() == 0 )
        {
            return nil
        }
        
        var res : [Float] = []
        for i in 1...self.length
        {
            res.append( self.arr[self.arr.count - i] )
        }
        return res.reversed()
    }
    
    mutating func addCompresive(element : [Float]) -> Int
    {
        func isEqual(_ a : [Float], _ b : [Float]) -> Bool
        {
            if a.count == b.count
            {
                for i in a.indices
                {
                    if (a[i] != b[i])
                    {
                        return false
                    }
                }
                return true
            }
            return false
        }
        if element.count ==  self.length
        {
            if let safe_last = self.last_element()
            {
                if isEqual(safe_last, element)
                {
                    return (self.count() - 1)
                }
                else
                {
                    return self.add(element)
                }
            }
            else
            {
                return self.add(element)
            }
        }
        return -1
    }
    
}



