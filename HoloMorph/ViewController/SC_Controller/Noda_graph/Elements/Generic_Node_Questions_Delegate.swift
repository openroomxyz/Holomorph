//
//  Elements_Protocol.swift
//  Holoss
//
//  Created by Rok Kosuta on 05/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit
/*
 enum Node_State
 {
 case selected
 case unselected
 }
 */
protocol Generic_Node_Questions_Delegate
{
    func my_corrisponding_create_command() -> My_Enums.Node_Graph_Type_Of_Node
    func my_set_color(color : UIColor)
    func my_set_default_color()
    func my_create() -> SCNNode
    
    func my_scale_all_axis_to(scale : Float)
    func my_change_color(color : UIColor)
    
    func add()
    
    //tags
    func update_tag_list(tag_list : Tag_List)
    func get_tag_list() -> Tag_List
    
    //description
    func set_description(description : Description)
    func get_description() -> Description
    
    func current_Info_Data() -> Info_Data
    
    func my_scale_axial(scale_axial : SCNVector3)
    func set_rotation(rotation_axial : SCNVector3)
    func set_rotation_aditive(rotation_axial : SCNVector3)
}

extension Generic_Node_Questions_Delegate
{
    func my_create() -> SCNNode
    {
        self.my_set_default_color() //TODO:  -THIS IS WRONG !!! YOU CAN OVERIDE THIS IS YOU LIKE TO INIT WITH DIFFERENT WOLOR
        return (self as! SCNNode)
    }
}

