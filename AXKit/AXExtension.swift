//
//  AXExtension.swift
//  AXKit
//
//  Created by Lcm on 2018/2/25.
//  Copyright © 2018年 shinho. All rights reserved.
//


public struct AXExtension<Base> {
    
    public let value: Base
    
    init(_ value: Base) {
        self.value = value
    }
    
}

public protocol AXExtensionCompatible {
    
    associatedtype CompatibleType
    
    static var ax: AXExtension<CompatibleType>.Type { set get }
    var ax: AXExtension<CompatibleType> { set get }
}

extension AXExtensionCompatible {
    public static var ax: AXExtension<Self>.Type {
        set {}
        get {
            return AXExtension<Self>.self
        }
    }
    public var ax: AXExtension<Self> {
        set {}
        get {
            return AXExtension(self)
        }
    }
}

import class Foundation.NSObject
extension NSObject: AXExtensionCompatible {}
