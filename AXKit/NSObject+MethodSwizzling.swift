//
//  NSObject+MethodSwizzling.swift
//  AXKit
//
//  Created by Lcm on 2018/3/16.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

public extension NSObject {
    class func swizzleMethodSelector(_ originalSelector: Selector, withSelector swizzledSelector: Selector){
        
        guard let originalMethod = class_getInstanceMethod(self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else {
                return
        }
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
