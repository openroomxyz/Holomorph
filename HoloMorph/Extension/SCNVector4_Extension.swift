//
//  SCNVector4_Extension.swift
//  Holoss
//
//  Created by Rok Kosuta on 28/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit


extension SCNVector4
{
    func getFloatArrayRepresentation() -> [Float]
    {
        return [self.x, self.y, self.z, self.w]
    }
}


extension SCNVector4
{
    static func zeroVector() -> SCNVector4
    {
        return SCNVector4.init(0.0, 0.0, 0.0, 0.0)
    }
        
}


extension SCNVector4
{
        public func to3() -> SCNVector3 {
            return SCNVector3(x: x, y: y, z: z)
        }
        
        public func copy() -> SCNVector4 {
            return SCNVector4(x: x, y: y, z: z, w: w)
        }
        
        public var description: String {
            return "[\(x), \(y), \(z), \(w)]"
        }
        
        subscript(i: Int) -> Float {
            assert(0 <= i && i < 4, "Index out of range")
            switch i {
            case 0:
                return x
            case 1:
                return y
            case 2:
                return z
            case 3:
                return w
            default:
                fatalError("Index out of range")
            }
        }
        
        private var floatArray: [Float] {
            get {
                return [x, y, z, w]
            }
            set {
                x = newValue[0]
                y = newValue[1]
                z = newValue[2]
                w = newValue[3]
            }
        }
        
        private var doubleArray: [Double] {
            get {
                return [Double(x), Double(y), Double(z), Double(w)]
            }
            set {
                x = Float(newValue[0])
                y = Float(newValue[1])
                z = Float(newValue[2])
                w = Float(newValue[3])
            }
        }
    }
    
    // Equality and equivalence
    public func ==(lhs: SCNVector4, rhs: SCNVector4) -> Bool {
        return SCNVector4EqualToVector4(lhs, rhs)
    }

    
    // Dot product
    public func *(left: SCNVector4, right: SCNVector4) -> Float {
        return (left.x * right.x) + (left.y * right.y) + (left.z * right.z)
    }

    
    // Scalar multiplication
    public func *(left: SCNVector4, right: Float) -> SCNVector4 {
        let x = left.x * right
        let y = left.y * right
        let z = left.z * right
        
        return SCNVector4(x: x, y: y, z: z, w: left.w) // TODO: Is the w part correct?
    }
    
    public func *(left: Float, right: SCNVector4) -> SCNVector4 {
        let x = right.x * left
        let y = right.y * left
        let z = right.z * left
        
        return SCNVector4(x: x, y: y, z: z, w: right.w)
    }
    
    public func *(left: SCNVector4, right: Int) -> SCNVector4 {
        return left * Float(right)
    }
    
    public func *(left: Int, right: SCNVector4) -> SCNVector4 {
        return Float(left) * right
    }
    
public func *=( left: inout SCNVector4, right: Float) {
        left = left * right
    }
    
public func *=( left: inout SCNVector4, right: Int) {
        left = left * right
    }
    
    // Scalar Division
    public func /(left: SCNVector4, right: Float) -> SCNVector4 {
        let x = left.x / right
        let y = left.y / right
        let z = left.z / right
        
        return SCNVector4(x: x, y: y, z: z, w: left.w)
    }
    
    public func /(left: SCNVector4, right: Int) -> SCNVector4 {
        return left / Float(right)
    }
    
public func /=( left: inout SCNVector4, right: Float) {
        left = left / right
    }
    
public func /=( left: inout SCNVector4, right: Int) {
        left = left / right
    }
    
    // Vector subtraction
    public func -(left: SCNVector4, right: SCNVector4) -> SCNVector4 {
        let x = left.x - right.x
        let y = left.y - right.y
        let z = left.z - right.z
        
        let w = left.w * right.w
        
        return SCNVector4(x: x, y: y, z: z, w: w)
    }
    
public func -=( left: inout SCNVector4, right: SCNVector4) {
        left = left - right
    }
    
    // Vector addition
    public func +(left: SCNVector4, right: SCNVector4) -> SCNVector4 {
        let x = left.x + right.x
        let y = left.y + right.y
        let z = left.z + right.z
        
        let w = left.w * right.w
        
        return SCNVector4(x: x, y: y, z: z, w: w)
    }
    
public func +=( left: inout SCNVector4, right: SCNVector4) {
        left = left + right
    }

