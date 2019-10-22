//
//  BoolExtension.swift
//  Holoss
//
//  Created by Rok Kosuta on 16/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation

extension Bool
{
    func ifTrueExecute(f : ()->())
    {
        if self == true
        {
            f()
        }
    }
}

extension Bool
{
    static func or(_ v : Bool...) -> Bool
    {
        let start = false
        for el in v
        {
            if start || el
            {
                return true
            }
        }
        return false
    }
    
    static func and(_ v : Bool...) -> Bool
    {
        let start = true
        for el in v
        {
            if start && el
            {
                
            }
            else
            {
                return false
            }
        }
        return true
    }
}

extension Bool
{
    static func and_between_all_elements(arr : [Bool]) -> Bool
    {
        let start = true
        for el in arr { if !(el && start) { return false } }
        return true
    }
}

extension Bool
{
    static func Bool_generate_binary_count_array(dimensions : Int) -> [[Bool]]
    {
        func binary_array(init_value : Bool, size : Int) -> [Bool]
        {
            var arr : [Bool] = []
            for _ in 0 ..< size
            {
                arr.append(init_value)
            }
            return arr
        }
        
        func binary_array_is_max_value(_ arr : [Bool]) -> Bool
        {
            for i in arr
            {
                if i == false
                {
                    return false
                }
            }
            return true
        }
        
        func inc_bool_array(_ arr : [Bool]) -> [Bool]
        {
            var n : [Bool] = []
            
            var flip = false
            for e in arr
            {
                if flip
                {
                    n.append(e)
                }
                else
                {
                    if e == true
                    {
                        n.append(false)
                    }
                    else
                    {
                        n.append(true)
                        flip = true
                    }
                }
                
            }
            return n
        }
        
        var arr : [[Bool]] = []
        let start = binary_array(init_value: false, size: dimensions)
        arr.append(start)
        
        while !binary_array_is_max_value(arr.last!)
        {
            arr.append(inc_bool_array(arr.last!))
        }
        return arr.map{ n in n.reversed()}
        
    }
}

