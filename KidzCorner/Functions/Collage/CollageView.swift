//
//  CollageView.swift
//  CollageView
//
//  Created by AHMET KAZIM GUNAY on 21/07/2017.
//  Copyright © 2017 Ahmet Kazım Gunay. All rights reserved.
//

import UIKit

@objc public enum CollageViewLayoutDirection: NSInteger {
    case vertical, horizontal
}

@objc public protocol CollageViewDelegate: NSObjectProtocol {
    @objc optional func collageView(_ collageView: CollageView, didSelect itemView: CollageItemView, at index: Int)
}

@objc public protocol CollageViewDataSource: NSObjectProtocol {
    func collageViewNumberOfRowOrColoumn(_ collageView: CollageView) -> Int
    func collageViewNumberOfTotalItem(_ collageView: CollageView) -> Int
    func collageViewLayoutDirection(_ collageView: CollageView) -> CollageViewLayoutDirection
    func collageView(_ collageView: CollageView, configure itemView: CollageItemView, at index: Int)
}

@objc open class CollageView: UIView {
    public typealias rowIndex = (x: Int, y: Int)

    open private(set) var imageViews = [CollageItemView]()
    open var layoutDirection: CollageViewLayoutDirection = .vertical
    open private(set) var rowOrColoumnCount: Int = 0
    open private(set) var itemCount = 0
    
    @objc weak open var delegate: CollageViewDelegate?
    @objc weak open var dataSource: CollageViewDataSource? {
        didSet {
            setup()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    fileprivate func addImageViews() {
        for i in 0..<itemCount {
            let itemView = createImageView(i)
            self.dataSource?.collageView(self, configure: itemView, at: i)
            addTapGesture(to: itemView)
            addPanGesture(to: itemView)
            imageViews.append(itemView)
            self.addSubview(itemView)
        }
    }
    
    public func reload() {
        clearAll()
        setup()
    }
    
    private func setup() {
        guard let dataSource = dataSource else { return }
        
        itemCount = dataSource.collageViewNumberOfTotalItem(self)
        layoutDirection = dataSource.collageViewLayoutDirection(self)
        rowOrColoumnCount = dataSource.collageViewNumberOfRowOrColoumn(self)
        
        assert(itemCount >= rowOrColoumnCount, "Image count cannot be more than row count")
        
        addImageViews()
    }
    
    public func clearAll() {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        itemCount = 0
        layoutDirection = .vertical
        rowOrColoumnCount = 0
    }
    
    fileprivate func addTapGesture(to itemView: CollageItemView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        itemView.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        guard let itemView = sender.view as? CollageItemView, let item = itemView.collageItem else { return }
        self.delegate?.collageView?(self, didSelect: itemView, at: item.indexForImageArray)
    }
    
    fileprivate func addPanGesture(to itemView: CollageItemView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        itemView.addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let itemView = sender.view as? CollageItemView else { return }
        
        switch sender.state {
        case .began:
            itemView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            bringSubviewToFront(itemView)
        case .changed:
            let translation = sender.translation(in: self)
            itemView.center = CGPoint(x: itemView.center.x + translation.x, y: itemView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self)
        case .ended:
            itemView.transform = CGAffineTransform.identity
            let destinationItemView = findDestinationItemView(for: itemView)
            guard let sourceIndex = imageViews.firstIndex(of: itemView), let destinationIndex = imageViews.firstIndex(of: destinationItemView) else { return }
            imageViews.remove(at: sourceIndex)
            imageViews.insert(itemView, at: destinationIndex)
            updateImagePositions() // Update image positions after the drag and drop
        default:
            break
        }
    }
    
    fileprivate func updateImagePositions() {
        for (index, itemView) in imageViews.enumerated() {
            // Update the rowIndex of each CollageItem based on its new position
            let rowIndex = rowIndexForItem(at: index)
            itemView.collageItem?.rowIndex = rowIndex
            itemView.collageItem?.indexForImageArray = index
        }
    }
    
    fileprivate func findDestinationItemView(for itemView: CollageItemView) -> CollageItemView {
        var closestItemView: CollageItemView = imageViews.first!
        var smallestDistance = CGFloat.greatestFiniteMagnitude
        
        for otherItemView in imageViews where otherItemView != itemView {
            let distance = itemView.center.distance(to: otherItemView.center)
            if distance < smallestDistance {
                smallestDistance = distance
                closestItemView = otherItemView
            }
        }
        
        return closestItemView
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        for imageView in imageViews where rowOrColoumnCount != 0 {
            guard let collageItem = imageView.collageItem else { return }
            imageView.frame = frameAtIndex(rowIndex: collageItem.rowIndex)
        }
    }
    
    // Save the positions of the images
    private func saveImagePositions() {
        for (index, itemView) in imageViews.enumerated() {
            // Update the indexForImageArray property to match the current position
            itemView.collageItem?.indexForImageArray = index
        }
    }
}

extension CollageView {
    fileprivate func createImageView(_ index: Int) -> CollageItemView {
        let rowIndex = rowIndexForItem(at: index)
        let item = CollageItem(borderWidth: 1, borderColor: .white, contentMode: .scaleAspectFill, rowIndex: rowIndex, indexForImageArray: index)
        return CollageItemView(collageItem: item)
    }
    
    private func rowIndexForItem(at index: Int) -> rowIndex {
        var returnRowIndex = (0, 0)
        
        if rowOrColoumnCount == 0 {
            return returnRowIndex
        }
        
        switch self.layoutDirection {
        case .horizontal:
            returnRowIndex = (index % rowOrColoumnCount, Int(index / rowOrColoumnCount))
        case .vertical:
            returnRowIndex = (Int(index / rowOrColoumnCount), index % rowOrColoumnCount)
        }
        
        return returnRowIndex
    }
    
    public func frameAtIndex(rowIndex: rowIndex) -> CGRect {
        let mode = modeValue(for: itemCount)
        let fullyDivided = isFullyDivided(forMode: mode)
        let quotient = quotientValue(for: itemCount)
        
        var widthDivider: CGFloat = 0
        var heightDivider: CGFloat = 0
        
        switch layoutDirection {
        case .horizontal:
            let isRemainingRow = rowIndex.y == quotient
            widthDivider = !isRemainingRow ? CGFloat(rowOrColoumnCount) : CGFloat(mode)
            heightDivider = fullyDivided ? CGFloat(quotient) : CGFloat(quotient + 1)
        case .vertical:
            let isRemainingRow = rowIndex.x == quotient
            widthDivider = fullyDivided ? CGFloat(quotient) : CGFloat(quotient + 1)
            heightDivider = !isRemainingRow ? CGFloat(rowOrColoumnCount) : CGFloat(mode)
        }
        
        let width = self.frame.size.width / widthDivider
        let height = self.frame.size.height / heightDivider
        let xOrigin = CGFloat(rowIndex.x) * width
        let yOrigin = CGFloat(rowIndex.y) * height
        
        return CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
    }
    
    private func modeValue(for itemCount: Int) -> Int {
        return itemCount % rowOrColoumnCount
    }
    
    private func isFullyDivided(forMode: Int) -> Bool {
        return forMode == 0
    }
    
    private func quotientValue(for itemCount: Int) -> Int {
        return itemCount / rowOrColoumnCount
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = point.x - self.x
        let dy = point.y - self.y
        return sqrt(dx * dx + dy * dy)
    }
}

