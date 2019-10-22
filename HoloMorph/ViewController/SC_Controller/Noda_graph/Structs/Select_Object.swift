//
//  Select_Object.swift
//  Holoss
//
//  Created by Rok Kosuta on 05/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit


struct Select_Object
{
    private var node : SCNNode?
    
    static var select_outlet_node : SCNNode?
    
    mutating func setup(node : SCNNode)
    {
        self.node = node
    }
    
    
    
    func what_is_the_type() -> My_Enums.Node_Graph_Type_Of_Node?
    {
        if  self.node == nil
        {
            return nil
        }
        let t = (self.node as? Generic_Node_Questions_Delegate)
        if t == nil
        {
            return nil
        }
        
        return t!.my_corrisponding_create_command()
    }
    
    //delete
    mutating func delete_everywhere()
    {
        self.node?.removeFromParentNode()
        clean()
    }
    
    mutating func clean()
    {
        self.node = nil
    }
    
    //select object
    mutating func selected_object_event_selected(_ touches: Set<UITouch>, with event: UIEvent?, sceneView : ARSCNView) -> My_Enums.Node_Graph_Type_Of_Node?
    {
        if let touch = touches.first
        {
            let location = touch.location(in: sceneView)
            let hitList = sceneView.hitTest(location, options: nil)
            
            if let hitObject = hitList.first
            {
                let node = hitObject.node
                self.setup(node: node)
                return self.what_is_the_type()
            }
        }
        return nil
    }
    
    //duplicate
    func duplicated_selected()
    {
        if let safe_node = self.node
        {
            Select_Object.select_outlet_node?.addChildNode( (safe_node.copy() as! SCNNode) )
        }
    }
    
    //tags
    
    func new_tag_list(tag_list : Tag_List)
    {
        (self.node as? Generic_Node_Questions_Delegate)?.update_tag_list(tag_list: tag_list)
    }
    
    func current_tag_list() -> Tag_List
    {
        return (self.node as? Generic_Node_Questions_Delegate)?.get_tag_list() ?? Tag_List.init()
    }
    
    
    //description
    func new_desription(des: Description)
    {
        (self.node as? Generic_Node_Questions_Delegate)?.set_description(description: des)
    }
    
    func current_description() -> Description
    {
        return (self.node as? Generic_Node_Questions_Delegate)?.get_description() ?? Description()
    }
    
    //color
    func set_color(color : UIColor)
    {
        (self.node as? Generic_Node_Questions_Delegate)?.my_set_color(color: color)
    }
    
    //info
    func current_info() -> Info_Data
    {
        return (self.node as? Generic_Node_Questions_Delegate)?.current_Info_Data() ?? Info_Data(txt : "no info s")
    }
    
}


