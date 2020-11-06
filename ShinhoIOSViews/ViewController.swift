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
    }

}

