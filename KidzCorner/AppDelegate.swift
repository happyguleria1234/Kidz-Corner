import UIKit
import RYCOMSDK
import IQKeyboardManagerSwift
import DropDown
import Firebase
import FirebaseMessaging

var loggedUSer = String()

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

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
                loggedUSer = "Teacher"
                let sb = UIStoryboard(name: "Teacher", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "TeacherTabbar") as! TeacherTabbar
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            case 4:
                loggedUSer = "User"
                let sb = UIStoryboard(name: "Parent", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ParentTabbar") as! ParentTabbar
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            case 5:
                loggedUSer = "Teacher"
                let sb = UIStoryboard(name: "Teacher", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "TeacherTabbar") as! TeacherTabbar
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            default:
                printt("Default Case")
            }
        }
        registerForPushNotifications()
        return true
    }
    
    func registerForPushNotifications() {
         UIApplication.shared.applicationIconBadgeNumber = 0
         UNUserNotificationCenter.current().removeAllDeliveredNotifications()
         UNUserNotificationCenter.current().delegate = self
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
             print("Permission granted: \(granted)")
             guard granted else { return }
             DispatchQueue.main.async {
                 UIApplication.shared.registerForRemoteNotifications()
                 FirebaseApp.configure()
                 Messaging.messaging().delegate = self
                 Messaging.messaging().isAutoInitEnabled = true
             }
         }
     }
}

// MARK: -  Push Notification Delegates

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToke = deviceToken.hexString
        UserDefaults.standard.setValue(deviceToke, forKey: myDeviceToken)
        Messaging.messaging().apnsToken = deviceToken
        print(deviceToken,"token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register push notification")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Will gets called when app is in forground and we want to show banner")
        let userInfofData = notification.request.content.userInfo["payload"] as? [String: Any] ?? [:]
//        if userInfofData["type"] as? String != "receiveMessage" {
//            NotificationRedirections.shared.fetchUserInfoData(data: userInfofData, type: userInfofData["type"] as? String ?? "")
//        }
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Will gets called when user tap on notifictaion")
        UIPasteboard.general.string = "\(response.notification.request.content.userInfo)"
        let notification = response.notification.request.content.userInfo
        var userInfofData = [String: Any]()
        var typee = String()
        if notification["type"] as? String == "receiveMessage" {
            typee = notification["type"] as? String ?? ""
            userInfofData = response.notification.request.content.userInfo["lastMessage"] as? [String: Any] ?? [:]
        } else{
            userInfofData = response.notification.request.content.userInfo["payload"] as? [String: Any] ?? [:]
            typee = "\(userInfofData["message_type"] as? Int ?? 0)"
        }
        NotificationRedirections.shared.fetchUserInfoData(data: userInfofData,type: typee)
//        handlePushNotification(response: notification)
        completionHandler()
    }
    
    func handlePushNotification(response: [AnyHashable : Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let pushResponse = try decoder.decode(PayloadModel.self, from: jsonData)
            // Access the decoded properties
            let data = pushResponse
            print("Data: \(data)")
            guard let invoiceId = data.data?.id else { return }
            let sb = UIStoryboard(name: "Parent", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
            vc.invoiceId = invoiceId
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        } catch {
            // Handle decoding errors
            print("Error decoding push response: \(error)")
        }
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
