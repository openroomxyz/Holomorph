//
//  ExportGenerator_extension.swift
//  Holoss
//
//  Created by Rok Kosuta on 01/03/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import ARKit

extension ExportGenerator
{
    func generate(str : String) -> String
    {
        let image = UIImage.init(named: "002.jpg")
        let data_str = image!.convertImageToBase64_JPEG(quality: 0.5)!
        
        let recursion_limit = 100
        let tn : [TextNode] = [TextNode(id: "bad0435e-3556-4b8a-a148-9ea2dc5ef42e", name: "L019", ext:"html", value: nil, recursion_limit : recursion_limit),
                               TextNode(id: "19b33dee-abe1-46d7-a588-58e68a29173a", name: "stats.min", ext: "js", value: nil, recursion_limit : recursion_limit),
                               TextNode(id: "d3f4ce84-970c-488b-b3ea-dc63ecb1481f", name: "OrbitControls", ext: "js", value: nil, recursion_limit : recursion_limit),
                               TextNode(id: "c928574f-19a1-414b-9165-3ff34ed32738", name: "three.min", ext: "js", value: nil, recursion_limit : recursion_limit),
                               TextNode(id: "6a4efadd-c0bc-4b0a-837c-810cedfed93d", name: "three", ext: "js", value: nil, recursion_limit : recursion_limit),
                               TextNode(id: "acb39b03-c028-4ed0-8d76-082bc4aebd15", name: "dat.gui.min", ext: "js", value: nil, recursion_limit : recursion_limit),
                               TextNode(id: "fc890bee-8aab-4d29-973a-8b5fe657aff3", name: "Detector", ext: "js", value: nil, recursion_limit : recursion_limit),
                               TextNode(id: "db75f96b-efc4-4dc6-83d3-5ba8c18e5534", name: "device_orientation_controls", ext: "js", value: nil, recursion_limit : recursion_limit),
                               TextNode(id: "53366ace-bf8a-43f9-95c9-cd3cf72f702e", name: "L008", ext: "js", value: nil, recursion_limit : recursion_limit),
                               TextNode(id: "d8a66434-e4a0-41bb-96be-fcdf60aaf50b", name: "xxx", ext: "xxx", value: str, recursion_limit : recursion_limit),
                               TextNode(id: "90a7e9f2-878e-46b9-8493-e551d6c4dec2", name: "helper019", ext: "js", value: str, recursion_limit : recursion_limit),
                               TextNode(id: "09e43568-c30d-49e7-992e-16049bb8909b", name: "xxx", ext: "xxx", value: data_str.replacingOccurrences(of: "\n", with: ""), recursion_limit : recursion_limit)]
        let n = tn.map{ $0.try_to_read_value(f_read: MY_IO.get_file_string_in_bundle_with) }
        var k = TextNode.eval(a: n)
        return k![0].value!
    }
    
