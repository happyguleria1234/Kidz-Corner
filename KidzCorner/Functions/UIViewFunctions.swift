import UIKit


extension UIView {
    
    func defaultShadow() {
//        self.giveShadowAndRoundCorners(shadowOffset: CGSize.zero, shadowRadius: 10, opacity: 0.2, shadowColor: .black, cornerRadius: 20)
        self.giveShadowAndRoundCorners(shadowOffset: CGSize.zero, shadowRadius: 3, opacity: 0.2, shadowColor: .black, cornerRadius: 20)
    }
    
    func shadowWithRadius(radius: CGFloat) {
        self.giveShadowAndRoundCorners(shadowOffset: CGSize.zero, shadowRadius: 5, opacity: 0.1, shadowColor: .black, cornerRadius: radius)
    }
    
    func giveShadowAndRoundCorners(shadowOffset: CGSize , shadowRadius : Int , opacity : Float , shadowColor : UIColor , cornerRadius :
    CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        DispatchQueue.main.async {
            self.layer.shadowPath =  UIBezierPath(roundedRect: self.bounds,cornerRadius: self.layer.cornerRadius).cgPath
        }
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.layer.shadowOffset = shadowOffset
        self.layer.masksToBounds = false
    }
    //USAGE:- someView.giveShadowAndRoundCorners(shadowOffset: CGSize.zero, shadowRadius: 12, opacity: 0.8, shadowColor: Some_color, cornerRadius: 10)
    
}

func setDownTriangle(triangleView: UIView){
        let heightWidth = triangleView.frame.size.width
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth, y:0))
        path.addLine(to: CGPoint(x:0, y:0))

        let shape = CAShapeLayer()
        shape.path = path
    shape.fillColor = UIColor(named: "gradientBottom")?.cgColor
        triangleView.layer.insertSublayer(shape, at: 0)
    }


//extension UIViewController {
//    
//    //MARK:- REMOVE CHILD
//    func removeChild() {
//        self.childViewControllers.forEach {
//            $0.willMove(toParentViewController: nil)
//            $0.view.removeFromSuperview()
//            $0.removeFromParentViewController()
//        }
//    }
//    //USAGE : self.removeChild()
//    
//    //MARK:- ADDING CHILD TO CONTAINER
//    
//    func addChildView(viewControllerToAdd: UIViewController, in view: UIView) {
//        viewControllerToAdd.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        viewControllerToAdd.view.frame = view.bounds
//        addChildViewController(viewControllerToAdd)
//        view.addSubview(viewControllerToAdd.view)
//        viewControllerToAdd.didMove(toParentViewController: self)
//    }
//    //USAGE: self.addChildView(viewControllerToAdd: your_vc_object, in: containerView)
//    
//}
//
//
//class ViewEmbedder {
//
//class func embed(
//    parent:UIViewController,
//    container:UIView,
//    child:UIViewController,
//    previous:UIViewController?){
//
//    if let previous = previous {
//        removeFromParent(vc: previous)
//    }
//        child.willMove(toParentViewController: parent)
//        parent.addChildViewController(child)
//    container.addSubview(child.view)
//        child.didMove(toParentViewController: parent)
//    let w = container.frame.size.width;
//    let h = container.frame.size.height;
//    child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
//}
//
//class func removeFromParent(vc:UIViewController){
//    vc.willMove(toParentViewController: nil)
//    vc.view.removeFromSuperview()
//    vc.removeFromParentViewController()
//}
//
//class func embed(withIdentifier id:String, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
//    let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
//    embed(
//        parent: parent,
//        container: container,
//        child: vc,
//        previous: parent.childViewControllers.first
//    )
//    completion?(vc)
//}
//
//}
