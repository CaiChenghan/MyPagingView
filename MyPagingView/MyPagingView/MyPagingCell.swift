//
//  MyPagingCell.swift
//  MyPagingView
//
//  Created by 蔡成汉 on 2019/5/9.
//  Copyright © 2019 蔡成汉. All rights reserved.
//

import UIKit

class MyPagingCell: UICollectionViewCell {
    
    var text: String? {
        didSet {
            if let _ = text {
                self.titleLab.text = text;
            }
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.6
        view.layer.borderColor = UIColor.green.cgColor
        return view
    }()
    
    lazy var titleLab: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 44)
        lable.layer.borderWidth = 0.6
        lable.layer.borderColor = UIColor.red.cgColor
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .lightGray
        initialView()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialView() {
        self.contentView.addSubview(bgView)
        self.contentView.addSubview(titleLab)
    }
    
    func makeConstraints() {
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLab.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
    }
}
