
import UIKit
import YPImagePicker

class ParentTabbar: UITabBarController, UITabBarControllerDelegate {
    
    var allChatData: ChatInboxModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBarCorners()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTabBarCornerMask()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // This method can be used for additional logging or actions.
        print(item.tag)
    }
    
    func getChatRoomData(onSuccess: @escaping(()->())) {
        ApiManager.shared.Request(type: ChatInboxModel.self, methodType: .Get, url: baseUrl + chatRoom, parameter: [:]) { error, resp, msgString, statusCode in
            guard error == nil,
                  let userlist = resp?.data?.data,
                  statusCode == 200 else {
                return
            }
            self.allChatData = resp
            onSuccess()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let viewControllers = tabBarController.viewControllers,
              let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else { return }
        
        // Check if the selected tab item has tag 1
        if selectedIndex == 1 {
            getChatRoomData {
                if self.allChatData?.chat == false {
                    DispatchQueue.main.async {
                        AlertManager.shared.showAlert(title: "Chat Alert", message: "Message Unavailable.", viewController: self)
                        // Prevent the selection
                        tabBarController.selectedIndex = 0 // or any other index you want to fallback to
                    }
                    return
                }
            }
        }
    }
    
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
