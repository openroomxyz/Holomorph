//
//  Global.swift
//  Holoss
//
//  Created by Rok Kosuta on 17/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit
import UIKit
import Social

struct Global
{
    /*
     static var scene_view : ARSCNView?
     static var vc : ViewController?
     */
    
    struct GlobalVariables
    {
        static var vc : ViewController?
        
        static var grid_should_be_desplayed : Bool = true
        
        static var object_creation_mode : ObjectCreationMode = .on_tap_event
        static var object_creation_time_difference : Float = 1.0
        
        enum ObjectCreationMode
        {
            case on_tap_event
            case on_time_difference
        }
        
    }
    
    struct paths
    {
        static func get_standard_path() -> String
        {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path.appending("/Hologram_standard.txt")
        }
        
    }
    
    struct settings
    {
        static func length_of_hide_full_fs_view() -> Double { return 0.15 }
    }
    
    struct communication
    {
        
        
        /*
         //works but depricated
         static func post_to_facebook(vc_to_present : UIViewController)
         {
         if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
         vc.setInitialText("Look at this great picture!")
         //vc.add(UIImage(named: "myImage.jpg")!)
         vc.add(URL(string: "https://www.hackingwithswift.com"))
         vc_to_present.present(vc, animated: true)
         }
         }
         */
    }
    
    struct Animate
    {
        
        static func full_screen_show_example(duration : Double, view: UIView,parent_view : UIView, while_hiden_f : ((UIView)->())?, completion_f : ((UIView)->())?)
        {
            func frame_fs_hide(_ frame : CGRect) -> CGRect { return CGRect.init(x: frame.width, y: 0.0, width: frame.width, height: frame.height) }
            
            print("Animate full_screen_show_example")
            view.isHidden = true
            while_hiden_f?(view)
            view.frame = frame_fs_hide(parent_view.frame)//CGRect.init(x: parent_view.frame.width, y: 0.0, width: parent_view.frame.width, height: parent_view.frame.height)
            view.isHidden = false
            UIView.animate(withDuration: duration,
                           animations: { () -> Void in
                            view.frame = parent_view.frame.originAtZeroSameWidthHeight()
            }, completion: { (Bool) -> Void in
                completion_f?(view)
            })
        }
        
    }
    
    struct Converter
    {
        struct TimeConverter
        {
            static func conververtTimeSince1970_FromDouble_ToInt(_ a : Double) -> Int
            {
                return Int( (a * 100000) )
            }
            
            static func conververtTimeSince1970_FromInt_ToIntDouble(_ a : Int) -> Double
            {
                return Double(a) / 100000.0
            }
        }
        
    }
    
    struct construct
    {
        
        static func generate_image_from_UILabel(text : String, size : CGSize = CGSize.init(width: 30, height: 30), color : UIColor = UIColor.rgbaFrom0to255(r: 119, g: 136, b: 170, a: 255)) -> UIImage
        {
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
            label.text = text
            label.textColor = color
            let img = UIImage.imageWithLabel(label: label)
            return img
        }
        
        static func grup_node_childs() -> [SCNNode]
        {
            var res : [SCNNode] = []
            let a = SCNNode.init()
            a.geometry = SCNBox.init(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.0)
            a.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            a.position = SCNVector3.init(0.1, 0.1, -0.1)
            res.append(a)
            
            let b = SCNNode.init()
            b.geometry = SCNBox.init(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.0)
            b.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            b.position = SCNVector3.init(-0.1, 0.1, -0.1)
            res.append(b)
            
            let c = SCNNode.init()
            c.geometry = SCNBox.init(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.0)
            c.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            c.position = SCNVector3.init(0.1, -0.1, -0.1)
            res.append(c)
            
            let d = SCNNode.init()
            d.geometry = SCNBox.init(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.0)
            d.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            d.position = SCNVector3.init(-0.1, -0.1, -0.1)
            res.append(d)
            
            
            let e = SCNNode.init()
            e.geometry = SCNBox.init(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.0)
            e.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            e.position = SCNVector3.init(0.1, -0.1, 0.1)
            res.append(e)
            
            let f = SCNNode.init()
            f.geometry = SCNBox.init(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.0)
            f.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            f.position = SCNVector3.init(-0.1, -0.1, 0.1)
            res.append(f)
            
            let g = SCNNode.init()
            g.geometry = SCNBox.init(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.0)
            g.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            g.position = SCNVector3.init(0.1, 0.1, 0.1)
            res.append(g)
            
            let h = SCNNode.init()
            h.geometry = SCNBox.init(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.0)
            h.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            h.position = SCNVector3.init(-0.1, 0.1, 0.1)
            res.append(h)
            return res
        }
        
        static func scale_calculate(scale : Float, sender_scale : CGFloat, sensitivity : Float = 0.1,  min_scale : Float = 0.01, max_scale : Float = 3.00) -> Float
        {
            var tmp_scale = scale
            tmp_scale *= 1 + sensitivity * Float(sender_scale - 1.0)
            
            if tmp_scale > max_scale { tmp_scale = max_scale }
            else if tmp_scale < min_scale { tmp_scale = min_scale }
            
            return tmp_scale
        }
    }
    
    struct Constants
    {
        static func rotate_unicode_string() -> String
        {
            return "⟳"
        }
        
        static func scale_unicode_string() -> String
        {
            return "⿹"
        }
        
        static func unlocked_to_camera_string() -> String
        {
            return "FC"
        }
        static func locked_to_camera_string() -> String
        {
            return "LC"
        }
        
        struct Colors
        {
            static func menu_button_color() -> UIColor
            {
                return UIColor.rgbaFrom0to255(r: 78, g: 99, b: 142, a: 100)
            }
            
            static func standard_color_background_of_view() -> UIColor
            {
                return UIColor.rgbaFrom0to255(r: 45, g: 68, b: 113, a: 255)
            }
            
            static func standard_color_table_cell_background() -> UIColor
            {
                return UIColor.rgbaFrom0to255(r: 119, g: 136, b: 170, a: 255)
            }
        }
        
        struct Emoji
        {
            static func video_recording_press_to_record() -> String
            {
                return "📹⏺️"
            }
            
            static func video_recording_press_to_stop() -> String
            {
                return "📹⏹️"
            }
        }
    }
}

