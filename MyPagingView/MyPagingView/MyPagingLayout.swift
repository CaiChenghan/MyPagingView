//
//  MyPagingLayout.swift
//  MyPagingView
//
//  Created by 蔡成汉 on 2019/5/9.
//  Copyright © 2019 蔡成汉. All rights reserved.
//

import UIKit

class MyPagingLayout: UICollectionViewLayout {
    
    var itemCount: Int = 0
    var itemWidth: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }
    fileprivate var itemSize: CGSize = .zero
    var itemScale: CGFloat = 1 {
        didSet {
            invalidateLayout()
        }
    }
    var itemSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }
    var itemFixy: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }
    var itemAlpha: CGFloat = 0.7 {
        didSet {
            invalidateLayout()
        }
    }
    
    override func prepare() {
        super.prepare()
        itemCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        itemSize = CGSize(width: CGFloat(itemWidth), height: self.collectionView?.bounds.size.height ?? 0)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        let size = CGSize(width: CGFloat(itemCount)*CGFloat(itemWidth), height: 100)
        return size
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: itemSize.width*CGFloat(indexPath.row), y: 0, width: itemSize.width, height: itemSize.height)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
#if TestOne
        return testOnelayoutAttributesForElements(in: rect)
#elseif TestTwo
        return testTwolayoutAttributesForElements(in: rect)
#elseif TestThree
        return testThreelayoutAttributesForElements(in: rect)
#elseif TestFour
        return testFourlayoutAttributesForElements(in: rect)
#elseif TestFive
        return testFivelayoutAttributesForElements(in: rect)
#else
        return pagingViewlayoutAttributesForElements(in: rect)
#endif
        
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
#if DEBUG
        // 获取指定区域内的布局元素
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: self.collectionView?.bounds.size.width ?? 0, height: self.collectionView?.bounds.size.height ?? 0)
        guard let attributes = self.layoutAttributesForElements(in: targetRect) else { return proposedContentOffset }
        
        // 设置中心点
        let centerX = proposedContentOffset.x + itemWidth/2.0
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        // 寻找中心点最近的元素位置偏移
        for item in attributes {
            if abs(item.center.x - centerX) < abs(offsetAdjustment) {
                offsetAdjustment = item.center.x - centerX
            }
        }
        // 设置停靠点
        let offset = CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
        return offset
#else
        return proposedContentOffset