    /*
     func generate_custom_image(str : String, image : UIImage) -> String
     {
     let data_str = image.convertImageToBase64_JPEG(quality: 0.5)!
     
     let recursion_limit = 100
     let tn : [TextNode] = [TextNode(id: "bad0435e-3556-4b8a-a148-9ea2dc5ef42e", name: "L019", ext:"html", value: nil, recursion_limit : recursion_limit),
     TextNode(id: "19b33dee-abe1-46d7-a588-58e68a29173a", name: "stats.min", ext: "js", value: nil, recursion_limit : recursion_limit),
     TextNode(id: "d3f4ce84-970c-488b-b3ea-dc63ecb1481f", name: "OrbitControls", ext: "js", value: nil, recursion_limit : recursion_limit),
     TextNode(id: "c928574f-19a1-414b-9165-3ff34ed32738", name: "three.min", ext: "js", value: nil, recursion_limit : recursion_limit),
     TextNode(id: "6a4efadd-c0bc-4b0a-837c-810cedfed93d", name: "three", ext: "js", value: nil, recursion_limit : recursion_limit),
     TextNode(id: "acb39b03-c028-4ed0-8d76-082bc4aebd15", name: "dat.gui.min", ext: "js", value: nil, recursion_limit : recursion_limit),
     TextNode(id: "fc890bee-8aab-4d29-973a-8b5fe657aff3", name: "Detector", ext: "js", value: nil, recursion_limit : recursion_limit),
     TextNode(id: "db75f96b-efc4-4dc6-83d3-5ba8c18e5534", name: "device_orientation_controls", ext: "js", value: nil, recursion_limit : recursion_limit),
     TextNode(id: "53366ace-bf8a-43f9-95c9-cd3cf72f702e", name: "L008", ext: "js", value: nil, recursion_limit : recursion_limit),
     TextNode(id: "d8a66434-e4a0-41bb-96be-fcdf60aaf50b", name: "xxx", ext: "xxx", value: str, recursion_limit : recursion_limit),
     TextNode(id: "90a7e9f2-878e-46b9-8493-e551d6c4dec2", name: "helper019", ext: "js", value: str, recursion_limit : recursion_limit),
     TextNode(id: "09e43568-c30d-49e7-992e-16049bb8909b", name: "xxx", ext: "xxx", value: data_str.replacingOccurrences(of: "\n", with: ""), recursion_limit : recursion_limit)]
     let n = tn.map{ $0.try_to_read_value(f_read: MY_IO.get_file_string_in_bundle_with) }
     var k = TextNode.eval(a: n)
     return k![0].value!
     }
     */
    
    func generate_custom_image(str : String, image : UIImage) -> String
    {
        let data_str = image.convertImageToBase64_JPEG(quality: 0.5)!
        
        let recursion_limit = 100
        let tn : [TextNode] = [TextNode(id: "bad0435e-3556-4b8a-a148-9ea2dc5ef42e", name: "L_Testing", ext:"html", value: nil, recursion_limit : recursion_limit),
                               //TextNode(id: "19b33dee-abe1-46d7-a588-58e68a29173a", name: "stats.min", ext: "js", value: nil, recursion_limit : recursion_limit),
            TextNode(id: "d3f4ce84-970c-488b-b3ea-dc63ecb1481f", name: "OrbitControls", ext: "js", value: nil, recursion_limit : recursion_limit),
            //TextNode(id: "c928574f-19a1-414b-9165-3ff34ed32738", name: "three.min", ext: "js", value: nil, recursion_limit : recursion_limit),
            TextNode(id: "6a4efadd-c0bc-4b0a-837c-810cedfed93d", name: "three.min", ext: "js", value: nil, recursion_limit : recursion_limit),
            //TextNode(id: "acb39b03-c028-4ed0-8d76-082bc4aebd15", name: "dat.gui.min", ext: "js", value: nil, recursion_limit : recursion_limit),
            TextNode(id: "fc890bee-8aab-4d29-973a-8b5fe657aff3", name: "Detector", ext: "js", value: nil, recursion_limit : recursion_limit),
            TextNode(id: "db75f96b-efc4-4dc6-83d3-5ba8c18e5534", name: "device_orientation_controls", ext: "js", value: nil, recursion_limit : recursion_limit),
            TextNode(id: "53366ace-bf8a-43f9-95c9-cd3cf72f702e", name: "L008", ext: "js", value: nil, recursion_limit : recursion_limit),
            TextNode(id: "d8a66434-e4a0-41bb-96be-fcdf60aaf50b", name: "xxx", ext: "xxx", value: str, recursion_limit : recursion_limit),
            TextNode(id: "90a7e9f2-878e-46b9-8493-e551d6c4dec2", name: "L", ext: "js", value: str, recursion_limit : recursion_limit),
            TextNode(id: "09e43568-c30d-49e7-992e-16049bb8909b", name: "xxx", ext: "xxx", value: data_str.replacingOccurrences(of: "\n", with: ""), recursion_limit : recursion_limit)]
        let n = tn.map{ $0.try_to_read_value(f_read: MY_IO.get_file_string_in_bundle_with) }
        var k = TextNode.eval(a: n)
        return k![0].value!
    }
}

