//
//  SceneModel.swift
//  Holoss
//
//  Created by Rok Kosuta on 05/02/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

struct SceneModel : Codable
{
    
    let universal_node_description : [Node_Universal_JSON_description]
    let id : String
    let type : String = "type_1713739E-F83A-4D28-A2F5-7EE43077E5E4"
    let time_stamp : String
    
    let gps : String
    
    var timestamps : [Double]? = nil
    var gps_locations : [String]? = nil
    
    static func test_scene() -> SceneModel
    {
        var d = Description.init()
        d.update_desciption(str: "pojedel bi jablano ne sm sam jabolko ti sment")
        let k = Node_Universal_JSON_description.init(tags: Tag_List.init(tags: [Tag.init(tag: "Wuhu pa sem tu"), Tag.init(tag: "TagiTagajTauuuuuWUhuuuu")]),
                                                     desc: d,
                                                     pos: Node_Universal_JSON_description.vec3_codable.init(x: 0, y: 0, z: 0),
                                                     rot: Node_Universal_JSON_description.vec3_codable.init(x: 0.5, y: 0, z: 0),
                                                     scale: Node_Universal_JSON_description.vec3_codable.init(x: 1.0, y: 1.0, z: 1.0),
                                                     my_corrisponding_create_command_response: My_Enums.Node_Graph_Type_Of_Node.cylinder,
                                                     color: Node_Universal_JSON_description.color_codable.from_UIColor(c: UIColor.purple))
        
        //return SceneModel.init(universal_node_description: [k], id: UUID().uuidString, time_stamp: Date().toMillis_String(), gps: "")
        return SceneModel.init(universal_node_description: [k], id: UUID().uuidString, time_stamp: Date().toMillis_String(), gps: "", timestamps: nil, gps_locations: nil)
    }
    
    static func from_nodes_scene_model(nodes : [SCNNode]) -> SceneModel?
    {
        var arr : [Node_Universal_JSON_description] = []
        
        for i in nodes
        {
            if (i is Node_Universal)
            {
                arr.append( Node_Universal_JSON_description.create_from_Node_Universal(node_universal: (i as! Node_Universal)) )
            }
        }
        
        //return SceneModel.init(universal_node_description: arr, id: UUID().uuidString, time_stamp: Date().toMillis_String(), gps: "")
        return SceneModel.init(universal_node_description: arr, id: UUID().uuidString, time_stamp:  Date().toMillis_String(), gps: "", timestamps: nil, gps_locations: nil)
    }
    
    func getJSON_data() -> Data
    {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(self)
        return data!
    }
    
    func getJSON_string() -> String?
    {
        return String(data : getJSON_data(), encoding : . utf8)
    }
    
    static func init_from_string( str : String) -> SceneModel?
    {
        //NEW WAY
        if let safe_scene_model = Translater().run_translate_backward(str: str)
        {
            print("init_from_string SUCESS 1")
            return safe_scene_model
        }
        
        
        //OLD WAY
        
        if let jsonData = str.data(using: .utf8)
        {
            let model = try? JSONDecoder().decode(SceneModel.self, from: jsonData)
            print("init_from_string SUCESS 2")
            
            return model
        }
        return nil
        
    }
}


struct Node_Universal_JSON_description : Codable
{
    struct vec3_codable : Codable
    {
        let x : Float
        let y : Float
        let z : Float
        
        static func from_scnvector3(v : SCNVector3) -> vec3_codable
        {
            return vec3_codable(x: v.x, y: v.y, z: v.z)
        }
        
        func getSCNVector3() -> SCNVector3
        {
            return SCNVector3.init(x: self.x, y: self.y, z: self.z)
        }
    }
    
    struct color_codable : Codable
    {
        let r : Float
        let g : Float
        let b : Float
        let a : Float
        
        static func from_UIColor( c : UIColor) -> color_codable
        {
            let n = c.getRGBAComponents()
            return color_codable.init(r: Float(n!.red), g: Float(n!.green), b: Float(n!.blue), a: Float(n!.alpha))
        }
        
        func getUIColor() -> UIColor
        {
            return UIColor.init(red: r.CGFloat_value, green: g.CGFloat_value, blue: b.CGFloat_value, alpha: a.CGFloat_value)
        }
    }
    
    let tags : Tag_List
    let desc : Description
    let pos : vec3_codable
    let rot : vec3_codable
    let scale : vec3_codable
    let my_corrisponding_create_command_response : My_Enums.Node_Graph_Type_Of_Node
    let color : color_codable
    
    
    static func create_from_Node_Universal(node_universal : Node_Universal) -> Node_Universal_JSON_description
    {
        return Node_Universal_JSON_description.init(tags: node_universal.tag_list,
                                                    desc: node_universal.get_description(),
                                                    pos: Node_Universal_JSON_description.vec3_codable.from_scnvector3(v: node_universal.position),
                                                    rot: Node_Universal_JSON_description.vec3_codable.from_scnvector3(v: node_universal.eulerAngles),
                                                    scale: Node_Universal_JSON_description.vec3_codable.from_scnvector3(v: node_universal.scale),
                                                    my_corrisponding_create_command_response: node_universal.my_corrisponding_create_command_response,
                                                    color: Node_Universal_JSON_description.color_codable.from_UIColor(c: (node_universal.geometry!.firstMaterial?.diffuse.contents as! UIColor)))
    }
}

