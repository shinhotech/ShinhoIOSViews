//
//  UIButton+Ax.swift
//  AXKit
//
//  Created by Lcm on 2018/2/25.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

public extension AXExtension where Base: UIButton {
    
    /// set title property
    @discardableResult
    func title(_ title: String?, for state: UIControl.State = .normal) -> AXExtension {
        value.setTitle(title, for: state)
        return self
    }
    
    /// set titleColor property
    @discardableResult
    func titleColor(_ color: UIColor?, for state: UIControl.State = .normal) -> AXExtension {
        value.setTitleColor(color, for: state)
        return self
    }
    
    /// set font property
    @discardableResult
    func font(_ font: UIFont!) -> AXExtension {
        value.titleLabel?.font = font
        return self
    }
    
    /// set image property
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> AXExtension {
        value.setImage(image, for: state)
        return self
    }
    
    /// set backgroundImage property
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> AXExtension {
        value.setBackgroundImage(image, for: state)
        return self
    }
    
    /// set adjustsImageWhenHighlighted property
    @discardableResult
    func adjustsImageWhenHighlighted(_ adjust: Bool) -> AXExtension {
        value.adjustsImageWhenHighlighted = adjust
        return self
    }
    
    /// set isEnabled property
    @discardableResult
    func isEnabled(_ enabled: Bool) -> AXExtension {
        value.isEnabled = enabled
        return self
    }
}
