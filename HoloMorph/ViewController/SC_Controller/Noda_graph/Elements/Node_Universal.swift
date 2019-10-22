//
//  Node_Universal.swift
//  Holoss
//
//  Created by Rok Kosuta on 22/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

class Node_Universal : SCNNode, Generic_Node_Questions_Delegate
{
    static var node_main : SCNNode?
    
    var my_corrisponding_create_command_response : My_Enums.Node_Graph_Type_Of_Node = .box
    var tag_list : Tag_List = Tag_List.init()
    var desc: Description = Description()
    
    
    func my_corrisponding_create_command() -> My_Enums.Node_Graph_Type_Of_Node
    {
        return my_corrisponding_create_command_response
    }
    
    func string_representation()-> String
    {
        let all = try? JSONEncoder().encode( Node_Universal_JSON_description.init(tags: self.tag_list,
                                                                                  desc: self.desc,
                                                                                  pos: Node_Universal_JSON_description.vec3_codable.from_scnvector3(v: self.position),
                                                                                  rot: Node_Universal_JSON_description.vec3_codable.from_scnvector3(v: self.eulerAngles),
                                                                                  scale: Node_Universal_JSON_description.vec3_codable.from_scnvector3(v: self.scale),
                                                                                  my_corrisponding_create_command_response: my_corrisponding_create_command_response,
                                                                                  color: Node_Universal_JSON_description.color_codable.from_UIColor(c: (self.geometry?.firstMaterial?.diffuse.contents as! UIColor)) ) )
        let res =  String(data : all!, encoding: .utf8)!
        return res
    }
    
    func init_from_string(str : String)
    {
        if let  jsonData = str.data(using: .utf8)
        {
            let  _ : Node_Universal_JSON_description? = try? JSONDecoder().decode( Node_Universal_JSON_description.self, from: jsonData)
        }
    }
    
    //class method
    class func create_universal_node_with_geometry(type : My_Enums.Node_Graph_Type_Of_Node) -> Node_Universal
    {
        return type.corisponding_Node_Universal()
    }
    
    //instance method
    func add()
    {
        Node_Universal.node_main?.addChildNode(self)
    }
    
    func update_tag_list(tag_list: Tag_List)
    {
        self.tag_list.update(tag_list: tag_list)
    }
    
    func get_tag_list() -> Tag_List
    {
        return self.tag_list
    }
    
    func set_description(description: Description)
    {
        self.desc = description
    }
    
    func get_description() -> Description { return self.desc }
    
    func current_Info_Data() -> Info_Data
    {
        let l0 = "rotation : " + String(describing: self.rotation) +  "\n"
        let l1 = "position : " + String(describing: self.position) +  "\n"
        let l2 = "scale : " + String(describing: self.scale)  +  "\n"
        let lres = l0 + l1 + l2
        return Info_Data(txt: lres)
    }
    
    func my_scale_all_axis_to(scale : Float)
    {
        self.scale = SCNVector3.init(scale, scale, scale)
    }
    
    func my_scale_axial(scale_axial : SCNVector3)
    {
        self.scale = SCNVector3.init(self.scale.x * scale_axial.x, self.scale.y * scale_axial.y, self.scale.z * scale_axial.z)
    }
    
    func set_rotation(rotation_axial : SCNVector3)
    {
        self.eulerAngles = rotation_axial * 3.1415 * 2.0
    }
    
    func set_rotation_aditive(rotation_axial : SCNVector3)
    {
        let n = rotation_axial * 3.1415 * 2.0
        self.eulerAngles = SCNVector3.init(self.eulerAngles.x + n.x, self.eulerAngles.y + n.y, self.eulerAngles.z + n.z)
    }
    
    func my_change_color(color : UIColor)
    {
        my_set_color(color: color)
    }
}

