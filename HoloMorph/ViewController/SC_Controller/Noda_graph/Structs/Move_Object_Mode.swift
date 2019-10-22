//
//  Move_State.swift
//  Holoss
//
//  Created by Rok Kosuta on 05/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

struct Move_Object_Mode
{
    var move_node : SCNNode?
    var distace : Float?
    var scale : SCNVector3?
    var rotation : SCNVector4?
    var cursor_node : SCNNode?
    
    mutating func clean()
    {
        move_node = nil
        distace = nil
        scale = nil
        rotation = nil
        
        cursor_node?.removeFromParentNode()
        cursor_node = nil
    }
    
    mutating func session(_ currentFrame : ARFrame)
    {
        cursor_node?.my_move_infront_of_camera(ar_frame: currentFrame, at_distance: -0.01)
        if cursor_node == nil
        {
            cursor_node = SCNNode.init()
            cursor_node?.geometry = SCNPlane.init(width: 0.00015, height: 0.00015)
            cursor_node?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            cursor_node?.geometry?.firstMaterial?.transparency = 0.8
            Node_Universal.node_main?.addChildNode(cursor_node!)
        }
        cursor_node?.isHidden = false
        
        if isSetup()
        {
            
            move_node!.simdWorldTransform = SCNNode.my_transform(currentFrame.camera.transform, distance: distace!)
            move_node!.scale = scale!
        }
    }
    
    mutating func setup(node : SCNNode, currentFrame : ARFrame)
    {
        move_node = node
        distace = -node.calculate_world_distance_to_camera(currentFrame: currentFrame).length
        rotation = node.rotation
        scale = node.scale
    }
    
    
    
    func isSetup() -> Bool
    {
        return Bool.and_between_all_elements(arr: [(move_node != nil), (distace != nil), (scale != nil), (rotation != nil)])
    }
    
    mutating func move_box_node(_ touches: Set<UITouch>, with event: UIEvent?, sceneView : ARSCNView)
    {
        
        
        if let _ = touches.first
        {
            let location : CGPoint = CGPoint.init(x: sceneView.frame.width * 0.5, y: sceneView.frame.height * 0.5) // in center
            
            let hitList = sceneView.hitTest(location, options: nil)
            
            
            if let hitObject = hitList.first
            {
                let node = hitObject.node
                
                //what_kind_of_node_is(node: node)
                
                
                if node.name != "grid-node"
                {
                    guard let currentFrame = sceneView.session.currentFrame else {
                        return
                    }
                    
                    if !self.isSetup()
                    {
                        setup(node: node, currentFrame: currentFrame)
                    }
                    
                    session(currentFrame)
                }
            }
            
            
        }
    }
    
}

