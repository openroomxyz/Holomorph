//
//  SC_Universal_Node.swift
//  Holoss
//
//  Created by Rok Kosuta on 20/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit


class Node_graph_Manager
{
    private var world : World = World.init()
    
    private var grid_node : Grid_Node = Grid_Node.create()
    var create_mode : Create_Mode = Create_Mode.init()
    var move_object_mode : Move_Object_Mode = Move_Object_Mode.init()
    var select_object_mode : Select_Object = Select_Object.init()
    
    var moving_world_on : Bool = false
    
    init(scene_view : inout ARSCNView)
    {
        
        scene_view.scene.rootNode.addChildNode(world.node)
        scene_view.scene.rootNode.addChildNode(world.node_zero_point)
        
        world.node.addChildNode(self.grid_node)
        
        Node_Universal.node_main = SCNNode.init()
        Node_Universal.node_main?.name = "node_main"
        world.node.addChildNode(Node_Universal.node_main!)
        
        Select_Object.select_outlet_node = SCNNode.init()
        world.node.addChildNode(Select_Object.select_outlet_node!)
    }
    
    //public
    func session(_ session: ARSession, didUpdate frame: ARFrame, mode : My_Enums.Mode, move_command :My_Enums.Menu_World_Move_Option, trackingOK: Bool)
    {
        self.grid_node.update(frame: frame, wp: world.world_position())
        
        if trackingOK
        {
            if mode == .move_object
            {
                self.move_object_mode.session(frame)
            }
            else if mode == .create
            {
                self.create_mode.session(frame)
            }
        }
        
        
        
        if mode == .move_world
        {
            let current_transform = frame.camera.transform;
            
            if moving_world_on
            {
                if (move_command == .forward)
                {
                    world.move_world_forward(current_transform: current_transform)
                }
                else if(move_command == .back)
                {
                    world.move_world_backward(current_transform: current_transform)
                }
                else if(move_command == .world_grab)
                {
                    world.grab_world_move(current_transform: current_transform)
                }
            }
            
        }
    }
    
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, sceneView: ARSCNView, mode : My_Enums.Mode) -> My_Enums.Node_Graph_Type_Of_Node?
    {
        if mode == .select
        {
            return select_object_mode.selected_object_event_selected(touches, with: event, sceneView: sceneView)
        }
        else if mode == .move_object
        {
            self.move_object_mode.move_box_node(touches, with: event, sceneView: sceneView)
        }
        
        //moving_world_on = true
        
        return nil
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, sceneView: ARSCNView, mode : My_Enums.Mode)
    {
        if mode == .move_object
        {
            move_object_mode.move_box_node(touches, with: event, sceneView: sceneView)
        }
    }
    
    func handleTap(gestureRecognize: UITapGestureRecognizer)
    {
        moving_world_on = !moving_world_on
        self.make_grab_world_nil()
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    func set_color( color : UIColor, mode : My_Enums.Mode)
    {
        if mode == .select
        {
            self.select_object_mode.set_color(color: color)
            //(self.select_object_mode.node as? Generic_Node_Questions_Delegate)?.my_set_color(color: color)
        }
        else if mode == .create
        {
            create_mode.create_color = color
        }
    }
    
    func duplicated_selected( mode : My_Enums.Mode)
    {
        if mode == .select
        {
            self.select_object_mode.duplicated_selected()
        }
    }
    
    func delete_everything( mode : My_Enums.Mode)
    {
        if mode == .select
        {
            self.select_object_mode.delete_everywhere()
        }
    }
    
    func clean( mode : My_Enums.Mode )
    {
        if mode == .select
        {
            self.select_object_mode.clean()
        }
        else if mode == .move_object
        {
            self.move_object_mode.clean()
        }
    }
    
    func new_tag_list(tag_list : Tag_List, mode : My_Enums.Mode)
    {
        if mode == .select
        {
            self.select_object_mode.new_tag_list(tag_list: tag_list)
        }
    }
    
    func current_tag_list(mode : My_Enums.Mode) -> Tag_List?
    {
        if mode == .select
        {
            return self.select_object_mode.current_tag_list()
        }
        return nil
    }
    
    func new_desription(des: Description, mode : My_Enums.Mode)
    {
        if mode == .select
        {
            select_object_mode.new_desription(des: des)
        }
    }
    
    func current_description(mode : My_Enums.Mode) -> Description?
    {
        if mode == .select
        {
            return select_object_mode.current_description()
        }
        return nil
    }
    
    //info
    func current_info(mode : My_Enums.Mode) -> Info_Data?
    {
        if mode == .select
        {
            return select_object_mode.current_info()
        }
        return nil
    }
    //
    func create_node( mode : My_Enums.Mode, tool : My_Enums.Node_Graph_Type_Of_Node)
    {
        if mode == .create
        {
            create_mode.create_tool = tool
            create_mode.create_command()
        }
    }
    
    func create_node_2(mode : My_Enums.Mode)
    {
        if mode == .create
        {
            create_mode.create_node()
        }
    }
    
    func set_create_scale(scale : Float, mode : My_Enums.Mode)
    {
        if mode == .create
        {
            create_mode.create_scale = scale.CGFloat_value
        }
    }
    
    func set_create_rotation_axial_and_scale_axial(rotation_axial : SCNVector3,  scale_axial : SCNVector3, additive_vs_multiplicative: Bool, mode : My_Enums.Mode)
    {
        if mode == .create
        {
            create_mode.rotate_axial = rotation_axial
            create_mode.scale_axal = scale_axial
            create_mode.additive_vs_multiplicative_setting = additive_vs_multiplicative
        }
    }
    
    func get_create_scale(mode : My_Enums.Mode) -> Float?
    {
        if mode == .create
        {
            return Float(create_mode.create_scale)
        }
        return nil
    }
    
    func make_grab_world_nil()
    {
        type(of: world).Grab_world_past.make_nil()
    }
    
    func get_world_position() -> SCNVector3
    {
        return world.world_position()
    }
    
}






