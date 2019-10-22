//
//  MyTranslate.swift
//  Holoss
//
//  Created by Rok Kosuta on 25/02/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

import ARKit

struct Translater
{
    struct Array_of_Fix_Lenght
    {
        let length : Int
        var arr : [Float] = []
        
        mutating func add(_ a : [Float]) -> Int
        {
            if a.count == length
            {
                _ = a.map{ arr.append($0) }
                return (count() - 1)
            }
            else
            {
                print("Array_of_Fix_Lenght ERORR a.count =! length" )
            }
            return -1
        }
        
        func get(_ index : Int) -> [Float]?
        {
            if index < 0
            {
                return nil
            }
            
            if index < count()
            {
                var r : [Float] = []
                for i in 0..<length
                {
                    r.append( arr[index * length + i] )
                }
                return r
            }
            return nil
            
        }
        
        func count() -> Int
        {
            return self.arr.count / length
        }
        
        func export() -> [Float]
        {
            return self.arr
        }
        
    }
    
    struct ArrSCNVector3
    {
        var arr = Array_of_Fix_Lenght.init(length: 3, arr: [])
        
        mutating func add(_ v : SCNVector3) -> Int
        {
            return arr.add([v.x, v.y, v.z])
        }
        
        func get(_ index : Int) -> SCNVector3?
        {
            if let safe_a = arr.get(index)
            {
                return SCNVector3.init(safe_a[0], safe_a[1], safe_a[2])
            }
            return nil
        }
        
        func export() -> [Float]
        {
            return self.arr.export()
        }
    }
    
    struct ArrSCNVector4
    {
        var arr = Array_of_Fix_Lenght.init(length: 4, arr: [])
        
        mutating func add(_ v : SCNVector4) -> Int
        {
            return arr.add([v.x, v.y, v.z, v.w])
        }
        
        func get(_ index : Int) -> SCNVector4?
        {
            if let safe_a = arr.get(index)
            {
                return SCNVector4.init(safe_a[0], safe_a[1], safe_a[2], safe_a[3])
            }
            return nil
        }
        
        func export() -> [Float]
        {
            return self.arr.export()
        }
    }
    
    private func encode(_ model : Model) -> String?
    {
        let encoder = JSONEncoder()
        //encoder.outputFormatting = .prettyPrinted
        
        let data = try? encoder.encode(model)
        if let safe_data = data
        {
            return String(data: safe_data, encoding: .utf8)!
        }
        return nil
    }
    
    struct Element : Codable
    {
        let v : [Int]
        let desc : Int?
        let tags : [Int]?
        let d : [String:Int]?
        let i : [Int:Int]?
        
        static func create(position : Int, rotation : Int, scale : Int, type : Int,  color : Int, timestamp : Int,
                           desc : Int? = nil, tags : [Int]? = nil, d : [String:Int]? = nil, i : [Int:Int]? = nil) -> Element
        {
            return Element.init(v:  [position, rotation, scale, type, color, timestamp],
                                desc: desc,
                                tags: tags,
                                d: d, i: i)
        }
    }
    
    struct Model : Codable
    {
        let el : [Element]
        
        let pos : [Float]
        let rot : [Float]
        let scale : [Float]
        let color : [Float]
        
        let desc : [String]?
        let tags : [String]?
        
        let f_id : String
        let f_timestap : Int
        let f_gps : String
        
        func get_V3(index : Int , arr : [Float]) -> SCNVector3?
        {
            func count() -> Int
            {
                return arr.count / 3
            }
            
            if index < 0
            {
                return nil
            }
            
            if index>=count()
            {
                return nil
            }
            
            return SCNVector3.init(arr[index * 3], arr[index * 3 + 1], arr[index * 3 + 2])
        }
        
        func get_V4(index : Int , arr : [Float]) -> SCNVector4?
        {
            func count() -> Int
            {
                return arr.count / 4
            }
            
            if index < 0
            {
                return nil
            }
            
            if index>=count()
            {
                return nil
            }
            
            return SCNVector4.init(arr[index * 4], arr[index * 4 + 1], arr[index * 4 + 2], arr[index * 4 + 3])
        }
        
        func get_position(index : Int) -> SCNVector3?
        {
            return get_V3(index: index, arr: self.pos)
        }
        
        func get_rotation(index : Int) -> SCNVector3?
        {
            return get_V3(index: index, arr: self.rot)
        }
        
        func get_scale(index : Int) -> SCNVector3?
        {
            return get_V3(index: index, arr: self.scale)
        }
        
        func get_color(index : Int) -> SCNVector4?
        {
            return get_V4(index: index, arr: self.color)
        }
        
        func get_tags(index : Int) -> [String]
        {
            var res : [String] = []
            if let safe_tags_ints = el[index].tags
            {
                for i in safe_tags_ints
                {
                    let res_i = self.tags?[i]
                    if res_i != nil
                    {
                        res.append( res_i! )
                    }
                }
                return res
            }
            return []
            
        }
        
        func get_desc(index : Int) -> String?
        {
            if let safe_desc_ints = el[index].desc
            {
                return self.desc?[safe_desc_ints]
            }
            return nil
        }
    }
    
    struct ModelGen
    {
        var f_gps : String = ""
        var f_id : String = ""
        var f_timestap : Int = 0
        
        var el : [Element] = []
        
        
        var pos : ArrSCNVector3 = ArrSCNVector3()
        var rot : ArrSCNVector3 = ArrSCNVector3()
        var scale : ArrSCNVector3 = ArrSCNVector3()
        var color : ArrSCNVector4 = ArrSCNVector4()
        
