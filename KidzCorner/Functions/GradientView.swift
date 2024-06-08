import Foundation
import UIKit

//MARK:- GIVE A VIEW THIS CLASS AND GIVE COLORS TO MAKE GRADIENT

@IBDesignable
class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        if (self.isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
}

import UIKit

extension UIView {
    private struct AssociatedKeys {
        static var roundingCorners = "roundingCorners"
        static var roundingRadius = "roundingRadius"
    }

    var roundingCorners: UIRectCorner {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.roundingCorners) as? UIRectCorner ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.roundingCorners, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateCorners()
        }
    }

    var roundingRadius: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.roundingRadius) as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.roundingRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateCorners()
        }
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.roundingCorners = corners
        self.roundingRadius = radius
        updateCorners()
    }

    private func updateCorners() {
        guard roundingCorners != [] else { return }
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: roundingRadius, height: roundingRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    static let swizzleLayoutSubviewsImplementation: Void = {
        let originalSelector = #selector(layoutSubviews)
        let swizzledSelector = #selector(swizzled_layoutSubviews)
        guard let originalMethod = class_getInstanceMethod(UIView.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIView.self, swizzledSelector) else {
            return
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()

    @objc private func swizzled_layoutSubviews() {
        swizzled_layoutSubviews() // Call the original layoutSubviews method
        updateCorners()
    }
}
