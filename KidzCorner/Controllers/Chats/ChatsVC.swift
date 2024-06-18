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
    }
    
    @IBAction func btnAddUsers(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UsersListVC") as! UsersListVC
        vc.isComing = isComming
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
        setSocketConnectionAndKeys()
        tblChats.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = true
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

extension ChatsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList?.data.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell
        if let data = userList?.data.data[indexPath.row] {
            cell.setData(userData: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageListingVC") as! MessageListingVC
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData(userData: MessageListUsers) {
        lbl_message.text = userData.message
        imgProfile.sd_setImage(with: URL(string: imageBaseUrl+(userData.profileImage)), placeholderImage: .announcementPlaceholder)
    }
}

extension ChatsVC {
    
    func fetchChatDialogs(onSuccess: @escaping(()->())) {
        SocketIOManager.sharedInstance.getUsers()
        SocketIOManager.sharedInstance.messageListingListener { [weak self] messageDialogs in
            print(messageDialogs)
            self?.userList = messageDialogs
            self?.tblChats.reloadData()
            onSuccess()
        }
    }
}
