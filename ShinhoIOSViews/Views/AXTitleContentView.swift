//
//  AXTitleContentView.swift
//  FSFA
//
//  Created by Yan Hu on 2020/3/12.
//  Copyright © 2020 shinho. All rights reserved.
//

import UIKit
import RxSwift

class AXTitleContentView: UIView {
    enum TitleType {
        case font12
        case font16
        case noTitle
    }
    
    enum Permission {
        case allowEdit
        case history
    }
    
    var titleType = TitleType.font12 {
        didSet {
            guard oldValue != titleType else { return }
            sectionLabel.heightConstraint?.deactivate()
            sectionLabel.topConstraint?.deactivate()
            sectionLabel.removeRequired()
            sectionLabel.isHidden = false
            contentView.topConstraint?.deactivate()
            
            switch titleType {
            case .font12:
                sectionLabel.font = .pfscRegular(12)
                sectionLabel.snp.makeConstraints { make in
                    sectionLabel.topConstraint = make.top.equalTo(margin3).constraint
                    sectionLabel.heightConstraint = make.height.equalTo(sectionLabel.font.height).constraint
                }
                
                contentView.snp.makeConstraints { (make) in
                    contentView.topConstraint = make.top.equalTo(sectionLabel.snp.bottom).offset(margin1).constraint
                }
                sectionLabel.textColor = .black38
            case .font16:
                sectionLabel.font = .pfscMedium(16)
                sectionLabel.snp.makeConstraints { make in
                    sectionLabel.topConstraint = make.top.equalTo(0).constraint
                    sectionLabel.heightConstraint = make.height.equalTo(66).constraint
                }
                
                contentView.snp.makeConstraints { (make) in
                    contentView.topConstraint = make.top.equalTo(sectionLabel.snp.bottom).constraint
                }
                
                sectionLabel.textColor = .black
            case .noTitle:
                sectionLabel.isHidden = true
                contentView.snp.makeConstraints { (make) in
                    contentView.topConstraint = make.top.equalTo(margin3).constraint
                }
            }
            
            if isRequired {
                isRequired = true
            }
        }
    }
    
    var title: String? {
        didSet {
            sectionLabel.text = title
            if isRequired {
                setRequired()
            }
        }
    }
    
    /// 当用户执行了操作, 这个控件要赋值为 true
    var isChanged = false
    
    /// 必填项
    var isRequired: Bool = false {
        didSet {
            setRequired()
        }
    }
    
    /// 访问权限
    var permission: Permission = .allowEdit {
        didSet {
            switch permission {
            case .allowEdit:
                blankMask?.isHidden = true
                contentView.isUserInteractionEnabled = true
            case .history:
                contentView.isUserInteractionEnabled = false
                blankMask?.isHidden = false
            }
        }
    }
    
    /// 显示隐藏最下面的分割线
    var showBottomLine = false {
        didSet {
            lineView.isHidden = !showBottomLine
        }
    }
    /// 下班部分的 padding
    var bottomOffset = margin3 {
        didSet {
            bottomConstraint?.update(offset: bottomOffset)
        }
    }
    
    /// 设置为必填项
    func setRequired() {
        sectionLabel.removeRequired()
        if isRequired {
          sectionLabel.addRequired()
        }
    }
    
    private var sectionLabel = UILabel().ax.textColor(.black38).font(.pfscRegular(12)).value
    private(set) var contentView = UIView()
    
    private var lineView = UIView().ax.isHidden(true).backgroundColor(UIColor.black.withAlphaComponent(0.06)).value
    
    override convenience init(frame: CGRect) {
        self.init(title: "", isRequired: false)
    }
    
    init(title: String, isRequired: Bool = false) {
        self.title = title
        self.isRequired = isRequired
        super.init(frame: .zero)
        
        sectionLabel.text = title
        if isRequired {
            sectionLabel.addRequired()
        }
        
        addSubview(sectionLabel)
        addSubview(contentView)
        addSubview(lineView)
        sectionLabel.snp.makeConstraints { make in
            sectionLabel.topConstraint = make.top.equalTo(margin3).constraint
            make.left.equalTo(leftMargin)
            sectionLabel.heightConstraint = make.height.equalTo(sectionLabel.font.height).constraint
        }
        
        contentView.snp.makeConstraints { (make) in
            contentView.topConstraint = make.top.equalTo(sectionLabel.snp.bottom).offset(margin1).constraint
            make.left.right.equalTo(self)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(margin3)
            make.right.equalTo(-margin3)
            make.bottom.equalTo(self)
            make.height.equalTo(1)
        }
        
        snp.makeConstraints { make in
            bottomConstraint = make.bottom.equalTo(contentView).offset(bottomOffset).constraint
        }
        addBlankMask()
        blankMask?.isUserInteractionEnabled = false
        blankMask?.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
