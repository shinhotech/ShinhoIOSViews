//
//  PhotoTransitionViewController.swift
//  FSFA
//
//  Created by Yan Hu on 2018/5/9.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

private var previewImageViewUrlKey: Void?
private var previewIsAutoShowKey: Void?
private var hideNotPermittedKey: Void?
private var showPreviewPermittedKey: Void?

extension UIImageView {
    
    /// 检索图片, 如果 UIImageView 有 url, 则使用 url, 否则使用 UIImageView 的 image
    var url: String? {
        set {
            objc_setAssociatedObject(self, &previewImageViewUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &previewImageViewUrlKey) as? String
        }
    }
    
    /// 配合图片检索, 如果 父视图 的 hideNotPermitted 为 true, 只有 showPreviewPermitted 的子 UIImageView 可以显示
    var showPreviewPermitted: Bool? {
        set {
            objc_setAssociatedObject(self, &showPreviewPermittedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &showPreviewPermittedKey) as? Bool
        }
    }
    
    
    /// 预览自己
    ///
    /// - Parameter completion: 动画结束回调
    func showPreview(completion: (() -> ())? = nil) {
        let vc = PhotoTransitionViewController(preview: image)
        vc.photos = [image]
        vc.fromFrames = [rectInWindow]
        parentViewController?.present(vc, animated: true, completion: completion)
    }
}

extension UIView {
    
    /// 如果 hideNotPermitted 为 true, UIImageView showPreviewPermitted 必须为 true才可以显示, 如果为 false, 所有都可以显示
    var hideNotPermitted: Bool? {
        set {
            objc_setAssociatedObject(self, &hideNotPermittedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &hideNotPermittedKey) as? Bool
        }
    }
    
    /// 在当前 view 上加一个点击, 并且自动检索所有图片 auto set isUserInteractionEnabled = true
    var isAutoShowPreviews: Bool? {
        set {
            var tap: UITapGestureRecognizer!
            if isAutoShowPreviews == nil {
                tap = UITapGestureRecognizer.init {
                    [weak self] (tap) in
                    if let window = UIApplication.shared.keyWindow,
                        let this = self {
                        this.showAllImages(touchPoint: this.convert(tap.location(in: this), to: window))
                    }
                }
                addGestureRecognizer(tap)
            }
            
            objc_setAssociatedObject(self, &previewIsAutoShowKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
            tap?.isEnabled = (isAutoShowPreviews == true)
            if isAutoShowPreviews == true {
                isUserInteractionEnabled = true
            }
        }
        get {
            return objc_getAssociatedObject(self, &previewIsAutoShowKey) as? Bool
        }
    }
    
    
    /// 视图在 window 中的位置
    var rectInWindow: CGRect {
        if let window = UIApplication.shared.keyWindow {
            return self.superview?.convert(self.frame, to: window) ?? .zero
        }
        return .zero
    }
    
    
    /// 检索当前页面所有 imageView
    /// 如果未检索到, 不显示
    /// - Parameter touchPoint: 点击位置, 第一个在点击范围的图片为 预览图
    func showAllImages(touchPoint: CGPoint = .zero) {
        var images = [Any]()
        var frames = [CGRect]()
        var currentImage = UIImage()
        var index = 0
        var foundIndex = false
        var imageContentMode = UIView.ContentMode.scaleAspectFill
        
        /// 添加图片进入预览数组
        ///
        /// - Parameter imageView: imageView
        func handleImageView(imageView: UIImageView) {
            if (imageView.image?.size.width ?? 0) == 0 ||
                (imageView.image?.size.height ?? 0) == 0 {
                return
            }
            let rect = imageView.rectInWindow
            if !foundIndex && rect.contains(touchPoint) {
                currentImage = imageView.image ?? UIImage()
                imageContentMode = imageView.contentMode
                foundIndex = true
            } else {
                if !foundIndex {
                    if index == 0 {
                        currentImage = imageView.image ?? UIImage()
                        imageContentMode = imageView.contentMode
                    }
                    index += 1
                }
            }
            
            frames.append(rect)
            if let url = imageView.url {
                images.append(url)
            } else {
                images.append(imageView.image ?? UIImage())
            }
        }
        
        
        /// 判断 UIImageView 是否加入预览
        ///
        /// - Parameters:
        ///   - superView: 父视图
        ///   - sub: 子视图
        func adjustPermission(superView: UIView, sub: UIView) {
            // 父视图只允许有权限的, 则所有子视图都遵循父视图
            if superView.hideNotPermitted == true {
                sub.hideNotPermitted = true
            }
            
            if let imageView = sub as? UIImageView {
                if superView.hideNotPermitted == true {
                    if imageView.showPreviewPermitted == true {
                        handleImageView(imageView: imageView)
                    }
                } else {
                    handleImageView(imageView: imageView)
                }
            }
        }
        
        
        /// 遍历入口
        ///
        /// - Parameter view: 起始视图
        func findImages(view: UIView) {
            for sub in view.subviews {
                if sub.isHidden {
                    continue
                }
                adjustPermission(superView: view, sub: sub)
                findImages(view: sub)
            }
        }
        
        if let superView = self.superview {
            adjustPermission(superView: superView, sub: self)
        }
        findImages(view: self)
        
        if index > images.count {
            index = 0
        }
        
        if images.count > 0, index < images.count {
            images[index] = currentImage
            let vc = PhotoTransitionViewController(preview: currentImage)
            vc.photos = images
            vc.fromFrames = frames
            vc.index = index
            vc.imageContentMode = imageContentMode
            parentViewController?.present(vc, animated: true, completion: {
                
            })
        }
    }
}


class PhotoTransitionViewController: UIViewController, UIViewControllerTransitioningDelegate {
    /// 图片位置 present 和 dismiss, 不设置默认 alpha 1 -> 0
    var fromFrames: [CGRect]?
    /// 跳转预览图
    var imageContentMode: UIView.ContentMode = .scaleAspectFill
    /// 多个数据处理
    var photos: [Any?] = [] {
        didSet {
            reload()
        }
    }
    
