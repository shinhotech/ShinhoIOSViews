//
//  UITextField+Ax.swift
//  AXKit
//
//  Created by Lcm on 2018/3/1.
//  Copyright © 2018年 shinho. All rights reserved.
//
import UIKit

public extension AXExtension where Base: UITextField {
    
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
    
    /// set placeholder property
    @discardableResult
    func placeholder(_ placeholder: String?) -> AXExtension {
        value.placeholder = placeholder
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
    func textAlignment(_ align: NSTextAlignment) -> AXExtension {
        value.textAlignment = align
        return self
    }
    
    /// set clearButtonMode property
    @discardableResult
    func clearButtonMode(_ clearButtonMode: UITextField.ViewMode) -> AXExtension {
        value.clearButtonMode = clearButtonMode
        return self
    }
    
    /// set returnKeyType property
    @discardableResult
    func returnKeyType(_ type: UIReturnKeyType) -> AXExtension {
        value.returnKeyType = type
        return self
    }
    
    /// set keyboardType property
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> AXExtension {
        value.keyboardType = type
        return self
    }
    
    

}
