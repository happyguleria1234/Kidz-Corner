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
    
    var messageListing: UserMessagesList?
    
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
    
    func setSocketConnectionAndKeys() {
        fetchChatDialogs {
            self.tblMessages.reloadData()
        }
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
                    self?.setSocketConnectionAndKeys()
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
        keyboardHandling()
        setSocketConnectionAndKeys()
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
}

extension MessageListingVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageListing?.data.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = messageListing?.data.data[indexPath.row] {
            if data.senderID == 905 {
                let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
                senderCell.setMessageData(messageData: data)
                return senderCell
            } else {
                let recieverCell = tableView.dequeueReusableCell(withIdentifier: "RecieverCell", for: indexPath) as! RecieverCell
                recieverCell.setMessageData(messageData: data)
                return recieverCell
            }
        }
        return UITableViewCell()
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
    
    func fetchChatDialogs(onSuccess: @escaping(()->())) {
        SocketIOManager.sharedInstance.userMessagesEmitter()
        SocketIOManager.sharedInstance.userMessagesListener { [weak self] messageDialogs in
            print(messageDialogs)
            self?.messageListing = messageDialogs
            onSuccess()
        }
    }
    
    func sendMesage(message: String, mediaStr: String = "", thumbnailStr:String = "", onSuccess: @escaping(()->())) {
        SocketIOManager.sharedInstance.sendMessageEmitter(messageStr: message,mediaStr: mediaStr,thumbnailStr: thumbnailStr)
        SocketIOManager.sharedInstance.sendMessageListener { [weak self] messageDialogs in
            print(messageDialogs)
            self?.messageListing = messageDialogs
            onSuccess()
        }
    }
    
}

