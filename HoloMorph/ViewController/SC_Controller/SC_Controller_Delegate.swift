//
//  SC_Controller_Protocol.swift
//  Holoss
//
//  Created by Rok Kosuta on 19/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

protocol SC_Controller_Delegate
{
    init(scene_view : ARSCNView, delegate : Controller_user_interface_new_Delegate)
    
    //CHANGE MODE
    func change_mode_to(mode : My_Enums.Mode)
    
    //COMMANDS PER MODE
    func move_commands(command : My_Enums.Menu_World_Move_Option)//func move_command(command : My_Enums.Move_mode_commands)
    //func create_command(command : SC_Controller.Create_mode_commands)
    func create_command(command : My_Enums.Node_Graph_Type_Of_Node)
    
    //other
    func mode_create__set_create_color(color : UIColor)
    
    //MENU MENU
    func delate_all()
    
    //Select
    func select_event_object_dependent(event : My_Enums.Select_Node_Options)
    
    //tag
    func new_tag_list(tag_list : Tag_List)
    func current_tag_list() -> Tag_List
    
    //func desription
    func new_desription(des : Description)
    func current_description() -> Description
    
    //info data (select)
    func current_info() -> Info_Data
    
    //var rec : Recorder {get set}
    
    //updating
    func handleTap(gestureRecognize: UITapGestureRecognizer)
    func session(_ session: ARSession, didUpdate frame: ARFrame, trackingOK : Bool)
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    func pintch_zoom( sender : UIPinchGestureRecognizer)
    
    //new way od doing no more event
    func load_scene( model : SceneModel)
    func save_with_name( name : String )
    
    //rotation and scale
    func delegate_rotation_and_scale(rotation: SCNVector3, scale: SCNVector3, additive_vs_multiplicative : Bool)
    
    func get_current_model_string() -> String?
    func number_of_created_elements() -> Int
    func max_number_of_create_elements() -> Int
    
    func show_cursor_view() -> Bool
}
