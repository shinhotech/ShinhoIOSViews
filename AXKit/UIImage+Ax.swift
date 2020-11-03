//
//  UIImage+Ax.swift
//  AXKit
//
//  Created by Lcm on 2018/3/1.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

public extension AXExtension where Base: UIImage {
    
    /// get stretchableImage
    var stretchableImage: AXExtension {
        let image = value.stretchableImage(withLeftCapWidth: Int(value.size.width * 0.5), topCapHeight: Int(value.size.height * 0.5)) as! Base
        return AXExtension(image)
    }
}

