//
//  UIScrollView+Ax.swift
//  AXKit
//
//  Created by Lcm on 2018/2/28.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

public extension AXExtension where Base: UIScrollView {
    
    /// set showsVerticalScrollIndicator property
    @discardableResult
    func showsVerticalScrollIndicator(_ show: Bool) -> AXExtension {
        value.showsVerticalScrollIndicator = show
        return self
    }
    
    /// set showsHorizontalScrollIndicator property
    @discardableResult
    func showsHorizontalScrollIndicator(_ show: Bool) -> AXExtension {
        value.showsHorizontalScrollIndicator = show
        return self
    }
    
    /// set showsHorizontalScrollIndicator property
    @available(iOS 11.0, *)
    @discardableResult
    func contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> AXExtension {
        value.contentInsetAdjustmentBehavior = behavior
        return self
    }
    
}

//extension UIScrollView {
//    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !isDragging {
//            next?.touchesBegan(touches, with: event)
//        }
//        super.touchesBegan(touches, with: event)
//    }
//}
