//
//  ExportGenerator.swift
//  Holoss
//
//  Created by Rok Kosuta on 28/02/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

struct ExportGenerator
{
    
    struct TextNode
    {
        let id : String
        let name : String
        let ext : String
        let value : String?
        let recursion_limit : Int
        
        func try_to_read_value(f_read : (String, String)->String?) -> TextNode //(name, ext)
        {
            
            if let safe_value = f_read(self.name, self.ext)
            {
                return TextNode.init(id: self.id, name: self.name, ext: self.ext, value: safe_value,recursion_limit:  self.recursion_limit)
            }
            return self
        }
        
        
        func replace(_ a : [TextNode]) -> TextNode
        {
            var new_value = self.value!
            var replacement_happend : Bool = false
            
            for i in a
            {
                
                
                if new_value.contains(i.id)
                {
                    new_value = new_value.replacingOccurrences(of: i.id, with: i.value!)
                    replacement_happend = true
                }
            }
            
            if replacement_happend
            {
                if recursion_limit>0
                {
                    return TextNode.init(id: self.id, name: self.name, ext: self.ext, value: new_value, recursion_limit: (self.recursion_limit - 1)).replace(a)
                }
                else
                {
                    return TextNode.init(id: self.id, name: self.name, ext: self.ext, value: nil, recursion_limit: 0)
                }
            }
            return TextNode.init(id: self.id, name: self.name, ext: self.ext, value: new_value,recursion_limit:  self.recursion_limit)
        }
        
        
        func eval( a : [TextNode]) -> TextNode
        {
            return self.replace(a)
        }
        
        static func eval(a : [TextNode]) -> [TextNode]?
        {
            var na : [TextNode] = []
            for i in a
            {
                if i.value == nil //all have to be non nil else file is mising
                {
                    return nil
                }
                na.append(i.eval(a: a))
            }
            return na
        }
    }
    
    
    
    
    
    
}

