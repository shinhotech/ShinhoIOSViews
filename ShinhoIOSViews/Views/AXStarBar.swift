//
//  AXStarBar.swift
//  FSFA
//
//  Created by Lcm on 2018/2/7.
//  Copyright © 2018年 shinho. All rights reserved.
//  评价

import UIKit

class AXStarBar: UIView {
    /// 选中 star 个数
    var selectedStarCount: Int = 0 {
        didSet {
            guard oldValue != selectedStarCount else {
                return
            }
            selectStar(count: selectedStarCount)
        }
    }
    
    /// 选中事件
    var selectAction:((_ count:Int)->())?

    private var starList: [UIImageView] = []
    private var maxCount = 5

    private let normalStarImage = R.image.icon_star_normal()
    private let selectedStarImage = R.image.icon_star_selected()
    
    var isChanged = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var lastView: UIView?
        let midIndex = maxCount/2
        for i in 0 ..< maxCount {
            let star: UIImageView = {
                let imageView = UIImageView(image: normalStarImage)
                imageView.contentMode = .center
                return imageView
            }()
            addSubview(star)
            starList.append(star)
            star.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.size.equalTo(CGSize(width:24, height:24))
                if let lastView = lastView {
                    make.left.equalTo(lastView.snp.right).offset(16)
                }
                if i == midIndex {
                    if maxCount.isOdd {
                        make.centerX.equalTo(self)
                    } else {
                        make.left.equalTo(self.snp.centerX)
                    }
                }
            }
            
            lastView = star
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let point = touch.location(in: self)
        let endIndex = starList.firstIndex {
            $0.frame.minX > point.x
        } ?? maxCount
        selectedStarCount = endIndex
        isChanged = true
    }
    
    private func selectStar(count: Int) {
        guard (0...maxCount).contains(count) else {
            return
        }
        starList[0..<count].forEach { star in
            star.image = selectedStarImage
        }
        starList[count..<maxCount].forEach { star in
            star.image = normalStarImage
        }
        selectAction?(count)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
