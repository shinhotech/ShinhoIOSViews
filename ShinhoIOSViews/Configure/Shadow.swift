//
//  Shadow.swift
//  FSFA
//
//  Created by Lcm on 2018/3/4.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

struct ShadowStyle {
    var color: CGColor?
    var radius: CGFloat
    var opacity: Float
    var offset: CGSize
    
    private static let defaultRadius: CGFloat = 6.0
    private static let defaultOpacity: Float = 0.1
    private static let defaultOffset: CGSize = CGSize(width: 0, height: 2.0)
    private static let defaultColor: CGColor = UIColor.black.cgColor
    
    /// black shadow style (radius: 6.0, opacity: 0.1, offset: (0, 2))
    static let black026 = ShadowStyle(color: defaultColor, radius: defaultRadius, opacity: defaultOpacity, offset: defaultOffset)
    
    /// black shadow style (radius: 4.0, opacity: 0.2, offset: (0, 2))
    static let black024 = ShadowStyle(color: defaultColor, radius: 4.0, opacity: 0.2, offset: defaultOffset)
    
    /// black shadow style (radius: 8.0, opacity: 0.1, offset: (0, 0))
    static let black008 = ShadowStyle(color: defaultColor, radius: 8, opacity: defaultOpacity, offset: CGSize.zero)
    
    /// black shadow style (radius: 8.0, opacity: 0.1, offset: (0, 2))
    static let black028 = ShadowStyle(color: defaultColor, radius: 8, opacity: defaultOpacity, offset: defaultOffset)
    /// black shadow style (radius: 16.0, opacity: 0.1, offset: (0, 4))
    static let black0416 = ShadowStyle(color: defaultColor, radius: 16, opacity: defaultOpacity, offset: CGSize(width: 0, height: 4))
    
    /// red shadow style (radius: 8.0, opacity: 0.5, offset: (0, 2))
    static let red = ShadowStyle(color: UIColor(hex: 0xf66358)?.cgColor, radius: 8, opacity: 0.5, offset: defaultOffset)
    
    /// red shadow style (radius: 6.0, opacity: 0.3, offset: (0, 2))
    static let red026 = ShadowStyle(color: UIColor(hex: 0xef473a)?.cgColor, radius: 6, opacity: 0.3, offset: defaultOffset)
    
    /// orange shadow style (radius: 8.0, opacity: 0.3, offset: (0, 2))
    static let orange028 = ShadowStyle(color: UIColor(hex: 0xfc994e)?.cgColor, radius: 6, opacity: 0.5, offset: defaultOffset)
    
    /// clear shadow style (radius: 8.0, opacity: 0.5, offset: (0, 2))
    static let clear = ShadowStyle(color: nil, radius: 8, opacity: 0.5, offset: defaultOffset)
    
}

extension UIView {
    fileprivate struct AssociatedKeys {
        static let shadowKey = UnsafeRawPointer.init(bitPattern: "shadowKey".hashValue)!
    }
    
    var shadowStyle: ShadowStyle {
        set {
            guard !(self is ShadowOnScreenView) else {
                fatalError("Self is Shadow")
            }
            
            if let shadow = shadow as? ShadowOnScreenView {
                shadow.style = newValue
            }
        }
        get {
            (shadow as! ShadowOnScreenView).style
        }
    }
    
    // fix cycle life at ShadowOnScreenView
    var shadow: UIView {
        var shadowOpt = objc_getAssociatedObject(self, AssociatedKeys.shadowKey) as? ShadowOnScreenView
        if shadowOpt == nil {
            
            let shadowView: ShadowOnScreenView = {
                let view = ShadowOnScreenView()
                view.style = .black026
                return view
            }()
            
            shadowView.addSubview(self)
            
            self.translatesAutoresizingMaskIntoConstraints = false
            let views = ["self":self]
            var constraints = [NSLayoutConstraint]()
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[self]|", options: [], metrics: nil, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[self]|", options: [], metrics: nil, views: views)
            NSLayoutConstraint.activate(constraints)
            
            shadowOpt = shadowView
            objc_setAssociatedObject(self, AssociatedKeys.shadowKey, shadowOpt, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        return shadowOpt!
    }
}


/// 解决离屏渲染
fileprivate
class ShadowOnScreenView: UIView {
    let shapeLayer = CAShapeLayer()
    
    var observe: NSKeyValueObservation?
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
    }
    
    // fix cycle life
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview == nil {
            for sub in subviews {
                sub.removeFromSuperview()
            }
        }
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        observe?.invalidate()
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        observe = subview.observe(\.isHidden, options: .new, changeHandler: {
            [weak self] (view, change) in
            self?.isHidden = view.isHidden
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var style = ShadowStyle.black026 {
        didSet {
            resetShadow()
        }
    }
    
    private func resetShadow() {
        guard bounds != .zero else { return }
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: style.radius)
        shapeLayer.shadowColor = style.color
        shapeLayer.shadowRadius = style.radius
        shapeLayer.shadowOpacity = style.opacity
        shapeLayer.shadowOffset = style.offset
        shapeLayer.shadowPath = path.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetShadow()
    }
}