        var desc : [String] = []
        var tags : [String] = []
        
        mutating func add(position : SCNVector3, rotation : SCNVector3, scale : SCNVector3, type : Int, color : SCNVector4, timestamp : Int, desc : String, tags : [String])
        {
            let ix_pos = self.pos.arr.addCompresive(element: position.getFloatArrayRepresentation())//self.pos.add(position)
            let ix_rot = self.rot.arr.addCompresive(element: rotation.getFloatArrayRepresentation())//self.rot.add(rotation)
            let ix_scale = self.scale.arr.addCompresive(element: scale.getFloatArrayRepresentation())//self.scale.add(scale)
            let ix_color = self.color.arr.addCompresive(element: color.getFloatArrayRepresentation())//self.color.add(color)
            
            var ix_desc : Int? = nil
            var ixs_tags : [Int]? = nil
            
            if desc != ""
            {
                self.desc.append( desc )
                ix_desc = (self.desc.count - 1)
            }
            
            for t in tags
            {
                if ixs_tags == nil
                {
                    ixs_tags = []
                }
                
                self.tags.append( t )
                ixs_tags?.append( (self.tags.count - 1 ) )
            }
            
            el.append( Element.create(position: ix_pos,
                                      rotation: ix_rot,
                                      scale: ix_scale,
                                      type: type,
                                      color: ix_color,
                                      timestamp: timestamp,
                                      desc: ix_desc,
                                      tags: ixs_tags,
                                      d: nil,
                                      i: nil) )
        }
        
        func export() -> Model
        {
            return Model.init(el: self.el, pos: self.pos.export(), rot: self.rot.export(), scale: self.scale.export(), color: self.color.export(),desc: self.desc, tags:tags, f_id: self.f_id, f_timestap: self.f_timestap, f_gps: self.f_gps)
        }
        
    }
    
    
    
    func run_translate(sc : SceneModel) -> String?
    {
        var mg = ModelGen.init()
        
        mg.f_gps = sc.gps
        mg.f_id = sc.id
        mg.f_timestap = Global.Converter.TimeConverter.conververtTimeSince1970_FromDouble_ToInt(Date().timeIntervalSince1970)
        
        
        var timestamp_per_node : Int = 0
        for i in sc.universal_node_description.indices
        {
            timestamp_per_node = 0
            if let safe_sc_timestamps = sc.timestamps
            {
                if safe_sc_timestamps.count > i
                {
                    timestamp_per_node = Int( (safe_sc_timestamps[i] * 100000) )
                }
            }
            
            let nud = sc.universal_node_description[i]
            
            
            mg.add(position: nud.pos.getSCNVector3(),
                   rotation: nud.rot.getSCNVector3(),
                   scale: nud.scale.getSCNVector3(),
                   type: nud.my_corrisponding_create_command_response.rawValue,
                   color: SCNVector4.init(nud.color.r, nud.color.g, nud.color.b, nud.color.a),
                   timestamp: timestamp_per_node,
                   desc: nud.desc.get_description(),
                   tags: nud.tags.tags.map{ $0.tag })
        }
        
        return encode( mg.export() )
    }
    
    func run_translate_backward( str : String ) -> SceneModel?
    {
        if let jsonData = str.data(using: .utf8)
        {
            let model = try? JSONDecoder().decode(Model.self, from: jsonData)
            if let safe_model =  model
            {
                return from_Model_to_SCModel(m: safe_model)
            }
        }
        return nil
    }
    
    func from_Model_to_SCModel( m : Model ) -> SceneModel?
    {
        var timestamps : [Int] = []
        var node_universal_description : [Node_Universal_JSON_description] = []
        
        for i in m.el.indices
        {
            timestamps.append(m.el[i].v[4])
            
            var d = Description.init()
            if let safe_d = m.get_desc(index: i)
            {
                d.update_desciption(str: safe_d)
            }
            else
            {
                d.update_desciption(str: "")
            }
            
            //[position 1 , rotation 2, scale 3, type 4, color 5, timestamp 6]
            let color_v4 =  m.get_color(index: m.el[i].v[4])!
            let scale_v3 = m.get_scale(index: m.el[i].v[2])!
            let rotation_v3 = m.get_rotation(index: m.el[i].v[1])!
            let position_v3 = m.get_position(index: m.el[i].v[0])!
            node_universal_description.append( Node_Universal_JSON_description(tags: Tag_List.init(tags: m.get_tags(index: i).map{ Tag.init(tag: $0) } ),
                                                                               desc: d,
                                                                               pos: Node_Universal_JSON_description.vec3_codable.from_scnvector3(v: position_v3),
                                                                               rot: Node_Universal_JSON_description.vec3_codable.from_scnvector3(v: rotation_v3),
                                                                               scale: Node_Universal_JSON_description.vec3_codable.from_scnvector3(v: scale_v3),
                                                                               my_corrisponding_create_command_response: My_Enums.Node_Graph_Type_Of_Node(rawValue: m.el[i].v[3])!,
                                                                               color: Node_Universal_JSON_description.color_codable.init(r: color_v4.x, g: color_v4.y, b: color_v4.z, a: color_v4.w)) )
            
        }
        
        
        
        let sc = SceneModel.init(universal_node_description: node_universal_description,
                                 id: m.f_id,
                                 time_stamp: String(m.f_timestap),
                                 gps: m.f_gps,
                                 timestamps: timestamps.map{ Global.Converter.TimeConverter.conververtTimeSince1970_FromInt_ToIntDouble($0) },
                                 gps_locations: nil)
        return sc
    }
}





