//
//  SmartObjects.swift
//  HoloMorph
//
//  Created by Rok Kosuta on 10/04/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

struct SmartObjects { }

extension SmartObjects
{
    class FirstExample : SCNNode
    {
        func pip2(hit : SCNHitTestResult)
        {
            self.geometry?.firstMaterial?.diffuse.contents = UIColor.randomColorWithAlpha255()
            
            let o = FirstExample.init()
            let geo = SCNBox.init()
            let mat = SCNMaterial.init()
            mat.diffuse.contents = UIColor.yellow
            geo.firstMaterial = mat
            o.geometry = geo
            
            o.position =  hit.localCoordinates
            o.scale = SCNVector3.init(0.1, 0.1, 0.1)
            self.addChildNode(o)
        }
        
        func pip(hit : SCNHitTestResult)
        {
            print("o yea!")
            Network.network.send(content: "SmartObjects.FirstExample.pip", type: "TAP", page: 1, pages: 1, messageid: UUID().uuidString, from: "cube", to: "lojz")
            self.geometry?.firstMaterial?.diffuse.contents = UIColor.randomColorWithAlpha255()
            
            let o = FirstExample.init()
            let geo = SCNBox.init()
            let mat = SCNMaterial.init()
            mat.diffuse.contents = UIColor.yellow
            geo.firstMaterial = mat
            o.geometry = geo
            
            o.position =  hit.localCoordinates
            o.scale = SCNVector3.init(0.1, 0.1, 0.1)
            self.addChildNode(o)
        }
        
        static func create() -> FirstExample
        {
            let o = FirstExample.init()
            let geo = SCNBox.init()
            let mat = SCNMaterial.init()
            mat.diffuse.contents = UIColor.yellow
            geo.firstMaterial = mat
            o.geometry = geo
            
            o.position = SCNVector3.init(0, 0, 0)
            o.scale = SCNVector3.init(0.05, 0.05, 0.05)
            return o
        }
    }
}
