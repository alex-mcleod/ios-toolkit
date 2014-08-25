//
//  ColorUtils.swift
//  Spaces
//
//  Created by Alex McLeod on 10/07/2014.
//  Copyright (c) 2014 Alex McLeod. All rights reserved.
//

import Foundation

class ColorUtils {
    class func _intFromHexString(hexStr:String) -> Int {
        var hexInt:CUnsignedInt = 0
        let scanner = NSScanner(string: hexStr)
        // Tell scanner to skip the #
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "#")
        scanner.scanHexInt(&hexInt)
        return Int(hexInt)
    }
    
    class func colorFromHexString(hexStr: String, alpha: Float) -> UIColor {
        let hexInt = self._intFromHexString(hexStr)
        let red = Float((hexInt & 0xFF0000) >> 16) / 255
        let green = Float((hexInt & 0xFF00) >> 8) / 255
        let blue = Float(hexInt & 0xFF) / 255
        return UIColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
    }
    
    class func colorFromHexString(hexStr: String) -> UIColor {
        return self.colorFromHexString(hexStr, alpha: 1.0)
    }
    
    class func colorInPalette(colors: Array<UIColor>, fromNumber number:NSNumber) -> UIColor {
        return colors[Int(number) % colors.count]
    }
    
}

