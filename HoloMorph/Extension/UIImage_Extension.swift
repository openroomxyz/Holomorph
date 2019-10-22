//
//  UIImage_Extension.swift
//  Holoss
//
//  Created by Rok Kosuta on 18/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    class func imageWithLabel(label: UILabel) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}


extension UIImage
{
    func resizeImage(targetSize: CGSize) -> UIImage
    {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIImage
{
    func convertImageToBase64_JPEG(quality : Float = 0.5) -> String?
    {
        let imageData : Data = self.jpegData(compressionQuality: CGFloat(quality))!
        var strBase64 = imageData.base64EncodedString()
        strBase64 = strBase64.replacingOccurrences(of: "\n", with: "")
        return "data:image/jpeg;base64,"+strBase64
    }
}

extension UIImage
{
    class func createImageWithColor(color : UIColor, size : CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
