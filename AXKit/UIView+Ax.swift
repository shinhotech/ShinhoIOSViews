//
//  UIView+Ax.swift
//  AXKit
//
//  Created by Lcm on 2018/2/25.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

public extension AXExtension where Base: UIView {
    
    /// set backgroundColor property
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> AXExtension {
        value.backgroundColor = color
        return self
    }
    
    /// set layer.cornerRadius property
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> AXExtension {
        value.layer.cornerRadius = radius
        return self
    }
    
    /// set layer.borderColor property
    @discardableResult
    func borderColor(_ color: UIColor?) -> AXExtension {
        value.layer.borderColor = color?.cgColor
        return self
    }
    
    /// set layer.borderWidth property
    @discardableResult
    func borderWidth(_ width: CGFloat) -> AXExtension {
        value.layer.borderWidth = width
        return self
    }
    
    /// set clipsToBounds property
    @discardableResult
    func clipsToBounds(_ clip: Bool) -> AXExtension {
        value.clipsToBounds = clip
        return self
    }
    
    /// set isUserInteractionEnabled property
    @discardableResult
    func isUserInteractionEnabled(_ allow: Bool) -> AXExtension {
        value.isUserInteractionEnabled = allow
        return self
    }

    /// set translatesAutoresizingMaskIntoConstraints property
    @discardableResult
    func translatesAutoresizingMaskIntoConstraints(_ translate: Bool) -> AXExtension {
        value.translatesAutoresizingMaskIntoConstraints = translate
        return self
    }
    
    /// set isHidden property
    @discardableResult
    func isHidden(_ isHidden: Bool) -> AXExtension {
        value.isHidden = isHidden
        return self
    }
    
    /// set alpha property
    @discardableResult
    func alpha(_ alpha: CGFloat) -> AXExtension {
        value.alpha = alpha
        return self
    }
    
    /// set hitTestInsets property
    @discardableResult
    func hitTestInsets(_ insets: UIEdgeInsets) -> AXExtension {
        value.hitTestInsets = insets
        return self
    }
    
    
    
    /// add bottom separated line
    @discardableResult
    func addBottomSeparatedLine(left: CGFloat = 0,
                                       right: CGFloat = 0,
                                       color: UIColor? = UIColor.black.withAlphaComponent(0.06),
                                       height: CGFloat = 1.0) -> AXExtension {
        return addSeparatedLine(edge: .bottom, insets: UIEdgeInsets(top: 0, left: left, bottom: 0, right: right), color: color, lineWidth: height)
    }
    
    
    /// add separated line
    @discardableResult
    func addSeparatedLine(edge: UIRectEdge,
                                  insets: UIEdgeInsets,
                                  color: UIColor?,
                                  lineWidth: CGFloat) -> AXExtension {
        
        let line = UIView().ax.backgroundColor(color).translatesAutoresizingMaskIntoConstraints(false).value
        line.tag = tagFromEdge(edge)
        
        let superView = value
        superView.addSubview(line)
        
        let views = ["line":line]
        let metrics = ["left":insets.left, "right":insets.right, "top": insets.top, "bottom": insets.bottom, "width":lineWidth]
        var constraints = [NSLayoutConstraint]()
        if edge == .bottom || edge == .top {
            let format = (edge == .bottom) ? "V:[line(width)]|" : "V:|[line(width)]"
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[line]-right-|", options: [], metrics: metrics, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: metrics, views: views)
        } else if edge == .left || edge == .right {
            let format = (edge == .right) ? "H:[line(width)]|" : "H:|[line(width)]"
            constraints += NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: metrics, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[line]-bottom-|", options: [], metrics: metrics, views: views)
        }
        NSLayoutConstraint.activate(constraints)
        
        return self
    }
    
    /// remove separated line
    @discardableResult
    func removeSeparatedLine(edge: UIRectEdge) -> AXExtension {
        let tag = tagFromEdge(edge)
        let line = value.subviews.first(where: { $0.tag == tag })
        line?.removeFromSuperview()
        return self
    }
    
    private func tagFromEdge(_ edge: UIRectEdge) -> Int {
        if edge == .left { return 108 + 101 + 102 + 116 }
        if edge == .right { return 114 + 105 + 103 + 104 + 116 }
        if edge == .bottom { return 98 + 111 + 116 + 116 + 111 + 109 }
        if edge == .top { return 116 + 111 + 112 }
        return 0
    }
    
}
