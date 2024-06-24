//
//  MessageListingVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 08/06/24.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class MessageListingVC: UIViewController {
    
    //------------------------------------------------------
    
    //MARK: Variables and Outlets
    public var userName:String?
    public var userProfileImage:String?
    public var id:Int?
    public var threadID:Int?
    var comesFrom = String()
    var messageListing = [MessagesModelListingDatum]()
    
    @IBOutlet weak var tf_message: UITextField!
    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblMessages: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var hiddenTextView: UITextView!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    //MARK: Custom
    
    func setData() {
        tblMessages.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tblMessages.register(UINib(nibName: "RecieverCell", bundle: nil), forCellReuseIdentifier: "RecieverCell")
    }
    
    private func setupHiddenTextView() {
        hiddenTextView = UITextView(frame: .zero)
        hiddenTextView.isHidden = true
        view.addSubview(hiddenTextView)
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendMessage(_ sender: UIButton) {
        if let messageData = tf_message.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if messageData != "" {
                sendMesage(message: messageData) { [weak self] in
                    self?.tf_message.text = ""
                }
            }
        }
    }
    
    @IBAction func btnSendEmoji(_ sender: UIButton) {
        hiddenTextView.becomeFirstResponder()
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        populateData()
        keyboardHandling()
        if comesFrom == "New Chat" {
            SocketIOManager.sharedInstance.joinRoomEmitter(userID: id)
        }
        getMessages()
        setupHiddenTextView()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

extension MessageListingVC {
    func keyboardHandling(){
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MessageListingVC.self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 20
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        tableViewScrollToBottom()
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136,1334,1920, 2208:
                    print("")
                    self.bottomConstraint.constant = -(keyboardSize.height - self.view.safeAreaInsets.bottom+6)
                case 2436,2688,1792:
                    print("")
                    self.bottomConstraint.constant = -(keyboardSize.height - self.view.safeAreaInsets.bottom+9)
                default:
                    print("")
                    self.bottomConstraint.constant = -(keyboardSize.height - self.view.safeAreaInsets.bottom+9)
                }
            }
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    private func populateData() {
        lbl_name.text = userName
        imgProfile.contentMode = .scaleAspectFill
        if let userProfileUrl = userProfileImage {
            imgProfile.sd_setImage(with: URL(string: imageBaseUrl+(userProfileUrl)),
                                   placeholderImage: .announcementPlaceholder)
        }
    }
}

extension MessageListingVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userID = UserDefaults.standard.value(forKey: myUserid) as? Int ?? 0
        let data = messageListing[indexPath.row]
        if data.message?.senderID == userID {
            let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
            senderCell.setMessageData(messageData: data)
            return senderCell
        } else {
            let recieverCell = tableView.dequeueReusableCell(withIdentifier: "RecieverCell", for: indexPath) as! RecieverCell
            recieverCell.setMessageData(messageData: data)
            return recieverCell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MessageListingVC {
    
    // MARK: - TABLE VIEW SCROLL TO BOTTOM
    func tableViewScrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0)) {
            let numberOfSections = self.tblMessages.numberOfSections
            let numberOfRows = self.tblMessages.numberOfRows(inSection: 0)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tblMessages.scrollToRow(at: indexPath, at: .bottom, animated: false )
            }
        }
    }
}


extension MessageListingVC {
    
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
    
    func getMessages() {
        showIndicator()
        ApiManager.shared.Request(type: MessagesModelListing.self,methodType: .Get,url: baseUrl+chatRoom,parameter: ["id":threadID ?? 0]) { error, resp, msgString, statusCode in
            guard error == nil,
                  let userlist = resp?.data.data,
                  statusCode == 200 else {
                self.stopIndicator()
                return }
            
            DispatchQueue.main.async {
                self.stopIndicator()
                self.messageListing = userlist
                self.tblMessages.scrollToBottom()
                self.tblMessages.reloadData()
                print("CharRoomResp: \(userlist)")
            }
        }
    }
    
    func sendMesage(message: String, mediaStr: String = "", thumbnailStr:String = "", onSuccess: @escaping(()->())) {
        guard let userID = UserDefaults.standard.value(forKey: myUserid) as? Int else { return }
        guard let recieverID = id else { return }
        SocketIOManager.sharedInstance.sendMessageEmitter(messageStr: message,senderId: userID,recieverID: recieverID,threadID: threadID ?? 0)
        SocketIOManager.sharedInstance.sendMessageListener { [weak self] messageDialogs in
            onSuccess()
        }
    }
    
}

