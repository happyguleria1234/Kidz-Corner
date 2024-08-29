//
//  ShowHalfView.swift
//  KidzCorner
//
//  Created by Happy Guleria on 29/08/24.
//

import Foundation
import UIKit

class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2)
    }
}
