//
//  ChatsVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 08/06/24.
//

import UIKit
import Foundation

class ChatsVC : UIViewController {
    
    //------------------------------------------------------
    
    //MARK: Varibles and Outlets
    
    var isNavigatedToMessageListingVC = false

    @IBOutlet weak var searchView: CustomView!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    private var allCharRoomResp = [ChatData]()
    private var charRoomResp = [ChatData]()
    var isComming = String()
    var userList: MessageList?
    var socket = SocketIOManager()
    var allChatData: ChatInboxModel?
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tblChats: UITableView!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func setSocketConnectionAndKeys() {
//        fetchChatDialogs {
//            self.tblChats.reloadData()
//        }
//    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnSearch(_ sender: UIButton) {
        let searchedText = tf_search.text
        handleChatUserSearch(searchedText)
    }
    
    @IBAction func btnAddUsers(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UsersListVC") as! UsersListVC
        vc.isComing = isComming
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  loggedUSer == "Teacher" {
            searchView.isHidden = false
            searchBarHeight.constant = 55
        } else {
            searchView.isHidden = true
            searchBarHeight.constant = 0
        }
        tblChats.reloadData()
        tblChats.backgroundColor = .clear
        SocketIOManager.sharedInstance.userStatus()
        tf_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isNavigatedToMessageListingVC = false
        getChatRoomData()
    }
    
    //------------------------------------------------------
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        let searchedText = textField.text
        handleChatUserSearch(searchedText)
    }
}

extension ChatsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charRoomResp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell
        let data = charRoomResp[indexPath.row]
        cell.populateData(data)
        if data.message?.messageType == 1{
            cell.messageType_ImgVw.isHidden = true
            cell.messageType_ImgVw.image = UIImage(named: "")
            cell.msgTypeWidthConstraints.constant = 0
            cell.lbl_message.text = data.message?.message
        }
        else if data.message?.messageType == 2{
            cell.messageType_ImgVw.isHidden = false
            cell.messageType_ImgVw.image = UIImage(named: "sendimage")
            cell.msgTypeWidthConstraints.constant = 18
            cell.lbl_message.text = "Image"

        }
        else if data.message?.messageType == 3{
            cell.messageType_ImgVw.isHidden = false
            cell.messageType_ImgVw.image = UIImage(named: "sendpdf")
            cell.msgTypeWidthConstraints.constant = 18
            cell.lbl_message.text = "PDF"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allChatData?.chat ?? false {
            let data = charRoomResp[indexPath.row]
            guard let studentID = data.studentID else { return }
            SocketIOManager.sharedInstance.joinRoomEmitter(userID: studentID)
            SocketIOManager.sharedInstance.joinRoomListner { [weak self] messageInfo in
                guard let self = self else { return }
                if !self.isNavigatedToMessageListingVC {
                    self.isNavigatedToMessageListingVC = true
                    
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageListingVC") as! MessageListingVC
                        vc.comesFrom = "User"
                        id = Int(messageInfo.data?.student?.id ?? "") ?? 0
                        threadIDD = Int(messageInfo.data?.thread?.id ?? "") ?? 0
                        userNamee = messageInfo.data?.student?.name
                        userProfileImagee = messageInfo.data?.student?.name
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        } else {
            AlertManager.shared.showAlert(title: "Chat Alert", message: "Message Unavailable.", viewController: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

class ChatsCell: UITableViewCell {
    
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var messageType_ImgVw: UIImageView!
    @IBOutlet weak var msgTypeWidthConstraints: NSLayoutConstraint!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func populateData(_ data:ChatData) {
        lbl_name.text = data.student?.name
        lbl_count.isHidden = true
        imgProfile.contentMode = .scaleAspectFill
        if let userProfileUrlString = data.student?.image,
           let userProfileUrl = URL(string: imageBaseUrl + userProfileUrlString) {
            imgProfile.kf.setImage(with: userProfileUrl)
        }
        if data.unreadMessage == 0 {
            lbl_count.isHidden = true
        } else {
            lbl_count.isHidden = false
            lbl_count.text = "\(data.unreadMessage ?? 0)"
        }
        if let messageDate = data.message?.createdAt {
            lbl_time.text = timeconverter(isoDateString: messageDate)
        }
    }
    
    func setData(userData: MessageListUsers) {
        imgProfile.sd_setImage(with: URL(string: imageBaseUrl+(userData.profileImage)), placeholderImage: .announcementPlaceholder)
    }
    
    func extractTime(strDate: String) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = dateFormatter.date(from: strDate) else {
            return nil
        }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: date)
    }
    
    
    private func formatDateString(dateString: String) -> String {
        let inputDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = dateFormatter.date(from: dateString) else {
            return " "
        }
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "hh:mm a"
        } else {
            dateFormatter.dateFormat = "MM/dd/yyyy"
        }
        return dateFormatter.string(from: date)
    }
}

// MARK: - API Call and Search

extension ChatsVC {
    
    private func handleChatUserSearch(_ searchedText: String?) {
        var filteredUserList = [ChatData]()
        
        if let searchedText = searchedText?.lowercased(), !searchedText.isEmpty {
            filteredUserList = charRoomResp.filter { chatData in
                if var name = chatData.student?.name {
                    name = name.lowercased()
                    return name.contains(searchedText)
                }
                return false
            }
        } else {
            filteredUserList = allCharRoomResp
        }
        
        self.charRoomResp = filteredUserList
        self.tblChats.reloadData()
    }
    
    private func showIndicator() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
    }
    
    private func stopIndicator() {
        DispatchQueue.main.async {
            stopAnimating()
        }
    }
    
    func getChatRoomData() {
        showIndicator()
        ApiManager.shared.Request(type: ChatInboxModel.self,methodType: .Get,url: baseUrl+chatRoom,parameter: [:]) { error, resp, msgString, statusCode in
            
            guard error == nil,
                  let userlist = resp?.data?.data,
                  statusCode == 200 else {
                self.stopIndicator()
                return }
            self.allChatData = resp
            DispatchQueue.main.async {
                self.stopIndicator()
                self.allCharRoomResp = userlist
                self.charRoomResp = userlist
                self.tblChats.reloadData()
                print("CharRoomResp: \(userlist)")
            }
        }
    }
}
