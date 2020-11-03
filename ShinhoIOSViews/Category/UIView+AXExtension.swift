//
//  UIView+AXExtension.swift
//  FSFA
//
//  Created by Lcm on 2018/2/5.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit
import SnapKit
import Closures
import AXKit

extension UIView {
    
    func verticalLayout(subviews: [UIView],
                        heights: [CGFloat] = [],
                        topInsets: [CGFloat],
                        leftMargin: CGFloat = 0,
                        rightMargin: CGFloat = 0,
                        referencedView: UIView? = nil) {
        guard !subviews.isEmpty, subviews.count == topInsets.count else { return }
        
        var lastViewOpt: UIView?
        for (i, view) in subviews.enumerated() {
            addSubview(view)
            
            view.snp.makeConstraints { make in
                make.left.equalTo(leftMargin)
                make.right.equalTo(-rightMargin)
                if subviews.count == heights.count && heights[i] > 0 {
                    view.heightConstraint = make.height.equalTo(heights[i]).constraint
                }
                if let lastView = lastViewOpt {
                    view.topConstraint = make.top.equalTo(lastView.snp.bottom).offset(topInsets[i]).constraint
                } else {
                    if let reference = referencedView, reference != self {
                        view.topConstraint = make.top.equalTo(reference.snp.bottom).offset(topInsets[0]).constraint
                    } else {
                        view.topConstraint = make.top.equalTo(topInsets[0]).constraint
                    }
                }
            }
            lastViewOpt = view
        }
    }
    
    private struct AssociatedKey {
        static let centerYConstraintKey = UnsafeRawPointer(bitPattern: "centerYConstraintKey".hashValue)!
        static let centerXConstraintKey = UnsafeRawPointer(bitPattern: "centerXConstraintKey".hashValue)!
        static let widthConstraintKey = UnsafeRawPointer(bitPattern: "widthConstraintKey".hashValue)!
        static let heightConstraintKey = UnsafeRawPointer(bitPattern: "heightConstraintKey".hashValue)!
        static let bottomConstraintKey = UnsafeRawPointer(bitPattern: "bottomConstraintKey".hashValue)!
        static let topConstraintKey = UnsafeRawPointer(bitPattern: "topConstraintKey".hashValue)!
        static let leftConstraintKey = UnsafeRawPointer(bitPattern: "leftConstraintKey".hashValue)!
        static let rightConstraintKey = UnsafeRawPointer(bitPattern: "rightConstraintKey".hashValue)!
        static let blankMaskKey = UnsafeRawPointer(bitPattern: "blankMaskKey".hashValue)!
    }
    
    public var heightConstraint: Constraint?  {
        set {
            objc_setAssociatedObject(self, AssociatedKey.heightConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, AssociatedKey.heightConstraintKey) as?
            Constraint        }
    }
    
    public var widthConstraint: Constraint?  {
        set {
            objc_setAssociatedObject(self, AssociatedKey.widthConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, AssociatedKey.widthConstraintKey) as?
            Constraint        }
    }
    
    public var topConstraint: Constraint?  {
        set {
            objc_setAssociatedObject(self, AssociatedKey.topConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, AssociatedKey.topConstraintKey) as?
            Constraint        }
    }
    
    public var centerXConstraint: Constraint?  {
        set {
            objc_setAssociatedObject(self, AssociatedKey.centerXConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, AssociatedKey.centerXConstraintKey) as?
            Constraint        }
    }
    
    public var centerYConstraint: Constraint?  {
        set {
            objc_setAssociatedObject(self, AssociatedKey.centerYConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, AssociatedKey.centerYConstraintKey) as?
            Constraint        }
    }
    
    public var leftConstraint: Constraint?  {
        set {
            objc_setAssociatedObject(self, AssociatedKey.leftConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, AssociatedKey.leftConstraintKey) as?
            Constraint        }
    }
    
    
    
    public var bottomConstraint: Constraint?  {
        set {
            objc_setAssociatedObject(self, AssociatedKey.bottomConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, AssociatedKey.bottomConstraintKey) as?
            Constraint        }
    }
    
    public var rightConstraint: Constraint?  {
        set {
            objc_setAssociatedObject(self, AssociatedKey.rightConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, AssociatedKey.rightConstraintKey) as?
            Constraint        }
    }
    
    
    func enumSubview(_ closure: @escaping (UIView) -> Bool) {
        let action = {
            for subview in self.subviews {
                if closure(subview) { return }
            }
            for subview in self.subviews {
                if !subview.subviews.isEmpty {
                    subview.enumSubview(closure)
                }
            }
        }
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                action()
            }
        } else {
            action()
        }
        
    }
}

extension UIView {
    var blankMask: BlankView? {
        set {
            objc_setAssociatedObject(self, AssociatedKey.blankMaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, AssociatedKey.blankMaskKey) as? BlankView
        }
    }
    
    func addBlankMask(title: String? = nil,
                      titleView: UIView? = nil,
                      bottomView: UIView? = nil,
                      color: UIColor = .white70,
                      reload: (()->())? = nil) {
        if blankMask == nil {
            blankMask = BlankView().ax.backgroundColor(color).value
        }
        addSubview(blankMask!)
        blankMask?.snp.makeConstraints({ (make) in
            if titleView != nil || bottomView != nil {
                make.left.right.equalTo(self)
                if let title = titleView {
                    make.top.equalTo(title.snp.bottom)
                } else {
                    make.top.equalTo(self)
                }
                if let bottom = bottomView {
                    make.bottom.equalTo(bottom.snp.top)
                } else {
                    make.bottom.equalTo(self)
                }
            } else {
                make.edges.equalTo(self)
            }
        })
        blankMask?.title = title
        blankMask?.addTapGesture { (tap) in
            if let ac = reload {
                ac()
            }
        }
    }
    
    func removeBlackMask() {
        blankMask?.removeFromSuperview()
        blankMask = nil
    }
}

class BlankView: UIView {
    private var titleLabel: UILabel!
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel().ax.textAlignment(.center).textColor(.black38).font(.pfscRegular(16)).value
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
