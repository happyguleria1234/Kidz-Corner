
import UIKit
import YPImagePicker

class TeacherTabbar: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.addDotToTabBarItem(at: 0)
//        }
        
        setupTabBarCorners()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTabBarCornerMask()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.tag)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let viewControllers = tabBarController.viewControllers else { return }
        
//        for (index, vc) in viewControllers.enumerated() {
//            if vc == viewController {
//                addDotToTabBarItem(at: index)
//                
//                if let items = tabBarController.tabBar.items {
//                    for (index, _) in items.enumerated() {
//                        if index != selectedIndex {
//                            removeDotFromTabBarItem(at: index)
//                        }
//                    }
//                }
//            } else {
//                removeDotFromTabBarItem(at: index)
//            }
//        }
    }
    
//    func addDotToTabBarItem(at index: Int, color: UIColor = .red, diameter: CGFloat = 7) {
//        let dotTag = 101
//        guard let tabBarItems = self.tabBar.items, tabBarItems.count > index else { return }
//        
//        tabBar.subviews.forEach { view in
//            view.viewWithTag(dotTag)?.removeFromSuperview()
//        }
//        
//        let dotSize: CGFloat = 3.5
//        let dotView = UIView(frame: CGRect(x: 0, y: 0, width: dotSize, height: dotSize))
//        dotView.backgroundColor = .white
//        dotView.layer.cornerRadius = dotSize / 2
//        dotView.tag = dotTag
//        
//        guard let itemViews = tabBar.subviews.filter({ $0 is UIControl }) as? [UIControl] else { return }
//        let sortedItemViews = itemViews.sorted(by: { $0.frame.minX < $1.frame.minX })
//        if sortedItemViews.indices.contains(index) {
//            let itemView = sortedItemViews[index]
//            let itemViewFrame = itemView.frame
//            let dotX = itemViewFrame.midX - dotSize / 2
//            let dotY = itemViewFrame.maxY - dotSize * 1.25
//            dotView.frame = CGRect(x: dotX, y: dotY, width: dotSize, height: dotSize)
//            
//            tabBar.addSubview(dotView)
//        }
//    }
    
//    func removeDotFromTabBarItem(at index: Int) {
//        guard let tabBarItems = self.tabBar.items,
//              tabBarItems.count > index else { return }
//        
//        let itemView = tabBarItems[index].value(forKey: "view") as? UIView
//        itemView?.subviews.forEach { if ($0.tag == 101) { $0.removeFromSuperview() } }
//    }
    
    private func setupTabBarCorners() {
        updateTabBarCornerMask()
    }
    
    private func updateTabBarCornerMask() {
        let radius: CGFloat = 30
        let maskPath = UIBezierPath(roundedRect: tabBar.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        tabBar.layer.mask = maskLayer
    }
}
