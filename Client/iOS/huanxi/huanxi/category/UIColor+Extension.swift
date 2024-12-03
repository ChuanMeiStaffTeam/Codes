//
//  UIColor+Extension.swift
//  huanxi
//
//  Created by jack on 2024/2/29.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    static var mainBlueColor: UIColor {
        return .init(hexString: "#009DFF")
    }
    
    static var linkColor: UIColor {
        return .init(hexString: "#0098FE")
    }
    
    static var postBlueColor: UIColor {
        return .init(hexString: "#0098FE")
    }
    
    static var postBgColor: UIColor {
        return .init(hexString: "#212328")
    }
    
    static var white_10: UIColor {
        return .init(hexString: "#FFFFFF",alpha: 0.1)
    }
    
    static var white_60: UIColor {
        return .init(hexString: "#FFFFFF",alpha: 0.6)
    }
    
    static var white_80: UIColor {
        return .init(hexString: "#FFFFFF",alpha: 0.8)
    }
    
    static var black_40: UIColor {
        return .init(hexString: "#000000",alpha: 0.4)
    }
    
    static var black_60: UIColor {
        return .init(hexString: "#000000",alpha: 0.6)
    }
    
    static var black_forground: UIColor {
        return .init(hexString: "#191919",alpha: 1)
    }
    
}

