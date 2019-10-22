//
//  SC_Controller_Direct.swift
//  HoloMorph
//
//  Created by Rok Kosuta on 05/04/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit



struct SC_Controller_Direct
{
    var scene_view : ARSCNView?
    
    var needsToBeInitialized : Bool = true
    let smart : SmartObjects.FirstExample = SmartObjects.FirstExample.create()
    
    static func enabled() -> Bool
    {
        return true
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame)
    {
        let point = CGPoint.init(x: scene_view!.frame.width * 0.5, y: scene_view!.frame.height * 0.5)
        let hitList = scene_view!.hitTest(point, options: nil)
        
        if let hitObject = hitList.first
        {
            
            let node = hitObject.node
            if ( node is SmartObjects.FirstExample)
            {
                (node as? SmartObjects.FirstExample)?.pip2(hit: hitObject);
            }
        }
    }
    
    mutating func handleTap(gestureRecognize: UITapGestureRecognizer)
    {
        print("SC_Controller_Direct tap")
        
        if needsToBeInitialized
        {
            needsToBeInitialized = false
            
        }
        
        
        //let location = touch.location(in: scene_view)
        let point = gestureRecognize.location(in: scene_view)
        let hitList = scene_view!.hitTest(point, options: nil)
        
        if let hitObject = hitList.first
        {
            
            let node = hitObject.node
            if ( node is SmartObjects.FirstExample)
            {
                (node as? SmartObjects.FirstExample)?.pip(hit: hitObject);
            }
        }
        
        print(Int.random(min: 1, max: 3))
        
        //let point = gestureRecognize.location(in: scene_view)
        //Network.network.addMessage(m:  Network.Message(type: "img", countent: "Touch In View x:"+String(Float(point.x))+" y:"+String(Float(point.y)), page: 1, pages: 10, messageid: "image-id_Something"), user_from_uid(<#T##uid_t#>, <#T##Int32#>))
        //Network.network.addMessage(m:  Network.Message(type: "img", countent: "Touch In View x:"+String(Float(point.x))+" y:"+String(Float(point.y)), page: 1, pages: 10, messageid: "image-id_Something", from: "rok_iPhone", to: "storage_node", status: Network.Message.MessageStatus.not_sent))
    }
}


extension SC_Controller_Direct
{
    func draw_something_000()
    {
        let n = 10000
        for i in 0 ... n
        {
            let p = Double(n) / Double(i)
            let x = sin(p * 3.1415 * 2.0)
            let y = cos(p * 3.1415 * 2.0)
            let z = sin((x+y) * 30)
            pen(position: SCNVector3.init(x, y, z))
        }
    }
    
    func pen(position : SCNVector3)
    {
        let node = SCNNode.init()
        let geo = SCNBox.init()
        let mat = SCNMaterial.init()
        mat.diffuse.contents = UIColor.yellow
        geo.firstMaterial = mat
        node.geometry = geo
        
        node.position = position
        node.scale = SCNVector3.init(0.05, 0.05, 0.05)
        
        scene_view?.scene.rootNode.addChildNode(node)
    }
}
