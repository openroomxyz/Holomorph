//
//  SC_Controller.swift
//  Holoss
//
//  Created by Rok Kosuta on 19/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

class SC_Controller : SC_Controller_Delegate
{
    
    var bool_draw : Bool = false
    
    var scene_view : ARSCNView
    var delegate : Controller_user_interface_new_Delegate
    
    var mode : My_Enums.Mode = .create
    var mode_move : My_Enums.Menu_World_Move_Option = .forward
    var ng : Node_graph_Manager
    
    var bool_continuosly_delete : Bool = false
    
    required init(scene_view: ARSCNView, delegate: Controller_user_interface_new_Delegate)
    {
        self.scene_view = scene_view
        self.delegate = delegate
        self.scene_view.autoenablesDefaultLighting = true;
        //self.scene_view.showsStatistics = true
        
        //usefull show feature points
        //self.scene_view.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.ng = Node_graph_Manager.init(scene_view: &self.scene_view)
    }
    
    var timeStart = NSDate().timeIntervalSince1970
}


//Delegate
extension SC_Controller
{
    func show_cursor_view() -> Bool
    {
        if bool_continuosly_delete
        {
            return true
        }
        return false
    }
    
    func delegate_rotation_and_scale(rotation: SCNVector3, scale: SCNVector3, additive_vs_multiplicative : Bool)
    {
        print("SC_Controller rotation : ", rotation," scale : ", scale)
        ng.set_create_rotation_axial_and_scale_axial(rotation_axial: rotation, scale_axial: scale, additive_vs_multiplicative : additive_vs_multiplicative, mode: self.mode)
    }
    
    func move_commands(command: My_Enums.Menu_World_Move_Option)
    {
        self.mode_move = command
        ng.make_grab_world_nil()
    }
    
    func change_mode_to(mode: My_Enums.Mode)
    {
        self.mode = mode
        
        if mode != .move_object
        {
            self.ng.move_object_mode.cursor_node?.isHidden = true
        }
        
        bool_continuosly_delete = false
    }
    
    func move_command(command: My_Enums.Menu_World_Move_Option)
    {
        print("SC move_command : ", command)
        self.mode_move = command
        ng.make_grab_world_nil()
    }
    
    func create_command(command: My_Enums.Node_Graph_Type_Of_Node)
    {
        ng.create_node(mode: self.mode, tool: command)
    }
    
    func mode_create__set_create_color(color: UIColor)
    {
        print("SC mode_create__set_create_color : ", color)
        self.ng.set_color(color: color, mode: self.mode)
    }
    
    func select_event_object_dependent(event : My_Enums.Select_Node_Options)
    {
        if event == .duplicate
        {
            bool_continuosly_delete = false
            ng.duplicated_selected(mode: self.mode)
        }
        else if event == .delete
        {
            ng.delete_everything(mode: self.mode)
            bool_continuosly_delete = !bool_continuosly_delete
        }
        else
        {
            bool_continuosly_delete = false
        }
    }
    
