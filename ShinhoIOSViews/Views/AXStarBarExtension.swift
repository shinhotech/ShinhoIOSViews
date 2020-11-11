//
//  AXStarBarExtension.swift
//  FSFA
//
//  Created by Yan Hu on 2018/7/27.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit
import RxSwift

class AXStarBarExtension: UIView {
    private var titleLabel: UILabel!
    private var starBar: AXStarBar!
    private var infoLabel: UILabel!
    // starBar right information
    var infos: [String] = ["非常差", "差", "一般", "好", "非常好"] {
        didSet {
            assert(infos.count < 5, "infos' count must be equal or greater than 5")
        }
    }
    
    /// title
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    /// 必填项
    var isRequired = false {
        didSet {
            if isRequired {
                titleLabel?.addRequired()
            } else {
                titleLabel?.removeRequired()
            }
        }
    }
    /// info 是否隐藏
    var infoIsHidden = false {
        didSet {
            infoLabel?.isHidden = infoIsHidden
        }
    }
    /// count 改变订阅事件
    let countSubject = PublishSubject<Int>.init()
    /// 选中个数
    var count: Int = 0 {
        didSet {
            countSubject.onNext(count)
            starBar?.selectedStarCount = count
            switch count {
            case 0:
                infoLabel?.text = ""
                break
            case 1:
                infoLabel?.text = infos[0]
                break
            case 2:
                infoLabel?.text = infos[1]
                break
            case 3:
                infoLabel?.text = infos[2]
                break
            case 4:
                infoLabel?.text = infos[3]
                break
            case 5:
                infoLabel?.text = infos[4]
                break
            default:
                infoLabel?.text = ""
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        titleLabel = UILabel().ax.textColor(.black38).font(.pfscRegular(12)).value
        starBar = AXStarBar()
        starBar.selectAction = {
            [weak self] c in
            self?.count = c
        }
        infoLabel = UILabel().ax.textColor(.orangeef).isHidden(infoIsHidden).font(.pfscRegular(14)).value
        
        addSubview(titleLabel)
        addSubview(starBar)
        addSubview(infoLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(self)
            make.height.equalTo(16)
        }
        
        starBar.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.height.equalTo(24)
            make.width.equalTo(40 * 5 - 16)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(starBar.snp.right).offset(margin2)
            make.centerY.equalTo(starBar)
            make.right.equalTo(self)
            make.height.equalTo(18)
        }
        
        snp.makeConstraints { (make) in
            make.height.equalTo(55)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
