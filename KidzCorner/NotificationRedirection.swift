//
//  NotificationRedirection.swift
//  KidzCorner
//
//  Created by Happy Guleria on 14/07/24.
//

import UIKit
import Foundation

//MARK: - When user tap on notification
class NotificationRedirections{
    static let shared = NotificationRedirections()
    func fetchUserInfoData(data: [String: Any], type: String){
        let roleId = UserDefaults.standard.integer(forKey: myRoleId)
        if type != "receiveMessage" {
            let notifData = data["check_in_out"] as? [String:Any]
            if roleId == 4 {
                if notifData?["type"] as? String == "check_out" {
                    gotoHome()
                    UserDefaults.standard.set(2, forKey: checkInStatus)
                } else {
                    gotoHome()
                    UserDefaults.standard.set(1, forKey: checkInStatus)
                }
            }
        } else {
            let dataa = data["message"] as? [String:Any]
            let dataUser = data["student"] as? [String:Any]
            let thread = dataa?["thread_id"] as? Int ?? 0
            gotoChatVC(threadIDs: thread, profileImage: dataUser?["image"] as? String ?? "", name: dataUser?["name"] as? String ?? "", reciverID: data["student_id"] as? Int ?? 0)
        }
    }
    
    var rootController1: UIViewController?{
        if let window =  UIApplication.shared.windows.first(where: { $0.isKeyWindow}){
            return window.rootViewController
        }
        return UIViewController()
    }
    
}

func gotoHome() {
    let sb = UIStoryboard(name: "Parent", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "ParentTabbar") as! ParentTabbar
    UIApplication.shared.windows.first?.rootViewController = vc
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}

func gotoHomeTeacher() {
    let sb = UIStoryboard(name: "Teacher", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "TeacherTabbar") as! TeacherTabbar
    UIApplication.shared.windows.first?.rootViewController = vc
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}

func gotoChatVC(threadIDs: Int, profileImage: String,name: String,reciverID: Int) {
    let sb = UIStoryboard(name: "Parent", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "MessageListingVC") as! MessageListingVC
    UIApplication.shared.windows.first?.rootViewController = vc
    vc.comesFrom = "Notif"
    threadIDD = threadIDs
    userProfileImagee = profileImage
    userNamee = name
    id = reciverID
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}
