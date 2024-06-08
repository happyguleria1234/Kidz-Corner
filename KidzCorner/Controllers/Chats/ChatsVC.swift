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
    
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tblChats: UITableView!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnSearch(_ sender: Any) {
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
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell
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
}
