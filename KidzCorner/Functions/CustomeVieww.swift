//
//  CustomeVieww.swift
//  KidzCorner
//
//  Created by Happy Guleria on 14/05/24.
//

import UIKit

class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        // You can set default properties here
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - Customization Methods
    
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setBorderWidth(_ width: CGFloat) {
        self.layer.borderWidth = width
    }
    
    func setBorderColor(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
}
