import UIKit
import YPImagePicker

class ParentTabbar: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
//        self.viewControllers?.remove(at: 3)
        self.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.addDotToTabBarItem(at: 0)
        }
            
        }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
      
        print(item.tag)
    
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let viewControllers = tabBarController.viewControllers else { return }
        
        for (index, vc) in viewControllers.enumerated() {
            if vc == viewController {
                // Add the dot to the selected tab
                addDotToTabBarItem(at: index)
                
                if let items = tabBarController.tabBar.items {
                        for (index, _) in items.enumerated() {
                            if index != selectedIndex {
                                removeDotFromTabBarItem(at: index)
                            }
                        }
                    }
                
            } else {
                // Remove the dot from other tabs
                removeDotFromTabBarItem(at: index)
            }
        }
    }
    
    func addDotToTabBarItem(at index: Int, color: UIColor = .red, diameter: CGFloat = 7) {
        let dotTag = 101
        guard let tabBarItems = self.tabBar.items, tabBarItems.count > index else { return }
        
        // Remove previous dots
            tabBar.subviews.forEach { view in
                view.viewWithTag(dotTag)?.removeFromSuperview()
            }
        
        let dotSize: CGFloat = 3.5
        let dotView = UIView(frame: CGRect(x: 0, y: 0, width: dotSize, height: dotSize))
            dotView.backgroundColor = .white
            dotView.layer.cornerRadius = dotSize / 2
            dotView.tag = dotTag
        // Obtain the frame of the tab bar item using the index
            guard let itemViews = tabBar.subviews.filter({ $0 is UIControl }) as? [UIControl] else { return }
            let sortedItemViews = itemViews.sorted(by: { $0.frame.minX < $1.frame.minX })
        if sortedItemViews.indices.contains(index) {
            let itemView = sortedItemViews[index]
            
            // Center the dot in the middle of the tab bar item
            let itemViewFrame = itemView.frame
            let dotX = itemViewFrame.midX - dotSize / 2
            let dotY = itemViewFrame.maxY - dotSize * 1.25 // Adjust the multiplier for the Y position as needed
            dotView.frame = CGRect(x: dotX, y: dotY, width: dotSize, height: dotSize)
            
            tabBar.addSubview(dotView)
        }
        
//        let itemView = tabBarItems[index].value(forKey: "view") as? UIView
//        let dot = UIView(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
//        dot.layer.cornerRadius = diameter / 2
//        dot.backgroundColor = color
//        dot.tag = 101 // An arbitrary tag to identify the dot later
//        
//        // Calculate the size and position of the dot based on the tab item's frame
//        let itemFrame = itemView?.frame ?? CGRect.zero
//        let dotX = itemFrame.midX + (itemFrame.width / 4) - (diameter / 2) - 25
//        let dotY = itemFrame.height - diameter + 5 // Adjust the Y position as needed
//        
//        dot.frame.origin = CGPoint(x: dotX, y: dotY)
//        
//        // Remove old dot if any before adding the new one
//        itemView?.subviews.forEach { if $0.tag == 101 { $0.removeFromSuperview() } }
//        
//        // Add the dot to the tab bar item's view
//        itemView?.addSubview(dot)
    }
    
    func removeDotFromTabBarItem(at index: Int) {
        guard let tabBarItems = self.tabBar.items,
              tabBarItems.count > index else { return }
        
        let itemView = tabBarItems[index].value(forKey: "view") as? UIView
        itemView?.subviews.forEach { if $0.tag == 101 { $0.removeFromSuperview() } }
    }
    
}
