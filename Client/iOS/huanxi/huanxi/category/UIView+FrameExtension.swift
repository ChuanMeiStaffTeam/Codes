//
//  UIView+FrameExtension.swift
//  huanxi
//
//  Created by jack on 2024/2/27.
//

import UIKit

extension UIView {
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }

    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            frame.origin.y = newValue - frame.size.height
        }
    }
    
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            frame.origin.x = newValue - frame.size.width
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }

    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }
}
