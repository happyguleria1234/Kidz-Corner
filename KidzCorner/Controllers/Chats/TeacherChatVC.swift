import UIKit

class TeacherChatVC: UIViewController, OpenChatVCProtocol {
    
    //------------------------------------------------------
    
    //MARK: Varibles and Outlets
    
    
    private var allCharRoomResp = [ChatData]()
    private var charRoomResp = [ChatData]()
    var isComming = String()
    var userList: MessageList?
    var socket = SocketIOManager()
    var isNavigatedToMessageListingVC = false
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeacherUsersListVC") as! TeacherUsersListVC
        vc.delegate = self
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
        getChatRoomData()
    }
    
    //------------------------------------------------------
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        let searchedText = textField.text
        handleChatUserSearch(searchedText)
    }
}

extension TeacherChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charRoomResp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell
        let data = charRoomResp[indexPath.row]
        cell.lblStatus.cornerRadius = 4
        cell.lblStatus.isHidden = true
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
        let sb = UIStoryboard(name: "Parent", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MessageListingVC") as! MessageListingVC
        vc.id = studentID
        vc.comesFrom = "Teacher"
        vc.threadID = data.id
        vc.userName = "\(data.student?.name ?? "")"
        vc.userProfileImage = "\(data.student?.image ?? "")"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension TeacherChatVC {
    
    func fetchChatDialogs(onSuccess: @escaping(()->())) {
        SocketIOManager.sharedInstance.messageListingListener { [weak self] messageDialogs in
            print(messageDialogs)
            self?.userList = messageDialogs
            self?.tblChats.reloadData()
            onSuccess()
        }
        SocketIOManager.sharedInstance.getUsers()
    }
    
    func openChat(_ studentID:Int,_ userProfileImage:String?,_ userName:String?,_ threadID:Int = 0) {
        
        SocketIOManager.sharedInstance.joinRoomEmitter(userID: studentID)
               SocketIOManager.sharedInstance.joinRoomListner { [weak self] messageInfo in
                   guard let self = self else { return }
                   print(messageInfo)
                   DispatchQueue.main.async {
                       if !self.isNavigatedToMessageListingVC {
                           self.isNavigatedToMessageListingVC = true
                           let sb = UIStoryboard(name: "Parent", bundle: nil)
                           let vc = sb.instantiateViewController(withIdentifier: "MessageListingVC") as! MessageListingVC
                           vc.id = Int(messageInfo.data?.student?.id ?? "") ?? 0
                           vc.threadID = Int(messageInfo.data?.thread?.id ?? "") ?? 0
                           vc.userName = messageInfo.data?.student?.name
                           vc.userProfileImage = messageInfo.data?.student?.name
                           vc.comesFrom = "New Chat"
                           vc.hidesBottomBarWhenPushed = true
                           self.navigationController?.pushViewController(vc, animated: true)

                           // Remove or deactivate the listener here if needed
                           // e.g., SocketIOManager.sharedInstance.removeListener("joinRoomListner")
                       }
                   }
               }
        
        
//        SocketIOManager.sharedInstance.joinRoomEmitter(userID: studentID)
//        SocketIOManager.sharedInstance.joinRoomListner { messageInfo in
//            print(messageInfo)
//            DispatchQueue.main.async {
//                let sb = UIStoryboard(name: "Parent", bundle: nil)
//                let vc = sb.instantiateViewController(withIdentifier: "MessageListingVC") as! MessageListingVC
//                vc.id = Int(messageInfo.data?.student?.id ?? "")
//                vc.threadID = Int(messageInfo.data?.thread?.id ?? "")
//                vc.userName = messageInfo.data?.student?.name
//                vc.userProfileImage = messageInfo.data?.student?.name
//                vc.comesFrom = "New Chat"
//                vc.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    }
}
extension TeacherChatVC {
    
    private func handleChatUserSearch(_ searchedText: String?) {
        var filteredUserList = [ChatData]()
        
        if let searchedText = searchedText?.lowercased(), !searchedText.isEmpty {
            filteredUserList = charRoomResp.filter { chatData in
                if let name = chatData.student?.name {
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
