//
//  World.swift
//  Holoss
//
//  Created by Rok Kosuta on 05/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit
struct World
{
    var node : SCNNode
    var node_zero_point : SCNNode
    
    internal  struct Grab_world_past
    {
        static var position : SCNVector3?
        static var rotation : SCNVector4?
        static var euler_rotation : SCNVector3?
        
        static func make_nil()
        {
            Grab_world_past.rotation = nil
            Grab_world_past.position = nil
            Grab_world_past.euler_rotation = nil
        }
        
        static func make_zero()
        {
            Grab_world_past.position = SCNVector3.zeroVector()
            Grab_world_past.rotation = SCNVector4.zeroVector()
            Grab_world_past.euler_rotation = SCNVector3.zeroVector()
        }
        
        static func set(position : SCNVector3, rotation : SCNVector4,euler_rotation : SCNVector3)
        {
            Grab_world_past.position =  position
            Grab_world_past.rotation = rotation
            Grab_world_past.euler_rotation = euler_rotation
        }
    }
    
    
    init()
    {
        node = SCNNode.init()
        node.name = "world-node"
        
        node_zero_point = SCNNode.init()
        node_zero_point.position = SCNVector3.zeroVector()
    }
    
    
    func move_world_forward(current_transform : matrix_float4x4)
    {
        internal_move_world_forward(current_transform : current_transform, move_forward : true)
    }
    
    func move_world_backward(current_transform : matrix_float4x4)
    {
        internal_move_world_forward(current_transform : current_transform, move_forward : false)
    }
    
    private func internal_move_world_forward(current_transform : matrix_float4x4, move_forward : Bool = true)
    {
        func calc_pos() -> SCNVector3
        {
            let tmp_node = SCNNode()
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.1
            tmp_node.simdTransform = matrix_multiply(current_transform, translation)
            
            let t = World.getZForward(node: tmp_node)
            return t
        }
        
        let fak : Float = 0.0015
        let t = calc_pos()
        
        node.position = move_forward ? node.position + (t * fak) : node.position - (t * fak)
    }
    
    static func getZForward(node: SCNNode) -> SCNVector3 {
        return SCNVector3(node.worldTransform.m31, node.worldTransform.m32, node.worldTransform.m33)
    }
    
    
    func grab_world_move(current_transform : matrix_float4x4)
    {
        var camera_pos = SCNVector3.zeroVector()
        camera_pos = SCNVector3.set_to_camera_position(current_transform: current_transform)
        
        var d_postion =  SCNVector3.zeroVector()
        
        //move
        if World.Grab_world_past.position == nil
        {
            World.Grab_world_past.make_zero()
        }
        else
        {
            d_postion = d_postion + camera_pos
            d_postion = d_postion - World.Grab_world_past.position!
            d_postion = d_postion + node.position
            node.position = d_postion
        }
        World.Grab_world_past.position = camera_pos
    }
    
    func grab_world_clean()
    {
        World.Grab_world_past.make_nil()
    }
    
    static func calculate_camera_position_and_orientation(frame: ARFrame) -> (position : SCNVector3, rotation_euler : SCNVector3, rotation : SCNVector4)
    {
        let node : SCNNode = SCNNode()
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.0
        //node.simdTransform = matrix_multiply(frame.camera.transform, translation)
        node.simdWorldTransform = matrix_multiply(frame.camera.transform, translation)
        return (position : node.position, rotation_euler : node.eulerAngles, rotation : node.rotation)
        //return (position : node.worldPosition, rotation_euler : node.eulerAngles, rotation : node.rotation)
    }
    
    func world_position() -> SCNVector3
    {
        return self.node.worldPosition
    }
    
}




