//
//  ProgressView.swift
//  POPSwiftTest
//
//  Created by Yan Hu on 2018/7/11.
//  Copyright © 2018年 yan. All rights reserved.
//

import UIKit

class ProgressView: UIView, CAAnimationDelegate {
    enum ProgressViewStyle {
        case arc // 环形进度条
        case line // 线性进度条
    }
    var percent: Float = 0 {
        didSet {
            resetPath()
        }
    }
    
    var style = ProgressViewStyle.line // 默认线性进度
    
    private var shape: CAShapeLayer!
    private var backgroundLayer: CAShapeLayer!
    private var gradient: CAGradientLayer!
    /// 动画结束事件
    var animationStopped: (() -> ())?
    /// 动画重复次数
    var repeatCount: Float = 1
    /// 是否反向的
    var autoreverses: Bool = false
    /// 进度条宽度
    var progressWidth: CGFloat = 6.0 {
        didSet {
            shape?.lineWidth = progressWidth
            backgroundLayer?.lineWidth = progressWidth
            let per = percent
            percent = per
        }
    }
    
    /// 进度条颜色
    var progressColors: [CGColor] = [UIColor.init(red: 245 / 255.0, green: 132 / 255.0, blue: 31 / 255.0, alpha: 1).cgColor,
                             UIColor.init(red: 237 / 255.0, green: 28 / 255.0, blue: 36 / 255.0, alpha: 1).cgColor] {
        didSet {
            gradient.colors = progressColors
        }
    }
    /// 预览的颜色
    var placeholderColor: UIColor = UIColor.init(red: 250 / 255.0, green: 250 / 255.0, blue: 250 / 255.0, alpha: 1) {
        didSet {
            backgroundLayer?.strokeColor = placeholderColor.cgColor
        }
    }
    /// 是否显示预览
    var showPlaceholder: Bool = true {
        didSet {
            backgroundLayer?.isHidden = !showPlaceholder
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    private func resetPath() {
        shape?.path = path(with: percent)
        backgroundLayer?.path = path(with: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetPath()
    }
    
    private func path(with percent: Float) -> CGPath {
        gradient?.frame = bounds
        var path = UIBezierPath.init()
        switch style {
        case .line:
            if percent != 0 {
                let radius = progressWidth / 2
                let cy = bounds.height / 2
                let offset = (bounds.width - radius * 2) * percent.cgFloat
                path.move(to: CGPoint.init(x: radius, y: cy))
                path.addLine(to: CGPoint.init(x: radius + offset, y: cy))
            }
            gradient.startPoint = CGPoint.init(x: 0, y: 0.5)
            gradient.endPoint = CGPoint.init(x: 1, y: 0.5)
            break
        case .arc:
            let bestWidth = bounds.width > bounds.height ? bounds.height : bounds.width
            let radius = bestWidth / 2
            let center = CGPoint.init(x: bounds.width / 2, y: bounds.height / 2)
            path = UIBezierPath.init(arcCenter: center,
                                     radius: radius - (shape!.lineWidth / 2.0),
                                     startAngle: -0.5 * CGFloat.pi,
                                     endAngle: CGFloat((2 * percent)) * CGFloat.pi - 0.5 * CGFloat.pi,
                                     clockwise: true)
            gradient.startPoint = CGPoint.init(x: 0.65, y: 0)
            gradient.endPoint = CGPoint.init(x: 0.25, y: 1)
            break
        }
        return path.cgPath
    }
    
    private func setupLayer() {
        gradient = CAGradientLayer.init()
        gradient.colors = progressColors
        gradient.locations = [NSNumber.init(value: 0), NSNumber.init(value: 1)]
        
        shape = CAShapeLayer.init()
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        shape.lineWidth = progressWidth
        shape.lineCap = CAShapeLayerLineCap.round
        gradient.mask = shape
        
        backgroundLayer = CAShapeLayer.init()
        backgroundLayer.fillColor = nil
        backgroundLayer.strokeColor = placeholderColor.cgColor
        backgroundLayer.lineWidth = progressWidth
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradient)
    }
    
    func startAnimation(duration: CFTimeInterval = 2, fromValue: Any? = 0, toValue: Any? = 1) {
        var anim: CABasicAnimation? = nil
        if let animation = shape.animation(forKey: "run") as? CABasicAnimation {
            anim = animation
        } else {
            anim = CABasicAnimation.init(keyPath: "strokeEnd")
        }
        
        if let temp = anim {
            shape.removeAllAnimations()
            temp.duration = duration
            temp.fromValue = fromValue
            temp.toValue = toValue
            temp.delegate = self
            temp.autoreverses = autoreverses
            temp.repeatCount = repeatCount
            shape.add(temp, forKey: "run")
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animationStopped?()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
