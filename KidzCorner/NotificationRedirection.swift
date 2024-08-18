//
//  NotificationRedirection.swift
//  KidzCorner
//
//  Created by Happy Guleria on 14/07/24.
//

import UIKit
import Foundation

var apiCall: (()->())?

//MARK: - When user tap on notification
class NotificationRedirections{
    static let shared = NotificationRedirections()
    func fetchUserInfoData(data: [String: Any], type: String){
        let roleId = UserDefaults.standard.integer(forKey: myRoleId)
        if type == "2" {
            if roleId == 4 {
                gotoParentAnnouncement()
            } else {
                gotoTeacherAnnouncement()
            }
        } else if type == "5" {
            if roleId == 4 {
                gotoInvoice()
            }
        } else if type == "4" {
            if roleId == 4 {
                gotoHome()
            } else {
                gotoHomeTeacher()
            }
        } else if type == "6"{
            if roleId == 4 {
                let ids = (data["receiver_id"] as? String ?? "")
                guard let idss = Int(ids) else {return}
                print(idss)
                gotoRattings(userIDss: idss)
            }
        } else if type == "1" {
            
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

func gotoRattings(userIDss: Int) {
    let sb = UIStoryboard(name: "Parent", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "DemoVC") as! DemoVC
    UIApplication.shared.windows.first?.rootViewController = vc
    vc.comesFrom = 1
    vc.userID = userIDss
    apiCall?()
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}

func gotoInvoice() {
    let sb = UIStoryboard(name: "Parent", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "Payments") as! Payments
    UIApplication.shared.windows.first?.rootViewController = vc
    vc.comesFrom = "Notif"
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}

func gotoParentAnnouncement() {
    let sb = UIStoryboard(name: "Parent", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "ParentAnnouncements") as! ParentAnnouncements
    UIApplication.shared.windows.first?.rootViewController = vc
    vc.comesFrom = "Notif"
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}

func gotoTeacherAnnouncement() {
    let sb = UIStoryboard(name: "Teacher", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "TeacherAnnouncements") as! TeacherAnnouncements
    UIApplication.shared.windows.first?.rootViewController = vc
    vc.comesFrom = "Notif"
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}
