//
//  CollageItem.swift
//  CollageView
//
//  Created by AHMET KAZIM GUNAY on 21/07/2017.
//  Copyright © 2017 Ahmet Kazım Gunay. All rights reserved.
//

import UIKit

public class CollageItem {
    public var borderWidth: CGFloat
    public var borderColor: UIColor
    public var contentMode: UIView.ContentMode
    public var rowIndex: (x: Int, y: Int)
    public var indexForImageArray: Int // Ensure this property has both getter and setter

    public init(borderWidth: CGFloat, borderColor: UIColor, contentMode: UIView.ContentMode, rowIndex: (x: Int, y: Int), indexForImageArray: Int) {
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.contentMode = contentMode
        self.rowIndex = rowIndex
        self.indexForImageArray = indexForImageArray
    }
}

