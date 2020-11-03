//
//  UILabel+Ax.swift
//  AXKit
//
//  Created by Lcm on 2018/2/25.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

public extension AXExtension where Base: UILabel {
    
    /// set text property
    @discardableResult
    func text(_ text: String?) -> AXExtension {
        value.text = text
        return self
    }
    
    /// set attributedText property
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString?) -> AXExtension {
        value.attributedText = attributedText
        return self
    }
    
    /// set textColor property
    @discardableResult
    func textColor(_ textColor: UIColor!) -> AXExtension {
        value.textColor = textColor
        return self
    }
    
    /// set font property
    @discardableResult
    func font(_ font: UIFont!) -> AXExtension {
        value.font = font
        return self
    }
    
    /// set textAlignment property
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> AXExtension {
        value.textAlignment = textAlignment
        return self
    }
    
    /// set numberOfLines property
    @discardableResult
    func numberOfLines(_ numberOfLines: Int) -> AXExtension {
        value.numberOfLines = numberOfLines
        return self
    }
    
    /// set adjustsFontSizeToFitWidth property
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjust: Bool) -> AXExtension {
        value.adjustsFontSizeToFitWidth = adjust
        return self
    }
    
    /// set adjustsFontSizeToFitWidth property
    @discardableResult
    func lineBreakMode(_ mode: NSLineBreakMode) -> AXExtension {
        value.lineBreakMode = mode
        return self
    }
    
}
