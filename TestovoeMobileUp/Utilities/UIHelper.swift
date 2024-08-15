//
//  UIHelper.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 10.08.2024.
//

import UIKit

struct UIHelper {
    static func createOneRectangleColumnLayout(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.itemSize = CGSize(width: width, height: UIScreen.main.bounds.size.width * 0.55 /*235*/) // 200
        flowLayout.minimumLineSpacing = 4
        
        
        return flowLayout
    }
    
    
    static func createTwoSquareColumnLayout(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let availableWidth = width - 4
        let itemWidth = availableWidth / 2
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        
        return flowLayout
    }
}
