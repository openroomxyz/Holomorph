//
//  UIColor_Extension.swift
//  Holoss
//
//  Created by Rok Kosuta on 23/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    static func randomColorWithAlpha255() -> UIColor
    {
        return UIColor.rgbaFrom0to255(r: Int.random(min: 0, max: 255) , g: Int.random(min: 0, max: 255), b: Int.random(min: 0, max: 255), a: 255)
    }
}

extension UIColor
{
    static func rgbaFrom0to255(r : Int, g : Int, b : Int, a : Int) -> UIColor
    {
        return UIColor.init(red: CGFloat(r) / 255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a) / 255)
    }
}


extension UIColor
{
    /**
     Returns the components that make up the color in the RGB color space as a tuple.
     
     - returns: The RGB components of the color or `nil` if the color could not be converted to RGBA color space.
     */
    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)?
    {
        var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        {
            return (red, green, blue, alpha)
        }
        else
        {
            return nil
        }
    }
    
    /**
     Returns the components that make up the color in the HSB color space as a tuple.
     
     - returns: The HSB components of the color or `nil` if the color could not be converted to HSBA color space.
     */
    func getHSBAComponents() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)?
    {
        var (hue, saturation, brightness, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        {
            return (hue, saturation, brightness, alpha)
        }
        else
        {
            return nil
        }
    }
    
    /**
     Returns the grayscale components of the color as a tuple.
     
     - returns: The grayscale components or `nil` if the color could not be converted to grayscale color space.
     */
    func getGrayscaleComponents() -> (white: CGFloat, alpha: CGFloat)?
    {
        var (white, alpha) = (CGFloat(0.0), CGFloat(0.0))
        if self.getWhite(&white, alpha: &alpha)
        {
            return (white, alpha)
        }
        else
        {
            return nil
        }
    }
}
