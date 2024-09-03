import UIKit

//MARK: API Constants

public let baseUrl = "https://kidzcorner.live/api/"
public let imageBaseUrl = "https://kidzcorner.live/"
public let deviceType =  "1"
//"http://34.238.254.254"

public let apiLogin = "login"
public let apiDashboard = "dashboard"
public let apiAdminAnnouncement = "admin_announcement"
public let apiGetAttendance = "attendance"
public let apiGetStudentList = "get_student_list"
public let apiGetStudentDetail = "get_student_detail"
public let apiGetTeacherDetail = "get_teacher_detail"

public let apiPasswordReset = "passwordreset"
public let apiParentPortfolio = "get_parent_portfolio"
public let apiGetParentStudentDetail = "get_StudentDetail_for_parents"
public let apiTeacherPortfolio = "get_teacher_portfolio"

public let apiGetAllClasses = "classes"

public let apiGetPortfolio = "get_portfiolo"
public let apiAcceptRejectAnnouncement = "accept_reject_announcment"
public let apiActivityCategories = "get_category"

public let apiForgotPassword = "forget_passsword"
public let apiVerifyOtp = "verified_otp"
public let apiChangePassword = "change_password"
public let apiNotification = "notification"
public let getActivity = "activity"

public let somethingWentWrong = "Something Went Wrong"
public let deviceUuid = UIDevice.current.identifierForVendor?.uuidString

public let isLoggedIn = "isLoggedIn"

public let myRoleId = "myRoleId"
public let myUserid = "myUserid"
public let myToken = "myToken"
public let myName = "myName"
public let myImage = "myImage"
public let myChildrenIds = "childrenIds"
public let myChildrenData = "childrenData"
public let myDeviceToken = "deviceToken"
public let checkInStatus = "checkInStatus"
public let lastCheckedDateKey = "lastCheckedDateKey"


public let myClass = "myClass"

//MARK: New URLS
public let apiChildPortfolio = "child_portfolio"
public let apiTeacherAnnouncement = "teacher_annoucment"
public let apiParentAnnouncement = "announcement_children"
public let apiClassAttendance = "teacher_attendance"
public let apiStudentPortfolio = "student_portfolio"
public let apiGuardianList = "children_parent"
public let apiChildAttendance = "attendance_children"
public let apiStudentAttendance = "student_attendance"
public let apiPostPortfolio = "portfolio"
//public let apiPostPortfolio = "add_portfolio"
public let apiAddAttendance = "attendance"
public let apiAddEveningAttendance = "evening_attendance"
public let apiAddMiddleAttendance = "add_temprature"
public let apiParentAllChild = "parents_all_classes"

public let apiLikePortfolio = "like_portfolio"
public let apiComments = "comments"

public let apiGetAllPayments = "invoice"
public let apiGetPaymentDetail = "invoice"
public let teachersList = "all_teachers"
public let parentList = "all_children"
public let chatRoom = "chatroom"
public let uploadImage = "image_upload"

public let portfolioalbums = "portfolio_albums"
public let album_posts = "album_posts/"

public let invoicePdfUrl = "https://kidzcorner.live/generate_invoice_pdf/"
public let invoicePdfKey = "/5023fa9c3fd7c91f81f9c5bf2bb84368"

public let evaluationList = "evaluations?userId="
public let eavluationfilterList = "evaluations/"
public let logout = "signout"
public let evulationData = "announcement_children"
public let updateToken = "update_token"
public let commentss = "portfolioCommentList"
public let remarkComments = "evaluationRemarkList"
public let downloadpdf = "evaluation_child/3502/pdf"


extension UIImage {
    static var placeholderImage: UIImage {
        return UIImage(named: "placeholderImage")!
    }
    
    static var announcementPlaceholder: UIImage {
        return UIImage(named: "announcementPlaceholder")!
    }
    
}

//MARK: Color Constants
public let myGreenColor = UIColor(named: "myDarkGreen")!
public let backgroundColor = UIColor(named: "backgroundColor")!
public let placeholderColor = UIColor(named: "placeholderColor")!

/*
http://34.238.254.254./images/2022/02/a95aa4e62b22c9bc5bca4e83cadfaa82.png
*/

//https://kidzcorner.live/generate_invoice_pdf/INVOICE_ID/5023fa9c3fd7c91f81f9c5bf2bb84368
