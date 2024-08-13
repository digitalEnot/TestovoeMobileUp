//
//  UIHelper.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 10.08.2024.
//

import UIKit

struct UIHelper {
    // TODO: Сделать padding как на макетее
    static func createOneRectangleColumnLayout(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        flowLayout.itemSize = CGSize(width: width, height: 230)
        
        return flowLayout
    }
    
    // TODO: Сделать padding как на макетее
    static func createTwoSquareColumnLayout(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 0
        let minimumItemSpacing: CGFloat = 6
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return flowLayout
    }
}
