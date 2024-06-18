import UIKit
import RYCOMSDK
import IQKeyboardManagerSwift
import DropDown
//import Firebase
//import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? 
    var bluetooth : BabyBluetooth? = BabyBluetooth.share()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.white // Set to your desired color
        UITabBar.appearance().tintColor = UIColor.white // Color for the selected item
        
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        IQKeyboardManager.shared.enable = true
        DropDown.startListeningToKeyboard()
        SocketIOManager.sharedInstance.connectUser()
        bluetooth?.cancelAllPeripheralsConnection()
        RYBlueToothTool.sharedInstance().cancelScan()
        if (UserDefaults.standard.string(forKey: "BluetoothUUID") != nil){
            UserDefaults.standard.removeObject(forKey: "BluetoothUUID")
        }
        
        if UserDefaults.standard.bool(forKey: isLoggedIn) {
            
            let roleId = UserDefaults.standard.integer(forKey: myRoleId)
            
            printt("appDelegate role id \(roleId)")
            
            switch roleId {
            case 2:
                let sb = UIStoryboard(name: "Teacher", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "TeacherTabbar") as! TeacherTabbar
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            case 4:
                let sb = UIStoryboard(name: "Parent", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ParentTabbar") as! ParentTabbar
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            case 5:
                let sb = UIStoryboard(name: "Teacher", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "TeacherTabbar") as! TeacherTabbar
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            default:
                printt("Default Case")
            }
        }
        
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
       
//        UNUserNotificationCenter.current().delegate = self
//        let authOptions: UNAuthorizationOptions = [.alert, .sound,.badge]
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
//            if success {
//                UNUserNotificationCenter.current().getNotificationSettings { settings in
//                   print("Notification settings: \(settings)")
//                 }
//            }
//            if error != nil {
//                //we are ready to go
//            }
//        }
//        application.registerForRemoteNotifications()
//        
//        let notificationOption = launchOptions?[.remoteNotification]
//
//        // 1
//        if let notification = notificationOption as? [AnyHashable: Any] {
//            pushNotification(application, didReceiveRemoteNotification: notification)
//            UIPasteboard.general.string = "\(notification)"
//            if let topVC = UIApplication.shared.windows.first?.rootViewController{
//                let alert = UIAlertController(title: "Notification", message: "\(notification)", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                topVC.present(alert, animated: true)
//            }
//            handlePushNotification(response: notification)
//        }
        return true
    }
    
    
}

// MARK: -  Push Notification Delegates
extension AppDelegate: UNUserNotificationCenterDelegate {
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceToken = deviceToken.hexString
//        UserDefaults.standard.setValue(deviceToken, forKey: myDeviceToken)
//        print(deviceToken)
//    }
//    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register push notification")
//    }
    
    /*
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("My Device token \(String(describing: fcmToken))")
//        UserDefaults.standard.setValue(fcmToken, forKey: myDeviceToken)
    }
    */
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("Will gets called when app is in forground and we want to show banner")
//        
//        completionHandler([.alert, .sound, .badge])
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("Will gets called when user tap on notifictaion")
//        UIPasteboard.general.string = "\(response.notification.request.content.userInfo)"
//        let notification = response.notification.request.content.userInfo
//        handlePushNotification(response: notification)
//        completionHandler()
//    }
//    
//    func pushNotification(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        let notification = "\(userInfo)"
//        handlePushNotification(response: userInfo)
//    }
//    
//    func handlePushNotification(response: [AnyHashable : Any]) {
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) else {
//            return
//        }
//        
//        do {
//            let decoder = JSONDecoder()
//            let pushResponse = try decoder.decode(PayloadModel.self, from: jsonData)
//            
//            // Access the decoded properties
//            let data = pushResponse
//            
//            print("Data: \(data)")
//            guard let invoiceId = data.data?.id else { return }
//            let sb = UIStoryboard(name: "Parent", bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
//            vc.invoiceId = invoiceId
//            UIApplication.shared.windows.first?.rootViewController = vc
//            UIApplication.shared.windows.first?.makeKeyAndVisible()
//            
//        } catch {
//            // Handle decoding errors
//            print("Error decoding push response: \(error)")
//        }
//    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
