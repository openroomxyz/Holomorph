//
//  SCNNodeExtension.swift
//  Holoss
//
//  Created by Rok Kosuta on 16/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

extension SCNNode {
    
    func setUniformScale(_ scale: Float) {
        self.scale = SCNVector3Make(scale, scale, scale)
    }
    
    func renderOnTop() {
        self.renderingOrder = 2
        if let geom = self.geometry {
            for material in geom.materials {
                material.readsFromDepthBuffer = false
            }
        }
        for child in self.childNodes {
            child.renderOnTop()
        }
    }
    
    func setPivot() {
        let minVec = self.boundingBox.min
        let maxVec = self.boundingBox.max
        let bound = SCNVector3Make( maxVec.x - minVec.x, maxVec.y - minVec.y, maxVec.z - minVec.z);
        self.pivot = SCNMatrix4MakeTranslation(bound.x / 2, bound.y / 2, bound.z / 2);
    }
}



extension SCNNode
{
    func addChildNodes(_ nodes : [SCNNode])
    {
        for i in nodes
        {
            self.addChildNode(i)
        }
    }
    
    class func my_create() -> SCNNode
    {
        return SCNNode.init()
    }
    
    internal class func MY_default_scale() -> CGFloat
    {
        return 0.010
    }
    
    func my_set_color(color : UIColor)
    {
        self.geometry?.firstMaterial?.diffuse.contents = color
        self.geometry?.firstMaterial?.specular.contents = color
    }
    
    func my_set_default_color()
    {
        my_set_color(color: UIColor.orange)
    }
    
    func my_move_infront_of_camera(ar_frame : ARFrame, at_distance : Float = -0.1)
    {
        var translation = matrix_identity_float4x4
        translation.columns.3.z = at_distance
        //self.simdTransform = matrix_multiply(ar_frame.camera.transform, translation)
        self.simdWorldTransform = matrix_multiply(ar_frame.camera.transform, translation)
    }
    
    class func my_transform(_ ct : matrix_float4x4, distance : Float) -> matrix_float4x4
    {
        var translation = matrix_identity_float4x4
        translation.columns.3.z = distance
        return matrix_multiply(ct, translation)
    }
    
    func calculate_world_distance_to_camera(currentFrame : ARFrame) -> SCNVector3
    {
        let foo_node : SCNNode = SCNNode.init()
        foo_node.simdWorldTransform = SCNNode.my_transform(currentFrame.camera.transform, distance: 0.0)//matrix_multiply(currentFrame.camera.transform, translation) //node.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        return (foo_node.worldPosition - self.worldPosition)
    }
}
