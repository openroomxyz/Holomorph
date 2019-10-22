//
//  CreateMode.swift
//  Holoss
//
//  Created by Rok Kosuta on 05/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

struct Create_Mode
{
    struct Diff
    {
        var distance : Float
        var time : Float
    }
    
    struct Node_Generator
    {
        var type : My_Enums.Node_Graph_Type_Of_Node
        
        func get_Generic_Node_Questions_Delegate() -> Generic_Node_Questions_Delegate?
        {
            if type == .sphere { return type.corisponding_Node_Universal() }
            else if type == .box { return type.corisponding_Node_Universal() }
            else if type == .torus { return type.corisponding_Node_Universal() }
            else if type == .cone {  return type.corisponding_Node_Universal() }
            else if type == .tube { return type.corisponding_Node_Universal() }
            else if type == .cylinder { return type.corisponding_Node_Universal() }
            else if type == .pyramid { return type.corisponding_Node_Universal() }
            else if type == .plane {  return type.corisponding_Node_Universal() }
            return nil
        }
    }
    
    struct LastCreatedNode
    {
        var lcn : SCNNode?
        private var type : My_Enums.Node_Graph_Type_Of_Node = .sphere
        
        private mutating func remove_lcn() { lcn?.removeFromParentNode(); lcn = nil}
        private func is_type(type : My_Enums.Node_Graph_Type_Of_Node) -> Bool { return ((lcn as! Generic_Node_Questions_Delegate).my_corrisponding_create_command() == type) }
        
        mutating func create()
        {
            if let safe_k  = Node_Generator(type: self.type).get_Generic_Node_Questions_Delegate()
            {
                _ = safe_k.my_create()
                
                //Node_Universal.node_main?.childNodes.last?.worldPosition - safe_k world position
                
                safe_k.add()
                lcn = (safe_k as! SCNNode)
            }
        }
        
        mutating func change_to_type(type : My_Enums.Node_Graph_Type_Of_Node)
        {
            if (lcn != nil)
            {
                if !is_type(type: type)
                {
                    remove_lcn()
                }
                
            }
            
            if !(lcn != nil)
            {
                self.type = type
                create()
            }
        }
    }
    
    var create_color : UIColor = UIColor.orange
    var create_scale : CGFloat = 1.000
    var create_tool : My_Enums.Node_Graph_Type_Of_Node = .sphere
    var lcn : LastCreatedNode = LastCreatedNode()
    
    var scale_axal : SCNVector3 = SCNVector3.init(1.0, 1.0, 1.0)
    var rotate_axial : SCNVector3 = SCNVector3.init(0.0, 0.0, 0.0)
    var additive_vs_multiplicative_setting : Bool = false
    
    mutating func create_node()
    {
        lcn.create()
    }
    
    mutating func create_command()
    {
        lcn.change_to_type(type: self.create_tool)
    }
    
    func session(_ frame: ARFrame)
    {
        lcn.lcn?.my_move_infront_of_camera(ar_frame: frame, at_distance: -0.1)
        (lcn.lcn as? Generic_Node_Questions_Delegate)?.my_scale_all_axis_to(scale: Float(self.create_scale))
        (lcn.lcn as? Generic_Node_Questions_Delegate)?.my_set_color(color: self.create_color)
        
        (lcn.lcn as? Generic_Node_Questions_Delegate)?.my_scale_axial(scale_axial: scale_axal)
        
        if self.additive_vs_multiplicative_setting
        {
            (lcn.lcn as? Generic_Node_Questions_Delegate)?.set_rotation(rotation_axial : rotate_axial)
        }
        else
        {
            (lcn.lcn as? Generic_Node_Questions_Delegate)?.set_rotation_aditive(rotation_axial: rotate_axial)
        }
    }
    
}

