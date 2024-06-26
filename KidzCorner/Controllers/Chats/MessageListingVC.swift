//
//  MessageListingVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 08/06/24.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class MessageListingVC: UIViewController, FilePickerManagerDelegate {
    
    //------------------------------------------------------
    
    //MARK: Variables and Outlets
    public var userName:String?
    public var userProfileImage:String?
    public var id:Int?
    public var threadID:Int?
    var comesFrom = String()
    private var isListenerAdded = false
    var messageListing = [MessagesModelListingDatum]()
    private var filePickerManager: FilePickerManager!
    var imageData: Data?

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
        tblMessages.register(UINib(nibName: "SenderImageCell", bundle: nil), forCellReuseIdentifier: "SenderImageCell")
        tblMessages.register(UINib(nibName: "RecieverImageCell", bundle: nil), forCellReuseIdentifier: "RecieverImageCell")

    }
    
    private func setupHiddenTextView() {
        hiddenTextView = UITextView(frame: .zero)
        hiddenTextView.isHidden = true
        view.addSubview(hiddenTextView)
    }
    
    // MARK: - FilePickerManagerDelegate
    
    func didPickImage(_ image: UIImage) {
        // Handle the selected image
        print("Selected image: \(image)")
        let imgData = image.jpegData(compressionQuality: 0.1)
        imageData = imgData
        sendMesage(message: "",mediaStr: imageData!,thumbnailStr: imageData!,messageType:0) { [weak self] in
            self?.tf_message.text = ""
            self?.tblMessages.scrollToBottom()
            self?.tblMessages.reloadData()
        }
        
    }
    
    func didPickPDF(_ url: URL) {
        // Handle the selected PDF
        print("Selected PDF: \(url)")
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAttachment(_ sender: UIButton) {
        filePickerManager.presentFilePicker()
    }
    
    @IBAction func btnSendMessage(_ sender: UIButton) {
        if let messageData = tf_message.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if messageData != "" {
                sendMesage(message: messageData,messageType:1) { [weak self] in
                    self?.tf_message.text = ""
                    self?.tblMessages.scrollToBottom()
                    self?.tblMessages.reloadData()
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
        filePickerManager = FilePickerManager(viewController: self)
        filePickerManager.delegate = self
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
        tblMessages.scrollToBottom()
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
        if data.message == "" {
            if data.media?.contains(".pdf") == true {
                if data.senderID == userID {
                    let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
                    senderCell.setMessageData(messageData: data)
                    senderCell.btnTap.tag = indexPath.row
                    senderCell.btnTap.addTarget(self, action: #selector(loadDoc(sender:)), for: .touchUpInside)
                    return senderCell
                } else {
                    let recieverCell = tableView.dequeueReusableCell(withIdentifier: "RecieverCell", for: indexPath) as! RecieverCell
                    recieverCell.setMessageData(messageData: data)
                    recieverCell.btnTap.tag = indexPath.row
                    recieverCell.btnTap.addTarget(self, action: #selector(loadDoc(sender:)), for: .touchUpInside)
                    return recieverCell
                }
            } else {
                if data.senderID == userID {
                    let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderImageCell", for: indexPath) as! SenderImageCell
                    senderCell.setMessageData(messageData: data)
                    senderCell.btnTap.tag = indexPath.row
                    senderCell.btnTap.addTarget(self, action: #selector(loadDoc(sender:)), for: .touchUpInside)
                    return senderCell
                } else {
                    let recieverCell = tableView.dequeueReusableCell(withIdentifier: "RecieverImageCell", for: indexPath) as! RecieverImageCell
                    recieverCell.setMessageData(messageData: data)
                    recieverCell.btnTap.tag = indexPath.row
                    recieverCell.btnTap.addTarget(self, action: #selector(loadDoc(sender:)), for: .touchUpInside)
                    return recieverCell
                }
            }
        } else {
            if data.senderID == userID {
                let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
                senderCell.setMessageData(messageData: data)
                senderCell.btnTap.tag = indexPath.row
                senderCell.btnTap.addTarget(self, action: #selector(loadDoc(sender:)), for: .touchUpInside)
                return senderCell
            } else {
                let recieverCell = tableView.dequeueReusableCell(withIdentifier: "RecieverCell", for: indexPath) as! RecieverCell
                recieverCell.setMessageData(messageData: data)
                recieverCell.btnTap.tag = indexPath.row
                recieverCell.btnTap.addTarget(self, action: #selector(loadDoc(sender:)), for: .touchUpInside)
                return recieverCell
            }
        }
    }
    
    @objc func loadDoc(sender: UIButton) {
        let data = messageListing[sender.tag]
        if data.message == "" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OpenChatData") as! OpenChatData
            vc.url = data.media ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
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
        ApiManager.shared.Request(type: MessagesModelListing.self,methodType: .Get,url: "\(baseUrl)chatroom/\(threadID ?? 0)",parameter: ["page_size":"1000"]) { error, resp, msgString, statusCode in
            guard error == nil,
                  statusCode == 200 else {
                self.stopIndicator()
                return }
            
            DispatchQueue.main.async {
                self.stopIndicator()
                
                resp?.data.data.forEach({ data in
                    self.messageListing.append(data)
                })
                
                self.messageListing = self.messageListing.reversed()
                self.tblMessages.scrollToBottom()
                self.tblMessages.reloadData()
            }
        }
    }
    
    func sendMesage(message: String, mediaStr: Data = Data(), thumbnailStr: Data = Data(), messageType: Int ,  onSuccess: @escaping(() -> ())) {
        guard let userID = UserDefaults.standard.value(forKey: myUserid) as? Int else { return }
        guard let recieverID = id else { return }
        
        SocketIOManager.sharedInstance.sendMessageEmitter(messageStr: message, senderId: userID, recieverID: recieverID, threadID: threadID ?? 0,messageType: messageType)
        if !isListenerAdded {
            isListenerAdded = true
            SocketIOManager.sharedInstance.sendMessageListener { [weak self] messageDialogs in
//                self?.messageListing.append(messageDialogs)
                onSuccess()
            }
        }
    }
}
