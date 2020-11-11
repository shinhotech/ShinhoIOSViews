//
//  ViewController.swift
//  ShinhoIOSViews
//
//  Created by Yan Hu on 2020/11/2.
//

import UIKit

class ViewController: UIViewController {
    lazy private var selectorView: SelectorView = {
        let view = SelectorView(title: "司机")
        view.isRequired = true
        view.title2 = "其他司机"
        view.title1 = "大王"
        view.showBottomLine = true
        view.didSelected = {
            index in
            print(index)
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.addSubview(selectorView)
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(80)
            make.bottom.equalTo(-80)
            make.left.right.equalTo(view)
        }
        
        selectorView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon")
        contentView.addSubview(imageView)
        imageView.isAutoShowPreviews = true
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(selectorView.snp.bottom)
            make.width.height.equalTo(100)
            make.centerX.equalTo(contentView)
        }
        
        let starBar = AXStarBarExtension()
        starBar.titleText = "sadafas"
        starBar.isRequired = true
        contentView.addSubview(starBar)
        starBar.snp.makeConstraints { (make) in
            make.left.equalTo(margin3)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        
        let progressView = ProgressView()
        contentView.addSubview(progressView)
        progressView.progressWidth = 16
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(starBar.snp.bottom).offset(10)
            make.left.equalTo(margin4)
            make.right.equalTo(-margin4)
            make.height.equalTo(16)
        }
        
        let progressView1 = ProgressView()
        progressView1.style = .arc
        contentView.addSubview(progressView1)
        progressView1.snp.makeConstraints { (make) in
            make.top.equalTo(progressView.snp.bottom).offset(10)
            make.centerX.equalTo(contentView)
            make.height.width.equalTo(50)
        }
        
        progressView.percent = 0.5
        progressView1.percent = 0.6
    }

}

