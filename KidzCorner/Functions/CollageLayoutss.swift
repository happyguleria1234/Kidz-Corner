//
//  CollageLayoutss.swift
//  KidzCorner
//
//  Created by Happy Guleria on 29/07/24.
//

import Foundation
import UIKit

class CollageCollectionViewLayout: UICollectionViewLayout {
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let numberOfColumns = 2
        let cellPadding: CGFloat = 6
        let cellWidth = contentWidth / CGFloat(numberOfColumns)
        
        var xOffset: [CGFloat] = []
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * cellWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let cellHeight: CGFloat = (item % 3 == 0) ? cellWidth * 1.5 : cellWidth
            let height = cellPadding * 2 + cellHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
