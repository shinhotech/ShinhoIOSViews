//
//  SelectorView.swift
//  FSFA
//
//  Created by Yan Hu on 2020/3/19.
//  Copyright © 2020 shinho. All rights reserved.
//

import UIKit

class SelectorView: AXTitleContentView {
    lazy private var selectorView1: AXSelectorView = {
        let view = AXSelectorView()
        view.isSelected = true
        view.addTapGesture { [weak self] (_) in
            self?.select(0)
            self?.didSelected?(0)
            self?.isChanged = true
        }
        return view
    }()
    
    lazy private var selectorView2: AXSelectorView = {
        let view = AXSelectorView()
        view.addTapGesture { [weak self] (_) in
            self?.select(1)
            self?.didSelected?(1)
            self?.isChanged = true
        }
        return view
    }()
    
    var title1: String? {
        didSet {
            selectorView1.label.text = title1
        }
    }
    
    var title2: String? {
        didSet {
            selectorView2.label.text = title2
        }
    }
    
    var index = 0
    
    /// index = 0, 1, 第一控件，第二个控件
    var didSelected: ((_ index: Int) -> ())?
    
    /// index = 0, 1, 第一控件，第二个控件
    func select(_ index: Int) {
        self.index = index
        if index == 0 {
            selectorView1.isSelected = true
            selectorView2.isSelected = false
        } else {
            selectorView1.isSelected = false
            selectorView2.isSelected = true
        }
    }
    
    override init(title: String, isRequired: Bool = false) {
        super.init(title: title, isRequired: isRequired)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(selectorView1)
        contentView.addSubview(selectorView2)
        
        selectorView1.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(margin3)
        }
        
        selectorView2.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(contentView.snp.centerX)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(selectorView1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
