//
//  NSObject+Ax.swift
//  AXKit
//
//  Created by Lcm on 2018/3/20.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

extension NSObject {
    private struct AssociatedKey {
        static let userInfoKey = UnsafeRawPointer(bitPattern: "userInfoKey".hashValue)!
    }
    public var axInfo: Any?  {
        set {
            objc_setAssociatedObject(self, AssociatedKey.userInfoKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, AssociatedKey.userInfoKey)
        }
    }
    
    public static var classString: String {
        return String(describing: self)
    }
}
