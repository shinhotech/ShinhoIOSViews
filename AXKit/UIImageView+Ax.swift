//
//  UIImageView+Ax.swift
//  AXKit
//
//  Created by Lcm on 2018/2/25.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

public extension AXExtension where Base: UIImageView {
    
    /// set contentMode property
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> AXExtension {
        value.contentMode = mode
        return self
    }
    
    @discardableResult
    func image(_ image: UIImage?) -> AXExtension {
        value.image = image
        return self
    }
}
