//
//  MyPagingView.swift
//  MyPagingView
//
//  Created by 蔡成汉 on 2019/5/9.
//  Copyright © 2019 蔡成汉. All rights reserved.
//

import UIKit

class MyPagingView: UIView {

    // 原始数据源
    fileprivate var data: [String]?
    // 索引标记值
    fileprivate var index: NSInteger = 0
    // 索引数据源
    fileprivate var indexArray: [Int] = []
    // 数据重复次数
    var repeatCount: Int = 30 {
        didSet {
            setDataWithIndex(data: data, index: index)
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.1)
        collectionView.register(MyPagingCell.self, forCellWithReuseIdentifier: "MyPagingCell")
        return collectionView
    }()
    
    lazy var layout: MyPagingLayout = {
        let layout = MyPagingLayout()
        layout.itemWidth = UIScreen.main.bounds.size.width - 50.0
        layout.itemScale = 0.95
        return layout
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialView()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialView() {
        self.addSubview(collectionView)
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setDataWithIndex(data: [String]?, index: NSInteger) {
        guard let _ = data else { return }
        guard index >= 0 else {
            return
        }
        if !isSameData(data: data) {
            self.data = data
            self.index = index
            prepareIndexArray(dataArray: data)
            collectionView.reloadData()
            DispatchQueue.main.async {
                self.scrollToRollAtIndex(index: self.repeatCount/2*(data?.count ?? 0)+index)
            }
        }
    }
    
    // 索引数组准备
    func prepareIndexArray(dataArray: [Any]?) {
        guard let tpDataArray = dataArray else { return }
        guard index >= 0 else { return }
        var tpArray: [Int] = []
        for (index,_) in tpDataArray.enumerated() {
            tpArray.append(index)
        }
        indexArray.removeAll()
        for _ in 0..<repeatCount {
            indexArray = indexArray + tpArray
        }
    }
    
    // 滚动到指定位置
    func scrollToRollAtIndex(index:NSInteger) {
        guard index >= 0 else { return }
        let offset = CGFloat(index)*layout.itemWidth
        collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
    }
    
    // 是否为相同数据
    func isSameData(data: [String]?) -> Bool {
        // 数据控制，检测是否为相同数据，可通过转json字符串进行比较
        return false
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension MyPagingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPagingCell", for: indexPath) as! MyPagingCell
        let index = indexArray[indexPath.row]
        cell.text = data?[index]
        return cell
    }
}

extension MyPagingView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let point = self.convert(CGPoint(x: layout.itemWidth/2.0, y: collectionView.center.y), to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        let tpIndex = indexPath?.row ?? 0
        let targetIndex = tpIndex%(data?.count ?? 1)
        self.index = targetIndex
        scrollToRollAtIndex(index: repeatCount/2*(data?.count ?? 0) + index)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row%(data?.count ?? 1)
        print("点击"+String(index))
    }
}
