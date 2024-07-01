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

    private var allCharRoomResp = [ChatData]()
    private var charRoomResp = [ChatData]()
    var isComming = String()
    var userList: MessageList?
    var socket = SocketIOManager()
    
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tblChats: UITableView!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setSocketConnectionAndKeys() {
        fetchChatDialogs {
            self.tblChats.reloadData()
        }
    }
    
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
                    vc.id = Int(messageInfo.data?.student?.id ?? "") ?? 0
                    vc.threadID = Int(messageInfo.data?.thread?.id ?? "") ?? 0
                    vc.userName = messageInfo.data?.student?.name
                    vc.userProfileImage = messageInfo.data?.student?.name
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    // Remove or deactivate the listener here if needed
                    // e.g., SocketIOManager.sharedInstance.removeListener("joinRoomListner")
                }
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let data = charRoomResp[indexPath.row]
//        guard let studentID = data.studentID else { return }
//
//        SocketIOManager.sharedInstance.joinRoomEmitter(userID: studentID)
//        SocketIOManager.sharedInstance.joinRoomListner { messageInfo in
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageListingVC") as! MessageListingVC
//            vc.comesFrom = "User"
//            vc.id = Int(messageInfo.data?.student?.id ?? "")
//            vc.threadID = Int(messageInfo.data?.thread?.id ?? "")
//            vc.userName = messageInfo.data?.student?.name
//            vc.userProfileImage = messageInfo.data?.student?.name
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
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
        lbl_time.text = " "
        imgProfile.contentMode = .scaleAspectFill
        if let userProfileUrl = data.student?.image {
            imgProfile.sd_setImage(with: URL(string: imageBaseUrl+(userProfileUrl)),
                                   placeholderImage: .announcementPlaceholder)
        }
        if data.unread_message == 0 {
            lbl_count.isHidden = true
        } else {
            lbl_count.isHidden = false
            lbl_count.text = "\(data.unread_message ?? 0)"
        }
        if let messageDate = data.message?.createdAt {
            lbl_time.text = formatDateString(dateString: messageDate)
        }
       
        
        
    }
    
    func setData(userData: MessageListUsers) {
        lbl_message.text = userData.message
        imgProfile.sd_setImage(with: URL(string: imageBaseUrl+(userData.profileImage)), placeholderImage: .announcementPlaceholder)
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

extension ChatsVC {
    
    func fetchChatDialogs(onSuccess: @escaping(()->())) {
        SocketIOManager.sharedInstance.messageListingListener { [weak self] messageDialogs in
            print(messageDialogs)
            self?.userList = messageDialogs
            self?.tblChats.reloadData()
            onSuccess()
        }
        SocketIOManager.sharedInstance.getUsers()
    }
}


// New work

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
        ApiManager.shared.Request(type: ChatInboxModel.self,
                                  methodType: .Get,
                                  url: baseUrl+chatRoom,
                                  parameter: [:]) { error, resp, msgString, statusCode in
            
            guard error == nil,
                  let userlist = resp?.data?.data,
                  statusCode == 200 else {
                self.stopIndicator()
                return }
            
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
