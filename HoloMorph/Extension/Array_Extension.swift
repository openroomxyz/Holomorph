//
//  Array_Extension.swift
//  Holoss
//
//  Created by Rok Kosuta on 16/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation

/*
extension Array {
    var last: Element {
        return self[self.endIndex - 1]
    }
}
*/
/*
func g<T>(_ arr : [T], index : Int) -> T?
{
    if arr.count > index
    {
        return arr[index]
    }
    return nil
}
*/

extension Array
{
    func getIfExist(index : Int) -> Element?
    {
        if self.count > index
        {
            return self[index]
        }
        return nil
    }
}

