//
//  CustomView.swift
//  Sqimey
//
//  Created by pallvi gupta on 27/06/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit


let firstColor = UIColor(red: 85/255, green: 24/255, blue: 93/255, alpha: 1)
let secondColor = UIColor(red: 255/255, green: 213/255, blue: 36/255, alpha: 1)



@IBDesignable
class CustomView2: UIView {
    
   
    @IBInspectable public var shadowColor: UIColor = UIColor.black {
        didSet {
            
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.5 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0, height: 3) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable public var shadowRadius : CGFloat = 3
        {
        didSet
        {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var masksToBounds : Bool = false
        {
        didSet
        {
            layer.masksToBounds = masksToBounds
        }
    }
    
    @IBInspectable public var clipsToBound : Bool = false
        {
        didSet
        {
            self.clipsToBounds = clipsToBound
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    
    override func layoutSubviews() {
           super.layoutSubviews()
        if isGradient == true
               {
                   gradientLayer.frame = self.bounds
                   gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
                   if isHorizontalGradient{
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
                    gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
                   }
                   self.layer.insertSublayer(gradientLayer, at: 0)
                   //            self.layer.addSublayer(gradientLayer)
               }
               else{
                   gradientLayer.removeFromSuperlayer()
               }
    }
  @IBInspectable public var isGradient : Bool = false{
      didSet{
          self.setNeedsDisplay()
      }
  }
  @IBInspectable public var isHorizontalGradient : Bool = true{
      didSet{
          self.setNeedsDisplay()
      }
  }
   @IBInspectable public var firstColor : UIColor = UIColor.orange{
         didSet{
             self.setNeedsDisplay()
         }
     }
     @IBInspectable public var secondColor : UIColor  = UIColor.yellow{
         didSet{
             self.setNeedsDisplay()
         }
     }
    @IBInspectable public var thirdColor : UIColor = UIColor.orange{
        didSet{
            self.setNeedsDisplay()
        }
    }
     
    
  lazy  var gradientLayer: CAGradientLayer = {
      return CAGradientLayer()
  }()
  
  override public init(frame: CGRect) {
      super.init(frame: frame)
      
  }
  required public init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
  }
  func set(gradientColors firstColor:UIColor , secondColor:UIColor, thirdColor:UIColor){
      self.firstColor = firstColor
      self.secondColor = secondColor
      self.thirdColor = thirdColor
      self.setNeedsLayout()
  }
    
}


@IBDesignable class ShadowView: UIView {
   
    @IBInspectable public var shadowColor: UIColor = UIColor.black {
        didSet {
            
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.5 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0, height: 3) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable public var shadowRadius : CGFloat = 3
        {
        didSet
        {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var masksToBounds : Bool = false
        {
        didSet
        {
            layer.masksToBounds = masksToBounds
        }
    }
    
    @IBInspectable public var clipsToBound : Bool = false
        {
        didSet
        {
            self.clipsToBounds = clipsToBound
        }
    }
    @IBInspectable public var isGradient : Bool = false{
         didSet{
             self.setNeedsDisplay()
         }
     }
     @IBInspectable public var isHorizontalGradient : Bool = true{
         didSet{
             self.setNeedsDisplay()
         }
     }
     @IBInspectable public var firstColor : UIColor = UIColor.orange{
         didSet{
             self.setNeedsDisplay()
         }
     }
     @IBInspectable public var secondColor : UIColor  = UIColor.yellow{
         didSet{
             self.setNeedsDisplay()
         }
     }
    @IBInspectable public var thirdColor : UIColor = UIColor.orange{
        didSet{
            self.setNeedsDisplay()
        }
    }
     lazy  var gradientLayer: CAGradientLayer = {
         return CAGradientLayer()
     }()
     
     
     func set(gradientColors firstColor:UIColor , secondColor:UIColor){
         self.firstColor = firstColor
         self.secondColor = secondColor
         self.setNeedsLayout()
     }
    
    
    
    @IBInspectable var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue / 2.0
        }
    }
    
    @IBInspectable var shadowSpread: CGFloat = 0 {
        didSet {
            if shadowSpread == 0 {
                layer.shadowPath = nil
            } else {
                let dx = -shadowSpread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
        }
    }
}
