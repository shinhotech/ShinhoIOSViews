//
//  AXSelectorView.swift
//  FSFA
//
//  Created by Yan Hu on 2019/1/7.
//  Copyright © 2019 shinho. All rights reserved.
//

import UIKit
import SwifterSwift

class AXSelectorView: UIView {
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                redView.backgroundColor = .redf0
                redView.borderWidth = 0
            } else {
                redView.backgroundColor = .white
                redView.borderWidth = 1
            }
        }
    }
    
    private(set) var redView = UIView().ax.hitTestInsets(.init(inset: 20)).cornerRadius(10).borderColor(.black10).borderWidth(1).value
    private var whiteView = UIView().ax.cornerRadius(4).backgroundColor(.white).value
    private(set) var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        addSubview(redView)
        addSubview(whiteView)
        addSubview(label)
        
        redView.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.left.top.equalTo(self)
        }
        
        whiteView.snp.makeConstraints { (make) in
            make.center.equalTo(redView)
            make.width.height.equalTo(8)
        }
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(redView.snp.right).offset(12)
            make.centerY.equalTo(redView)
        }
        
        snp.makeConstraints { (make) in
            make.height.equalTo(redView)
            make.right.equalTo(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
