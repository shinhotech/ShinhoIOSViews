//
//  PhotoPreviewController.swift
//  FSFA
//
//  Created by Yan Hu on 2018/5/8.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit
import Kingfisher

/// 动态配置方案
protocol PhotoPreviewControllerDataSource: class {
    func photoPreviewCount() -> Int
    func photoPreviewResource(at index: Int) -> (resource: Any?, placeholder: UIImage?)
    func photoPreviewTransitionFrame(with currentIndex: Int) -> CGRect
}

class PhotoPreviewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private var collectionView: UICollectionView!
    private var label: UILabel!
    var photos: [Any?] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    /// if set dataSource, photos will be invalid
    weak var dataSource: PhotoPreviewControllerDataSource?
    var image: UIImage?
    var index = 0 {
        didSet {
            resetIndex()
        }
    }
    
    var indexChanged: ((_ index: Int) -> ())?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func resetIndex() {
        collectionView?.selectItem(at: IndexPath.init(row: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        if let dataSource = dataSource {
            label?.text = "\(index + 1) / \(dataSource.photoPreviewCount())"
        } else {
            label?.text = "\(index + 1) / \(photos.count)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView.init(frame: CGRect.init(x:0, y: 0, width: view.width + 15, height: view.height), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(PhotoPreviewCell.self, forCellWithReuseIdentifier: "photo_preview_cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        
        label = UILabel().ax.textAlignment(.center).font(.pfscLight(16)).textColor(.white).value
        label.frame = CGRect.init(x: 0, y: 44, width: view.width, height: 20)
        view.addSubview(label)
        
        // 初始化显示
        resetIndex()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo_preview_cell", for: indexPath) as! PhotoPreviewCell
        if let dataSource = dataSource {
            cell.photo = dataSource.photoPreviewResource(at: indexPath.row)
        } else {
            cell.photo = (photos[indexPath.row], nil)
        }
        cell.dismiss = {
            [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.photoPreviewCount()
        }
        return photos.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let tmpIndex = Int(round(scrollView.contentOffset.x / (view.width + 15)))
        if index != tmpIndex {
            index = tmpIndex
            image = (collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) as? PhotoPreviewCell)?.preview.image
            indexChanged?(index)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class PhotoPreviewCell: UICollectionViewCell {
    private(set) var preview = PhotoPreview()
    var photo: (resource: Any?, placeholder: UIImage?) {
        didSet {
            preview.placeholder = photo.placeholder
            preview.resource = photo.resource
        }
    }
    
    var dismiss: (() -> ())? {
        didSet {
            preview.dismiss = dismiss
        }
    }
    
    var image: UIImage? {
        didSet {
            preview.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(preview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        preview.frame = CGRect.init(x: 0, y: 0, width: contentView.width - 15, height: contentView.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhotoPreview: UIView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    private var scrollView = UIScrollView()
    private var imageView = UIImageView()
    private var loadingView = UIActivityIndicatorView.init(style: .white)
    private var isZoomedIn = false
    private var currentMultiple: CGFloat = 1.0
    private var maxMultiple: CGFloat = 2 {
        didSet {
            scrollView.maximumZoomScale = maxMultiple
        }
    }
    private var pinchCenter = CGPoint.zero
    private var scrollViewOffset = CGPoint.zero
    var image: UIImage? {
        didSet {
            if let img = image {
                let multiple = img.size.width / img.size.height
                if multiple > 2 {
                    maxMultiple = multiple
                } else {
                    maxMultiple = 2
                }
            }
            imageView.image = image
        }
    }
    
    var placeholder: UIImage?
    var resource: Any? {
        didSet {
            scrollView.setZoomScale(1, animated: true)
            resetImage(image: placeholder)
            if let image = resource as? UIImage {
                resetImage(image: image)
            } else if let urlString = resource as? String {
                if urlString.isUrlString {
                    loadingView.startAnimating()
                    imageView.kf.setImage(with: URL.init(string: urlString), completionHandler:  {
                        [weak self] (result) in
                        self?.loadingView.stopAnimating()
                        switch result {
                        case .success(let result):
                            self?.image = result.image
                        case .failure(_): break
                        }
                    })
                } else if fileExistsAtPath(path: urlString) {
                    if let url = URL.init(string: urlString) {
                        resetImage(image: UIImage(contentsOfFile: url.path))
                    }
                } else  {
                    #if SFADEBUG
                        print(#file , #function, #line, "图片资源不可用", urlString )
                    #endif
                    resetImage(image: nil)
                }
            } else {
                resetImage(image: nil)
            }
        }
    }
    
    var tapAction: ((_ tap: UITapGestureRecognizer) -> ())?
    var dismiss: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
//        imageView.canSave2Album()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = maxMultiple
        scrollView.bouncesZoom = true
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        addSubview(scrollView)
        imageView.addSubview(loadingView)
        addTap()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingView.center = center
        scrollView.frame = bounds
    }
    
    private func resetImage(image: UIImage?) {
        self.image = image
        if let image = image {
            let scaleX = image.size.width / screenWidth
            let size = CGSize.init(width: screenWidth, height: image.size.height / scaleX)
            if image.size.height / scaleX > screenHeight {
                imageView.frame = CGRect.init(origin: .zero, size: size)
                scrollView.contentSize = size
            } else {
                imageView.frame = CGRect.init(origin: .zero, size: CGSize.init(width: screenWidth, height: screenHeight))
                scrollView.contentSize = CGSize.init(width: screenWidth, height: screenHeight)
            }
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        currentMultiple = scale
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func addTap() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        imageView.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
    }
    
    @objc private func tapAction(tap: UITapGestureRecognizer) {
        scrollViewOffset = CGPoint.zero
        if tap.numberOfTapsRequired == 1 {
            dismiss?()
        } else if tap.numberOfTapsRequired == 2 {
            if maxMultiple != 1 {
                let point = tap.location(in: self)
                if isZoomedIn && currentMultiple > 1 {
                    isZoomedIn = false
                    scrollView.setZoomScale(1, animated: true)
                } else {
                    isZoomedIn = true
                    scrollView.zoom(to: CGRect.init(origin: CGPoint.init(x: point.x  - size.width / (maxMultiple * 2),
                                                                         y: point.y - size.height / (maxMultiple * 2)),
                                                    size: CGSize.init(width: size.width / maxMultiple,
                                                                      height: size.height / maxMultiple)), animated: true)
                }
            }
        }
        tapAction?(tap)
    }
    
    private func fileExistsAtPath(path: String?) -> Bool {
        if let url = URL.init(string: path ?? "") {
            let fileManager = FileManager.default
            return fileManager.fileExists(atPath: url.path)
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
