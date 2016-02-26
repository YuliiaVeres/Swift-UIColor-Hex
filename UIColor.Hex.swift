//
//  UIColor+Hex.swift
//  TasteFor
//
//  Created by Yuliia Veresklia on 2/26/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

import UIKit

public enum UIColorInputError : ErrorType {
    case MissingPrefix,
    UnableToScanHexValue,
    MismatchedHexStringLength
}

extension UIColor {
    
    class func colorFromHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        
        do {
            return try UIColor(rgba_throws: hex, alpha: alpha)
        } catch {
            return UIColor.whiteColor()
        }
    }
    
    public override var description: String {
        return self.hexString(true)
    }
    
    public override var debugDescription: String {
        return self.hexString(true)
    }
}

private extension UIColor {
    
    convenience init(rgba_throws rgba: String, alpha: CGFloat) throws {
        var hex = rgba
        
        if rgba.hasPrefix("#") == false {
            hex = "#\(rgba)"
        }
        
        guard let hexString: String = hex.substringFromIndex(hex.startIndex.advancedBy(1)),
            var   hexValue:  UInt32 = 0
            where NSScanner(string: hexString).scanHexInt(&hexValue) else {
                throw UIColorInputError.UnableToScanHexValue
        }
        
        guard hexString.characters.count  == 3
            || hexString.characters.count == 4
            || hexString.characters.count == 6
            || hexString.characters.count == 8 else {
                throw UIColorInputError.MismatchedHexStringLength
        }
        
        switch (hexString.characters.count) {
        case 3:
            self.init(hex3: UInt16(hexValue), alpha: alpha)
        case 4:
            self.init(hex4: UInt16(hexValue), alpha: alpha)
        case 6:
            self.init(hex6: hexValue, alpha: alpha)
        default:
            self.init(hex8: hexValue, alpha: alpha)
        }
    }
    
    convenience init(rgba: String, defaultColor: UIColor = UIColor.clearColor()) {
        guard let color = try? UIColor(rgba_throws: rgba, alpha: 1.0) else {
            self.init(CGColor: defaultColor.CGColor)
            return
        }
        self.init(CGColor: color.CGColor)
    }
    
    convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hex4: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hex8: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func hexString(includeAlpha: Bool) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha) {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}

