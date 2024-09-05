//
//  MessageListingVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 08/06/24.
//

import UIKit
import Foundation
import SDWebImage
import IQKeyboardManagerSwift

var userNamee:String?
var userProfileImagee:String?
var id:Int?
var threadIDD = Int()

class MessageListingVC: UIViewController, FilePickerManagerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    //------------------------------------------------------
    
    //MARK: Variables and Outlets
    
    var comesFrom = String()
    private var isListenerAdded = false
    var messageListing = [MessagesModelListingDatum]()
    private var filePickerManager: FilePickerManager!
    var imageData: Data?
    let downloadManager = DownloadManager.shared
    private var isLoadingMessages = false
    private var isFetchingMessages = false
    var currentPage = 1
    
    @IBOutlet weak var txt_view_height: NSLayoutConstraint!
    @IBOutlet weak var btnSendOutlet: UIButton!
    @IBOutlet weak var bootamView: UIView!
    @IBOutlet weak var topView: GradientView!
    @IBOutlet weak var tf_message: UITextView!
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
        tf_message.delegate = self
        tblMessages.delegate = self
        tblMessages.dataSource = self
        
        tblMessages.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tblMessages.register(UINib(nibName: "RecieverCell", bundle: nil), forCellReuseIdentifier: "RecieverCell")
        tblMessages.register(UINib(nibName: "SenderImageCell", bundle: nil), forCellReuseIdentifier: "SenderImageCell")
        tblMessages.register(UINib(nibName: "RecieverImageCell", bundle: nil), forCellReuseIdentifier: "RecieverImageCell")
        tblMessages.register(UINib(nibName: "PDFViewCell", bundle: nil), forCellReuseIdentifier: "PDFViewCell")
        tblMessages.register(UINib(nibName: "PDFViewReciverCell", bundle: nil), forCellReuseIdentifier: "PDFViewReciverCell")
    }
    
    private func setupHiddenTextView() {
        hiddenTextView = UITextView(frame: .zero)
        hiddenTextView.isHidden = true
        view.addSubview(hiddenTextView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            tf_message.insertText("\n") // Insert a newline when the return key is pressed
            return false
        }
        return true
    }
    
    // MARK: - FilePickerManagerDelegate
    
    func didPickImage(_ image: UIImage) {
        // Handle the selected image
        print("Selected image: \(image)")
        btnSendOutlet.setImage(UIImage(named: "send1"), for: .normal)
        let imgData = image.jpegData(compressionQuality: 0.1)
        imageData = imgData
        uploadImage(params: ["image":imageData!],fileData: imageData!) { [self] data in
            print("")
            sendMessage(message: "",mediaStr: data.data,thumbnailStr: data.data,messageType:2) { [weak self] in
                DispatchQueue.main.async {
                    self?.tf_message.text = ""
                    self?.tblMessages.scrollToBottom()
                    self?.tblMessages.reloadData()
                }
            }
        }
    }
    
    func didPickPDF(_ url: URL) {
        print("Selected PDF: \(url)")
        btnSendOutlet.setImage(UIImage(named: "send1"), for: .normal)
        do {
            let pdfData = try Data(contentsOf: url)
            uploadPDF(params: ["image":pdfData],fileData: pdfData) { [self] data in
                sendMessage(message: "",mediaStr: data.data,thumbnailStr: data.data,messageType:3) { [weak self] in
                    DispatchQueue.main.async {
                        self?.tf_message.text = ""
                        self?.tblMessages.scrollToBottom()
                        self?.tblMessages.reloadData()
                    }
                }
            }
        } catch {
            print("Failed to convert PDF to Data: \(error.localizedDescription)")
        }
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        tblMessages.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: UIButton) {
        if comesFrom == "Notif" {
            let roleId = UserDefaults.standard.integer(forKey: myRoleId)
            if roleId == 4 {
                gotoHome()
            } else {
                gotoHomeTeacher()
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnAttachment(_ sender: UIButton) {
        filePickerManager.presentImagePicker()
    }
    
    @IBAction func btnPDFAttachment(_ sender: UIButton) {
        filePickerManager.presentDocumentPicker()
    }
    
    
    
    @IBAction func btnSendMessage(_ sender: UIButton) {
        if let messageData = tf_message.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if messageData != "" {
                sendMessage(message: messageData,messageType:1) { [weak self] in
                    DispatchQueue.main.async {
                        self?.tf_message.text = ""
                        self?.tblMessages.scrollToBottom()
                        self?.tblMessages.reloadData()
                    }
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
        keyboardHandling()
        setData()
        populateData()
        SocketIOManager.sharedInstance.joinRoomEmitter(userID: id)
        getMessages()
        setupHiddenTextView()
        filePickerManager = FilePickerManager(viewController: self)
        filePickerManager.delegate = self
        tblMessages.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        
        if !isListenerAdded {
            isListenerAdded = true
            SocketIOManager.sharedInstance.sendMessageListener { [weak self] messageDialogs in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    if !strongSelf.messageListing.isEmpty {
                        var lastMessage = strongSelf.messageListing[strongSelf.messageListing.count - 1]
                        lastMessage.messages.append(messageDialogs.data!)
                        strongSelf.messageListing[strongSelf.messageListing.count - 1] = lastMessage
                        strongSelf.tblMessages.scrollToBottom()
                        strongSelf.tblMessages.reloadData()
                    }
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let trimmedText = tf_message.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        DispatchQueue.main.async {
            if trimmedText.isEmpty {
                self.btnSendOutlet.setImage(UIImage(named: "sendGray"), for: .normal)
            } else {
                self.btnSendOutlet.setImage(UIImage(named: "sendGreen"), for: .normal)
            }
        }
        
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        txt_view_height.constant = size.height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset",
           let contentOffset = change?[.newKey] as? CGPoint,
           contentOffset.y < 0 && !isFetchingMessages {
            fetchPreviousMessages()
        }
    }
    
    private func fetchPreviousMessages() {
        guard !isFetchingMessages else { return }
        
        isFetchingMessages = true
        let nextPage = currentPage + 1
        
        // Capture current content offset
        let currentContentOffset = self.tblMessages.contentOffset
        
        var totalCount = 0
        for i in 0..<self.messageListing.count {
            let messages = self.messageListing[i].messages
            totalCount += messages.count
        }
        print("Total number of rows: \(totalCount)")
        
        ApiManager.shared.Request(type: MessagesModelListing.self, methodType: .Get, url: "\(baseUrl)chatroom/\(threadIDD)", parameter: ["page_size": "100", "page": "\(nextPage)"]) { [weak self] error, resp, msgString, statusCode in
            guard let self = self, error == nil, statusCode == 200 else {
                self?.isFetchingMessages = false
                return
            }
            
            DispatchQueue.main.async {
                self.isFetchingMessages = false
                
                guard let resp = resp else { return }
                
                resp.data.data.forEach { data in
                    var reversedData = data
                    reversedData.messages.reverse()
                    self.messageListing.insert(reversedData, at: 0)
                }
                
                self.currentPage = nextPage
                self.tblMessages.reloadData()
                
                // Restore previous content offset
                self.tblMessages.setContentOffset(currentContentOffset, animated: false)
                
                // Recalculate totalCount after inserting new data
                var updatedTotalCount = 0
                for i in 0..<self.messageListing.count {
                    let messages = self.messageListing[i].messages
                    updatedTotalCount += messages.count
                }
                
                // Calculate last row index and section index
                let lastSectionIndex = self.messageListing.count - 1
                let lastRowIndex = updatedTotalCount - 1
                
                // Ensure lastIndexPath is within bounds
                if lastSectionIndex >= 0 && lastRowIndex >= 0 {
                    let lastIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
                    if lastSectionIndex < self.tblMessages.numberOfSections && lastRowIndex < self.tblMessages.numberOfRows(inSection: lastSectionIndex) {
                        self.tblMessages.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
                    } else {
                        print("Invalid index path: \(lastIndexPath)")
                    }
                } else {
                    print("Invalid section or row index.")
                }
            }
        }
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
                    self.bottomConstraint.constant = (keyboardSize.height - self.view.safeAreaInsets.bottom+8)
                case 2436,2688,1792:
                    print("")
                    self.bottomConstraint.constant = (keyboardSize.height - self.view.safeAreaInsets.bottom+11)
                default:
                    print("")
                    self.bottomConstraint.constant = (keyboardSize.height - self.view.safeAreaInsets.bottom+11)
                }
            }
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    private func populateData() {
        lbl_name.text = userNamee
        imgProfile.contentMode = .scaleAspectFill
        let userProfileUrl = URL(string: imageBaseUrl+(userProfileImagee ?? ""))
        DispatchQueue.main.async {
            self.imgProfile.kf.setImage(with: userProfileUrl, placeholder: UIImage(named: "placeholderImage"))
        }
    }
}

extension MessageListingVC : UITableViewDelegate, UITableViewDataSource, UIContextMenuInteractionDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageListing.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageListing[section].messages.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let headerLabel = UILabel()
        if messageListing[section].date == "yesterday" || messageListing[section].date == "today" {
            headerLabel.text = messageListing[section].date.capitalized
        } else {
            headerLabel.text = messageListing[section].date
        }
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        headerLabel.textColor = UIColor.gray
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userID = UserDefaults.standard.value(forKey: "myUserid") as? Int ?? 0
        let data = messageListing[indexPath.section].messages[indexPath.row]
        let button = IndexedButton()
        button.section = indexPath.section
        button.row = indexPath.row
        if data.messageType == 1 {
            if data.senderID == userID {
                let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
                senderCell.setMessageData(messageData: data)
                senderCell.btnTap = button
                senderCell.btnTap.addTarget(self, action: #selector(loadDoc(sender:)), for: .touchUpInside)
                return senderCell
            } else {
                let recieverCell = tableView.dequeueReusableCell(withIdentifier: "RecieverCell", for: indexPath) as! RecieverCell
                recieverCell.setMessageData(messageData: data)
                recieverCell.btnTap = button
                if loggedUSer == "Teacher" {
                    recieverCell.lbl_name.isHidden = true
                    if let url = URL(string: imageBaseUrl+(data.student?.image ?? "")) {
                        recieverCell.img_profile.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
                    }
                    
                } else {
                    if let url = URL(string: imageBaseUrl+(data.user?.image ?? "")) {
                        recieverCell.img_profile.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
                    }
                }
                recieverCell.btnTap.addTarget(self, action: #selector(loadDoc(sender:)), for: .touchUpInside)
                return recieverCell
            }
        } else if data.messageType == 2{
            if data.senderID == userID {
                let senderImageCell = tableView.dequeueReusableCell(withIdentifier: "SenderImageCell", for: indexPath) as! SenderImageCell
                senderImageCell.setMessageData(messageData: data)
                senderImageCell.btnTap.tag = indexPath.section * 1000 + indexPath.row
                senderImageCell.btnTap.addTarget(self, action: #selector(buttonSelected(sender:)), for: .touchUpInside)
                return senderImageCell
            } else {
                let recieverImageCell = tableView.dequeueReusableCell(withIdentifier: "RecieverImageCell", for: indexPath) as! RecieverImageCell
                recieverImageCell.setMessageData(messageData: data)
                recieverImageCell.btnTap.tag = indexPath.section * 1000 + indexPath.row
                if loggedUSer == "Teacher" {
                    recieverImageCell.lblName.isHidden = true
                    if let url = URL(string: imageBaseUrl+(data.student?.image ?? "")) {
                        recieverImageCell.img_user.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
                    }
                } else {
                    if let url = URL(string: imageBaseUrl+(data.user?.image ?? "")) {
                        recieverImageCell.img_user.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
                    }
                }
                recieverImageCell.btnTap.addTarget(self, action: #selector(buttonSelected(sender:)), for: .touchUpInside)
                return recieverImageCell
            }
        } else if data.messageType == 3{
            if data.senderID == userID {
                let senderImageCell = tableView.dequeueReusableCell(withIdentifier: "PDFViewCell", for: indexPath) as! PDFViewCell
                senderImageCell.setMessageData(messageData: data)
                senderImageCell.downloadBtn.tag = indexPath.section * 1000 + indexPath.row
                senderImageCell.downloadBtn.addTarget(self, action: #selector(pdfDownload(sender:)), for: .touchUpInside)
                return senderImageCell
            } else {
                let senderImageCell = tableView.dequeueReusableCell(withIdentifier: "PDFViewReciverCell", for: indexPath) as! PDFViewReciverCell
                senderImageCell.setMessageData(messageData: data)
                senderImageCell.downloadBtn.tag = indexPath.section * 1000 + indexPath.row
                if loggedUSer == "Teacher" {
                    senderImageCell.lblName.isHidden = true
                    if let url = URL(string: imageBaseUrl+(data.student?.image ?? "")) {
                        senderImageCell.userImgVw.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
                    }
                } else {
                    if let url = URL(string: imageBaseUrl+(data.user?.image ?? "")) {
                        senderImageCell.userImgVw.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
                    }
                }
                senderImageCell.downloadBtn.addTarget(self, action: #selector(pdfDownload(sender:)), for: .touchUpInside)
                return senderImageCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = messageListing[indexPath.section].messages[indexPath.row]
        if data.messageType == 3{
            if data.media?.contains(".pdf") == true{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OpenChatData") as! OpenChatData
                vc.url = data.media ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if data.messageType == 2{
            //            let section = indexPath.row / 1000
            //            let row = indexPath.row % 1000
            //            let messageData = messageListing[indexPath.row].messages[row]
            if let media = data.media, media != "", data.message == "" {
                if let vc = storyboard?.instantiateViewController(withIdentifier: "OpenChatData") as? OpenChatData {
                    vc.url = media
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let userID = UserDefaults.standard.value(forKey: "myUserid") as? Int ?? 0
        if self.messageListing[indexPath.section].messages[indexPath.row].senderID == userID {
            return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { [weak self] _ in
                return UIMenu(title: "", children: [
                    UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                        guard let self = self else { return }
                        let data = self.messageListing[indexPath.section].messages[indexPath.row]
                        SocketIOManager.sharedInstance.deleteMessage(threadID: threadIDD, messageID: data.id ?? 0)
                        SocketIOManager.sharedInstance.deleteMessageListner { status in
                            if status {
                                DispatchQueue.main.async {
                                    self.messageListing[indexPath.section].messages.remove(at: indexPath.row)
                                    self.tblMessages.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                                }
                            }
                        }
                    }
                ])
            }
        }
        return nil
    }
    
    @available(iOS 13.0, *)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func openURLInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func loadDoc(sender: IndexedButton) {
        let data = messageListing[sender.section].messages[sender.row]
        if data.message == "" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OpenChatData") as! OpenChatData
            vc.url = data.media ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //    MARK: NEW ONE
    @objc func buttonSelected(sender: UIButton){
        let section = sender.tag / 1000
        let row = sender.tag % 1000
        let messageData = messageListing[section].messages[row]
        if let media = messageData.media, media != "", messageData.message == "" {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "OpenChatData") as? OpenChatData {
                vc.url = media
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    @objc func pdfDownload(sender: UIButton){
        let section = sender.tag / 1000
        let row = sender.tag % 1000
        let pdfFile = messageListing[section].messages[row].media ?? ""
        printt("its download pdf")
        let pdfURLString = pdfFile
        guard let url = URL(string: imageBaseUrl + pdfURLString) else {
            print("Invalid URL")
            return
        }
        downloadManager.downloadPDF(from: url) { data in
            if let data = data {
                self.downloadManager.savePDF(data: data, fileName: "downloaded_document.pdf")
            } else {
                print("Failed to download PDF.")
            }
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
        ApiManager.shared.Request(type: MessagesModelListing.self, methodType: .Get, url: "\(baseUrl)chatroom/\(threadIDD)", parameter: ["page_size": "1000", "page": "1"]) { error, resp, msgString, statusCode in
            guard error == nil, statusCode == 200 else {
                DispatchQueue.main.async {
                    self.stopIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.stopIndicator()
                
                resp?.data.data.forEach({ data in
                    // Reverse the messages array inside each data
                    var reversedData = data
                    reversedData.messages.reverse()
                    self.messageListing.append(reversedData)
                })
                self.messageListing.reverse()
                self.tblMessages.reloadData()
                self.tblMessages.scrollToBottom()
            }
        }
    }
    
    func uploadImage(params: [String: Any], fileData: Data, onSuccess: @escaping ((UploadModel) -> ())) {
        showIndicator()
        ApiManager.shared.requestWithSingleImage(type: UploadModel.self, url: "\(baseUrl)image_upload", parameter: params, imageName: "image.png", imageKeyName: "image", image: fileData) { error, myObject, messageStr, statusCode in
            guard error == nil, statusCode == 200 else {
                DispatchQueue.main.async {
                    self.stopIndicator()
                }
                return
            }
            DispatchQueue.main.async {
                if statusCode == 200 {
                    print("Successfully uploaded")
                    onSuccess(myObject!)
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func uploadPDF(params: [String:Any],fileData:Data,onSuccess: @escaping((UploadModel)->())) {
        showIndicator()
        ApiManager.shared.requestWithSingleImage(type: UploadModel.self, url: "\(baseUrl)image_upload", parameter: params, imageName: "image.pdf", imageKeyName: "image", image: fileData) { error, myObject, messageStr, statusCode in
            guard error == nil, statusCode == 200 else {
                self.stopIndicator()
                return
            }
            if statusCode == 200 {
                print("Successfully uploaded")
                onSuccess(myObject!)
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func sendMessage(message: String, mediaStr: String = "", thumbnailStr: String = "", messageType: Int, onSuccess: @escaping(() -> ())) {
        guard let userID = UserDefaults.standard.value(forKey: myUserid) as? Int else { return }
        guard let recieverID = id else { return }
        
        SocketIOManager.sharedInstance.sendMessageEmitter(messageStr: message, senderId: userID, recieverID: recieverID, threadID: threadIDD, messageType: messageType, media: mediaStr, thumbnail: thumbnailStr)
        onSuccess()
    }
}

class IndexedButton: UIButton {
    var section: Int = 0
    var row: Int = 0
}

