//
//  Grid_Node.swift
//  Holoss
//
//  Created by Rok Kosuta on 05/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

class Grid_Node : SCNNode
{
    
    class func create() -> Grid_Node
    {
        let grid = Grid_Node.init()
        grid.my_create_special_for_grid()
        return grid
    }
    
    private func my_create_special_for_grid()
    {
        self.name = "grid-node"
        
        func box_1_method(_ thicknes: CGFloat, _ x: Int, _ y: Int, _ color: UIColor, length : CGFloat, fak : Float = Float(0.1)) {
            let box_1 =  SCNNode()// SC_Box() //think about not incress complexity
            box_1.geometry = SCNBox.init(width: thicknes, height: thicknes, length: length, chamferRadius: 0.0)
            let fak = Float(0.1)
            box_1.position = SCNVector3.init(Float(x) * fak, Float(y) * fak, Float(0.0) * fak)
            box_1.geometry?.firstMaterial?.diffuse.contents = color
            box_1.name = "grid-node"
            self.addChildNode(box_1)
        }
        
        func box_2_method(_ thicknes: CGFloat, _ x: Int, _ y: Int, _ color: UIColor, length : CGFloat,fak2 : Float = Float(0.1)) {
            let box_2 = SCNNode()
            box_2.geometry = SCNBox.init(width: thicknes, height: length, length: thicknes, chamferRadius: 0.0)
            box_2.position = SCNVector3.init(Float(x) * fak2, Float(0.0) * fak2, Float(y) * fak2)
            box_2.geometry?.firstMaterial?.diffuse.contents = color
            box_2.name = "grid-node"
            self.addChildNode(box_2)
        }
        
        func box_3_method(_ thicknes: CGFloat, _ x: Int, _ y: Int, _ color: UIColor, length : CGFloat, fak3 : Float = Float(0.1)) {
            let box_3 = SCNNode()
            box_3.geometry = SCNBox.init(width: length, height: thicknes, length: thicknes, chamferRadius: 0.0)
            box_3.position = SCNVector3.init(Float(0.0) * fak3, Float(x) * fak3, Float(y) * fak3)
            box_3.geometry?.firstMaterial?.diffuse.contents = color
            box_3.name = "grid-node"
            self.addChildNode(box_3)
        }
        
        
        let thicknes = CGFloat(0.0005)
        let color : UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        
        for x in -5...5
        {
            for y in -5...5
            {
                box_1_method(thicknes, x, y, color, length: CGFloat(1.0))
                box_2_method(thicknes, x, y, color, length: CGFloat(1.0))
                box_3_method(thicknes, x, y, color, length: CGFloat(1.0))
            }
        }
        
    }
    
    
    func update(frame: ARFrame, wp : SCNVector3)
    {
        var data = World.calculate_camera_position_and_orientation(frame: frame)//Node_graph_Manager.calculate_camera_position_and_orientation(frame: frame)
        var cam_position = data.position - wp
        
        var d = cam_position - self.position
        
        func f1(value : Float , step : Float, f_in : (Float)->SCNVector3)
        {
            if abs(value) > step
            {
                self.position = f_in(value.isPositiveNumber ? step : -step)
            }
        }
        
        func f2(k : Float, v : SCNVector3)
        {
            f1(value: v.x, step: k, f_in : self.position.add_to_x_axis)
            f1(value: v.y, step: k, f_in : self.position.add_to_y_axis)
            f1(value: v.z, step: k, f_in : self.position.add_to_z_axis)
        }
        
        
        f2(k: 0.1, v : d)
        
        self.isHidden = !(Global.GlobalVariables.grid_should_be_desplayed)
    }
    
    func update_old(frame: ARFrame)
    {
        var data = World.calculate_camera_position_and_orientation(frame: frame)//Node_graph_Manager.calculate_camera_position_and_orientation(frame: frame)
        var cam_position = data.position
        
        var d = cam_position - self.position
        
        func f1(value : Float , step : Float, f_in : (Float)->SCNVector3)
        {
            if abs(value) > step
            {
                self.position = f_in(value.isPositiveNumber ? step : -step)
            }
        }
        
        func f2(k : Float, v : SCNVector3)
        {
            f1(value: v.x, step: k, f_in : self.position.add_to_x_axis)
            f1(value: v.y, step: k, f_in : self.position.add_to_y_axis)
            f1(value: v.z, step: k, f_in : self.position.add_to_z_axis)
        }
        
        
        f2(k: 0.1, v : d)
        
    }
}

