//
//  ViewController.swift
//  MyPagingView
//
//  Created by 蔡成汉 on 2019/5/9.
//  Copyright © 2019 蔡成汉. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    lazy var pagingView: MyPagingView = {
        let view = MyPagingView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialView()
        makeConstraints()
        pagingView.setDataWithIndex(data: ["零","壹","贰"], index: 0)
        
    }

    func initialView() {
        self.view.addSubview(pagingView)
    }
    
    func makeConstraints() {
        pagingView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(300)
        }
    }
}