    var index = 0 {
        didSet {
            child?.index = index
        }
    }
    
    weak var previewDataSource: PhotoPreviewControllerDataSource? {
        didSet {
            child.dataSource = previewDataSource
        }
    }
    
    private var child: PhotoPreviewController!
    private var previewImage: UIImage?
    init(preview: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        previewImage = preview
        child = PhotoPreviewController()
        addChild(child)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    func reload() {
        child?.photos = photos.count > 0 ? photos : [previewImage ?? UIImage()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addTapGesture {
            [weak self] (tap) in
            self?.dismiss(animated: true, completion: nil)
        }
        
        view.backgroundColor = .black
        view.addSubview(child.view)
        child.view.frame = view.bounds
        child.index = index
        child.indexChanged = {
            [unowned self] index in
            self.index = index
            self.previewImage = self.child.image
        }
        reload()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = AXPresentationController.init(presentedViewController: presented, presenting: presenting)
        return presentation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatorWithType(type: .dismiss)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatorWithType(type: .present)
    }
    
    private func animatorWithType(type: PhotoTransitionAnimationType) -> PhotoTransitionAnimator {
        let animator = PhotoTransitionAnimator()
        animator.duration = 0.3
        animator.animationType = type
        animator.fromImage = previewImage
        if let dataSource = child.dataSource {
            animator.fromFrame = dataSource.photoPreviewTransitionFrame(with: index)
        } else {
            if (fromFrames?.count ?? 0) > index {
                animator.fromFrame = fromFrames![index]
            } else {
                animator.fromFrame = .zero
            }
        }
        animator.imageContentMode = imageContentMode
        return animator
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum PhotoTransitionAnimationType {
    case
    present,
    dismiss
}

class PhotoTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval = 0.1
    var animationType = PhotoTransitionAnimationType.present
    var fromImage: UIImage?
    var fromFrame: CGRect = CGRect.zero
    var imageContentMode: UIView.ContentMode!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    /// 根据图片尺寸, 调整frame, 保证图片居中, width固定, height 动态变化
    func adjustFrame(rect: CGRect, scaleSize: CGSize) -> CGRect {
        if scaleSize.width == 0 ||
            scaleSize.height == 0 {
            return rect
        }
        let scale = scaleSize.height / scaleSize.width
        let adjustHeight = (rect.width * scale - rect.size.height) / 2.0
        return CGRect.init(x: rect.origin.x, y: rect.origin.y - adjustHeight, width: rect.width, height: rect.width * scale)
    }
    
    /// 判断图片是否在视图中
    func judgFrameIn(frame: CGRect) -> Bool {
        if frame == .zero {
            return false
        }
        let screenFrame = UIScreen.main.bounds
        return screenFrame.intersects(frame)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        let imageView = UIImageView()
        let background = UIView()
        background.alpha = 0
        
        var fromFrame = self.fromFrame
        var finalFrame = UIScreen.main.bounds
        finalFrame = adjustFrame(rect: finalFrame, scaleSize: fromImage?.size ?? CGSize.zero)
        
        if animationType == .dismiss {
            fromFrame = finalFrame
            finalFrame = self.fromFrame
            background.alpha = 1
        } else {
            toVC?.view.isHidden = true
        }
        
        imageView.contentMode = imageContentMode
        if judgFrameIn(frame: fromFrame) {
            imageView.frame = fromFrame
        } else {
            imageView.frame = finalFrame
        }
        
        imageView.image = fromImage
        imageView.clipsToBounds = true
        background.frame = UIScreen.main.bounds
        background.backgroundColor = .black
        
        containerView.addSubview(toVC!.view)
        containerView.addSubview(background)
        containerView.addSubview(imageView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            background.alpha = self.animationType == .dismiss ? 0 : 1
            if self.animationType == .dismiss {
                if self.judgFrameIn(frame: finalFrame) {
                    imageView.frame = finalFrame
                } else {
                    imageView.alpha = 0
                }
            } else {
                imageView.frame = finalFrame
            }
        }) { (finished) in
            if finished {
                imageView.removeFromSuperview()
                background.removeFromSuperview()
                toVC?.view.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

class AXPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        get {
            return true
        }
    }
}
