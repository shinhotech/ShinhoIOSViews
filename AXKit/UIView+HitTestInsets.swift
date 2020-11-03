//
//  UIView+HitTestInsets.swift
//  AXKit
//
//  Created by Lcm on 2018/3/16.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit
private var isSwizzled = false
public extension UIView {
    private struct AssociatedKey {
        static let hitTestInsetsKey = UnsafeRawPointer(bitPattern: "hitTestInsetsKey".hashValue)!
    }
    private static func swizzlePointInside() {
        UIView.swizzleMethodSelector(#selector(point(inside:with:)), withSelector: #selector(ax_point(inside:with:)))
    }
    
    /// 点击内边距
    var hitTestInsets: UIEdgeInsets?  {
        set {
            if !isSwizzled {
                UIView.swizzlePointInside()
                isSwizzled = true
            }
            objc_setAssociatedObject(self, AssociatedKey.hitTestInsetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            if !isSwizzled {
                UIView.swizzlePointInside()
                isSwizzled = true
            }
            return objc_getAssociatedObject(self, AssociatedKey.hitTestInsetsKey) as? UIEdgeInsets
        }
    }
    
    @objc private func ax_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if var insets = hitTestInsets {
            insets = UIEdgeInsets(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
            return bounds.inset(by: insets).contains(point)
        }
        
        return ax_point(inside: point, with: event)
    }
}