    func handleTap(gestureRecognize: UITapGestureRecognizer)
    {
        print("SC handleTap")
        
        if Global.GlobalVariables.object_creation_mode == .on_tap_event
        {
            ng.create_node_2(mode:  self.mode)
            
            if (gestureRecognize.state == .ended) &&  (self.mode == .move_object)
            {
                ng.clean(mode: self.mode)
            }
            
            ng.handleTap(gestureRecognize: gestureRecognize)
        }
        else if Global.GlobalVariables.object_creation_mode == .on_time_difference
        {
            bool_draw = !bool_draw
            
            if (gestureRecognize.state == .ended) &&  (self.mode == .move_object)
            {
                ng.clean(mode: self.mode)
            }
            
            ng.handleTap(gestureRecognize: gestureRecognize)
        }
        
    }
    
    
    func session(_ session: ARSession, didUpdate frame: ARFrame,trackingOK: Bool)
    {
        //print("NODEs ? :",number_of_created_elements())
        
        if number_of_created_elements() < max_number_of_create_elements()
        {
            if Global.GlobalVariables.object_creation_mode == .on_tap_event
            {
                
                ng.session(session, didUpdate: frame, mode: self.mode, move_command: self.mode_move, trackingOK: trackingOK)
            }
            else if Global.GlobalVariables.object_creation_mode == .on_time_difference
            {
                let timeNow = NSDate().timeIntervalSince1970
                if bool_draw
                {
                    if Float(timeNow - timeStart) > Global.GlobalVariables.object_creation_time_difference
                    {
                        if trackingOK
                        {
                            ng.create_node_2(mode:  self.mode)
                        }
                        
                        timeStart = timeNow
                    }
                }
                
                ng.session(session, didUpdate: frame, mode: self.mode, move_command: self.mode_move, trackingOK: trackingOK)
            }
        }
        
        if(self.mode == .select && bool_continuosly_delete)
        {
            print("lets delete inresection object")
            
            let location : CGPoint = CGPoint.init(x: scene_view.frame.width * 0.5, y: scene_view.frame.height * 0.5) // in center
            let hitList = scene_view.hitTest(location, options: nil)
            
            if let hitObject = hitList.first
            {
                let node = hitObject.node
                if( ( (node.name != "grid-node") && trackingOK ) )
                {
                    node.removeFromParentNode()
                }
            }
        }
        
        
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if Global.GlobalVariables.object_creation_mode == .on_tap_event
        {
            ng.clean(mode: self.mode)
            let res = ng.touchesBegan(touches, with: event, sceneView: scene_view, mode: self.mode)
            if let safe_res = res
            {
                delegate.delegate_selected_from_SC_Controller(sel: safe_res)
            }
        }
        else if Global.GlobalVariables.object_creation_mode == .on_time_difference
        {
            ng.clean(mode: self.mode)
            let res = ng.touchesBegan(touches, with: event, sceneView: scene_view, mode: self.mode)
            if let safe_res = res
            {
                delegate.delegate_selected_from_SC_Controller(sel: safe_res)
            }
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if Global.GlobalVariables.object_creation_mode == .on_tap_event
        {
            ng.clean(mode: .move_object)
            ng.touchesEnded(touches, with: event)
        }
        else if Global.GlobalVariables.object_creation_mode == .on_time_difference
        {
            ng.clean(mode: .move_object)
            ng.touchesEnded(touches, with: event)
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if Global.GlobalVariables.object_creation_mode == .on_tap_event
        {
            ng.touchesMoved(touches, with: event, sceneView: self.scene_view, mode: self.mode)
        }
        else if Global.GlobalVariables.object_creation_mode == .on_time_difference
        {
            ng.touchesMoved(touches, with: event, sceneView: self.scene_view, mode: self.mode)
        }
    }
    
    func pintch_zoom(sender: UIPinchGestureRecognizer)
    {
        if sender.state == .ended || sender.state == .changed
        {
            let c_scale = self.ng.get_create_scale(mode: .create)
            let c2_scale = Global.construct.scale_calculate(scale: c_scale!, sender_scale: sender.scale).CGFloat_value
            self.ng.set_create_scale(scale: Float(c2_scale), mode: .create)
        }
    }
    
    func delate_all()
    {
        print("SC delate_all")
        insert_and_remove(nodes: [])
    }
    
    
    //tags
    func new_tag_list(tag_list: Tag_List)
    {
        ng.new_tag_list(tag_list: tag_list, mode: self.mode)
    }
    
    func current_tag_list() -> Tag_List
    {
        if let safe_tag_list = ng.current_tag_list(mode: self.mode)
        {
            return safe_tag_list
        }
        return Tag_List() //we return an empty one
    }
    
    //description
    func new_desription(des: Description)
    {
        ng.new_desription(des: des, mode: self.mode)
    }
    
    func current_description() -> Description
    {
        if let safe_desc = ng.current_description(mode: self.mode)
        {
            return safe_desc
        }
        return Description() //we return the empy one
    }
    
    //info
    func current_info() -> Info_Data
    {
        if let safe_info = ng.current_info(mode: self.mode)
        {
            return safe_info
        }
        return Info_Data(txt : "no info from  SC_Controller ")
    }
    
}

//Save, Load
extension SC_Controller
{
    
    func get_current_model_string() -> String?
    {
        print("SC_Controller.get_current_model_string")
        func get_nodes() -> [SCNNode]
        {
            var res : [SCNNode] = []
            if let safe_node = self.scene_view.scene.rootNode.childNode(withName: "node_main", recursively: true)
            {
                res.append(contentsOf: safe_node.childNodes)
            }
            return res
        }
        
        let model = SceneModel.from_nodes_scene_model(nodes: get_nodes())
        
        
        if let safe_model = model
        {
            let str = Translater().run_translate(sc: safe_model)
            return str
        }
        return nil
    }
    
    func save_with_name(name: String)
    {
        func get_nodes() -> [SCNNode]
        {
            var res : [SCNNode] = []
            if let safe_node = self.scene_view.scene.rootNode.childNode(withName: "node_main", recursively: true)
            {
                res.append(contentsOf: safe_node.childNodes)
            }
            return res
        }
        
        print("SC_Controller save_with_name : ", name)
        let model = SceneModel.from_nodes_scene_model(nodes: get_nodes())
        if let safe_model = model
        {
            if(safe_model.universal_node_description.count != 0)
            {
                let str = Translater().run_translate(sc: safe_model)
                MY_IO.save_string_to_standar_path(str!)
                MY_IO.write_to_file(txt: str!, name: safe_model.id)
            }
            
        }
        
        //let str_model = model?.getJSON_string()
        //MY_IO.save_string_to_standar_path(str_model!)
        //MY_IO.write_to_file(txt: str_model!, name: model!.id)
    }
    
    func save_with_name_OLD_FOO(name: String)
    {
        func get_nodes() -> [SCNNode]
        {
            var res : [SCNNode] = []
            if let safe_node = self.scene_view.scene.rootNode.childNode(withName: "node_main", recursively: true)
            {
                res.append(contentsOf: safe_node.childNodes)
            }
            return res
        }
        
        print("SC_Controller save_with_name : ", name)
        let model = SceneModel.from_nodes_scene_model(nodes: get_nodes())
        let str_model = model?.getJSON_string()
        MY_IO.save_string_to_standar_path(str_model!)
        MY_IO.write_to_file(txt: str_model!, name: model!.id)
    }
    
    func load_scene( model : SceneModel)
    {
        insert_and_remove( nodes : model.universal_node_description.map({ (i : Node_Universal_JSON_description) -> Node_Universal in
            let k = i.my_corrisponding_create_command_response.corisponding_Node_Universal()
            k.position = i.pos.getSCNVector3()
            k.eulerAngles = i.rot.getSCNVector3()
            k.scale = i.scale.getSCNVector3()
            k.geometry?.firstMaterial?.diffuse.contents = i.color.getUIColor()
            k.desc = i.desc
            k.tag_list = i.tags
            k.my_corrisponding_create_command_response = i.my_corrisponding_create_command_response
            return k
        }) )
    }
    
    func insert_and_remove(nodes : [SCNNode])
    {
        //_ = self.scene_view.scene.rootNode.childNode(withName: "node_main", recursively: true)?.childNodes.map{ $0.removeFromParentNode() }
        if let safe_noed = self.scene_view.scene.rootNode.childNode(withName: "node_main", recursively: true)
        {
            for i in safe_noed.childNodes
            {
                i.removeFromParentNode()
            }
        }
        self.scene_view.scene.rootNode.childNode(withName: "node_main", recursively: true)?.addChildNodes(nodes)
    }
    
    func number_of_created_elements() -> Int
    {
        if let safe_number =  self.scene_view.scene.rootNode.childNode(withName: "node_main", recursively: true)?.childNodes.count
        {
            return safe_number
        }
        return 0
    }
    
    func max_number_of_create_elements() -> Int
    {
        return 35000
        //return 10;
    }
}

