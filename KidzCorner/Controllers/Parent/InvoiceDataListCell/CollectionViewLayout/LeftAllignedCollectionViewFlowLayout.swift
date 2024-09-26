//
//  LeftAllignedCollectionViewFlowLayout.swift
//  KidzCorner
//
//  Created by Happy Guleria on 21/09/24.
//

import Foundation
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        for layoutAttribute in attributes {
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        
        return attributes
    }
}
