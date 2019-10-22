//
//  My_Enums.swift
//  Holoss
//
//  Created by Rok Kosuta on 22/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

struct My_Enums
{
    enum Node_Graph_Type_Of_Node : Int, Codable {
        
        case sphere
        case box
        case cone
        case cylinder
        case plane
        case pyramid
        case torus
        case tube
        
        private func corisponding_SCNGeometry() -> SCNGeometry
        {
            switch self
            {
            case .sphere:
                return SCNSphere(radius: SCNNode.MY_default_scale())
            case .box:
                return SCNBox(width: SCNNode.MY_default_scale(), height: SCNNode.MY_default_scale(), length: SCNNode.MY_default_scale(), chamferRadius: 0.0)
            case .cone:
                return SCNCone(topRadius: SCNNode.MY_default_scale() * 0.1, bottomRadius: SCNNode.MY_default_scale(), height: SCNNode.MY_default_scale())
            case .cylinder:
                return SCNCylinder(radius: SCNNode.MY_default_scale(), height: SCNNode.MY_default_scale())
            case .plane:
                return SCNPlane(width: SCNNode.MY_default_scale(), height: SCNNode.MY_default_scale())
            case .pyramid:
                return SCNPyramid(width: SCNNode.MY_default_scale(), height: SCNNode.MY_default_scale(), length: SCNNode.MY_default_scale())
            case .torus:
                return SCNTorus(ringRadius: SCNNode.MY_default_scale(), pipeRadius:  SCNNode.MY_default_scale() * 0.06)
            case .tube:
                return SCNTube(innerRadius: SCNNode.MY_default_scale() * 0.8, outerRadius: SCNNode.MY_default_scale(), height:SCNNode.MY_default_scale())
            }
        }
        
        func corisponding_Node_Universal() -> Node_Universal
        {
            let n = Node_Universal.init()
            n.geometry = self.corisponding_SCNGeometry()
            n.my_corrisponding_create_command_response = self
            return n
        }
    }
    
    enum Select_Node_Options
    {
        case duplicate
        case delete
        case changeText
        case color
        case info
        case desciption
        case tags
        case add
        case type
    }
    
    enum Menu_Menu_Option
    {
        case load_save_send
        case email
        case color
        case photo
        case settings
        case export
        case delete_all
    }
    
    enum Menu_World_Move_Option
    {
        case forward
        case back
        case stop
        case world_grab
    }
    
    enum Menu_Main_Option
    {
        case move_object
        case move_world
        case select
        case create
        case menu
    }
    
    enum FullScreen_option
    {
        case text
        case color_selection
        case export
        case settings
        case other
        case info
        case description
        case tags
        case add
        case type
        case save
        case load
        
        static func calculate_from__Menu_Menu_option(_ opt : Menu_Menu_Option) -> FullScreen_option?
        {
            if opt == .load_save_send
            {
                return .load
            }
            else if opt == .color
            {
                return .color_selection
            }
            else if opt == .settings
            {
                return .settings
            }
            else if opt == .export
            {
                return .export
            }
            return nil
        }
        
        static func calculate_from__select_node_options(command : Select_Node_Options) -> FullScreen_option?
        {
            if command == .color
            {
                return FullScreen_option.color_selection
            }
            else if command == .info
            {
                return FullScreen_option.info
            }
            else if command == .desciption
            {
                return FullScreen_option.description
            }
            else if command == .tags
            {
                return FullScreen_option.tags
            }
            else if command == .add
            {
                return FullScreen_option.add
            }
            else if command == .type
            {
                return FullScreen_option.type
            }
            return nil
        }
    }
    
    public enum Mode
    {
        case move_object
        case move_world
        case create
        case select
    }
    
}


