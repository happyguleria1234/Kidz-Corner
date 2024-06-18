//
//  UsersListVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 16/06/24.
//

import UIKit
import Foundation

class UsersListVC : UIViewController {
    
    var isComing = String()
    @IBOutlet weak var tblList: UITableView!
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setData() {
        tblList.delegate = self
        tblList.dataSource = self
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch(_ sender: Any) {
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        if isComing == "Parent" {
            getParentList()
        } else {
            getTeachersList()
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

extension UsersListVC {
    
    func getTeachersList() {
        NetworkManager.shared.getRequest(urlString: baseUrl+teachersList, responseType: User.self, fromView: self.view) { result in
            switch result {
            case .success(let user):
                print("User: \(user)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func getParentList() {
        NetworkManager.shared.getRequest(urlString: baseUrl+parentList, responseType: User.self, fromView: self.view) { result in
            switch result {
            case .success(let user):
                print("User: \(user)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}

extension UsersListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

class UserListCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img_profile: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