#endif
    }
    
    // 缩放
    func testOnelayoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            if let attribute = self.layoutAttributesForItem(at: indexPath as IndexPath) {
                attributes.append(attribute)
            }
        }
        // 样式设置：数据计算
        // 设置中心点：视图左边界向右半个元素宽度即为中心点
        let currentCenterX: CGFloat = CGFloat(self.collectionView?.contentOffset.x ?? 0.0) + itemSize.width/2.0
        for item in attributes {
            // 当前元素距离中心点的距离
            let distance: CGFloat = item.center.x - currentCenterX
            // 缩放
            let scale: CGFloat = min(1, max((itemScale - 1)/itemWidth*distance + 1, 0))
            let scaleTransform = CATransform3DMakeScale(scale, scale, 1.0)
            item.transform3D = scaleTransform
        }
        return attributes
    }
    
    // 缩放+偏移
    func testTwolayoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            if let attribute = self.layoutAttributesForItem(at: indexPath as IndexPath) {
                attributes.append(attribute)
            }
        }
        // 样式设置：数据计算
        // 设置中心点：视图左边界向右半个元素宽度即为中心点
        let currentCenterX: CGFloat = CGFloat(self.collectionView?.contentOffset.x ?? 0.0) + itemSize.width/2.0
        for item in attributes {
            // 当前元素距离中心点的距离
            let distance: CGFloat = item.center.x - currentCenterX
            // 缩放
            let scale: CGFloat = min(1, max((itemScale - 1)/itemWidth*distance + 1, 0))
            // 位置偏移修正
            let offsetX: CGFloat = distance
            let scaleTransform = CATransform3DMakeScale(scale, scale, 1.0)
            let translationTransform = CATransform3DMakeTranslation(-offsetX, 0, 0)
            let transform = CATransform3DConcat(scaleTransform, translationTransform)
            item.transform3D = transform
        }
        return attributes
    }
    
    // 缩放+偏移+层级
    func testThreelayoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            if let attribute = self.layoutAttributesForItem(at: indexPath as IndexPath) {
                attributes.append(attribute)
            }
        }
        // 样式设置：数据计算
        // 设置中心点：视图左边界向右半个元素宽度即为中心点
        let currentCenterX: CGFloat = CGFloat(self.collectionView?.contentOffset.x ?? 0.0) + itemSize.width/2.0
        for item in attributes {
            // 当前元素距离中心点的距离
            let distance: CGFloat = item.center.x - currentCenterX
            // 缩放
            let scale: CGFloat = min(1, max((itemScale - 1)/itemWidth*distance + 1, 0))
            // 位置偏移修正
            let fix = itemWidth*0.5*(1-scale)
            let offsetX: CGFloat = distance - fix
            // z轴层级
            let zIndex = max(100-distance/itemWidth, 0)
            
            // 缩放与平移合并
            item.zIndex = Int(zIndex)
            let scaleTransform = CATransform3DMakeScale(scale, scale, 1.0)
            let translationTransform = CATransform3DMakeTranslation(-offsetX, 0, 0)
            let transform = CATransform3DConcat(scaleTransform, translationTransform)
            item.transform3D = transform
        }
        return attributes
    }
    
    // 缩放+偏移+层级+偏移修复
    func testFourlayoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            if let attribute = self.layoutAttributesForItem(at: indexPath as IndexPath) {
                attributes.append(attribute)
            }
        }
        // 样式设置：数据计算
        // 设置中心点：视图左边界向右半个元素宽度即为中心点
        let currentCenterX: CGFloat = CGFloat(self.collectionView?.contentOffset.x ?? 0.0) + itemSize.width/2.0
        for item in attributes {
            // 当前元素距离中心点的距离
            let distance: CGFloat = item.center.x - currentCenterX
            // 缩放
            let scale: CGFloat = min(1, max((itemScale - 1)/itemWidth*distance + 1, 0))
            // 位置偏移修正
            let fix = itemWidth*0.5*(1-scale) + itemSpacing*(distance/itemWidth)
            let offsetX: CGFloat = distance - fix
            // z轴层级
            let zIndex = max(100-distance/itemWidth, 0)
            
            // 缩放与平移合并
            item.zIndex = Int(zIndex)
            let scaleTransform = CATransform3DMakeScale(scale, scale, 1.0)
            let translationTransform = CATransform3DMakeTranslation(-offsetX, 0, 0)
            let transform = CATransform3DConcat(scaleTransform, translationTransform)
            item.transform3D = transform
        }
        return attributes
    }
    
    // 缩放+偏移+层级+偏移修复+透明度
    func testFivelayoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            if let attribute = self.layoutAttributesForItem(at: indexPath as IndexPath) {
                attributes.append(attribute)
            }
        }
        // 样式设置：数据计算
        // 设置中心点：视图左边界向右半个元素宽度即为中心点
        let currentCenterX: CGFloat = CGFloat(self.collectionView?.contentOffset.x ?? 0.0) + itemSize.width/2.0
        for item in attributes {
            // 当前元素距离中心点的距离
            let distance: CGFloat = item.center.x - currentCenterX
            // 缩放
            let scale: CGFloat = min(1, max((itemScale - 1)/itemWidth*distance + 1, 0))
            // 位置偏移修正
            let fix = itemWidth*0.5*(1-scale) + itemSpacing*(distance/itemWidth)
            let offsetX: CGFloat = distance - fix
            // z轴层级
            let zIndex = max(100-distance/itemWidth, 0)
            // 透明度
            let alpha = min(1, max((itemAlpha-1)/itemWidth*distance + 1, itemAlpha))
            // 缩放与平移合并
            item.zIndex = Int(zIndex)
            item.alpha = alpha
            let scaleTransform = CATransform3DMakeScale(scale, scale, 1.0)
            let translationTransform = CATransform3DMakeTranslation(-offsetX, 0, 0)
            let transform = CATransform3DConcat(scaleTransform, translationTransform)
            item.transform3D = transform
        }
        return attributes
    }
    
    // 最终效果
    func pagingViewlayoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            if let attribute = self.layoutAttributesForItem(at: indexPath as IndexPath) {
                attributes.append(attribute)
            }
        }
        // 样式设置：数据计算
        // 设置中心点：视图左边界向右半个元素宽度即为中心点
        let currentCenterX: CGFloat = CGFloat(self.collectionView?.contentOffset.x ?? 0.0) + itemSize.width/2.0
        for item in attributes {
            // 当前元素距离中心点的距离
            let distance: CGFloat = item.center.x - currentCenterX
            // 缩放
            let scale: CGFloat = min(1, max((itemScale - 1)/itemWidth*distance + 1, 0))
            // 位置偏移修正
            let fix = itemWidth*0.5*(1-scale) + itemSpacing*(distance/itemWidth)
            var offsetX: CGFloat = 0
            var offsetY: CGFloat = 0
            if distance >= 0 && distance <= 6*itemWidth {
                offsetX = distance - fix
                offsetY = itemFixy/itemWidth*distance
            }
            // 透明度
            let alpha = min(1, max((itemAlpha-1)/itemWidth*distance + 1, itemAlpha))
            // z轴层级
            let zIndex = max(100-distance/itemWidth, 0)
            
            // 缩放与平移合并
            item.zIndex = Int(zIndex)
            item.alpha = alpha
            let scaleTransform = CATransform3DMakeScale(scale, scale, 1.0)
            let translationTransform = CATransform3DMakeTranslation(-offsetX, -offsetY, 0)
            let transform = CATransform3DConcat(scaleTransform, translationTransform)
            item.transform3D = transform
        }
        return attributes
    }
}
