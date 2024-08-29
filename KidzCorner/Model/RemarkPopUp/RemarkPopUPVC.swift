//
//  RemarkPopUPVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 19/08/24.
//

import UIKit

class RemarkPopUPVC: UIViewController {
    
    //------------------------------------------------------
    
    //MARK: Outlets
    
    var userID = Int()
    var albumID = String()
    var comesFrom = String()
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var remarktableView: UITableView!
    
    //------------------------------------------------------
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if comesFrom == "Album" {
            getComments(userID: userID, albumID: albumID)
        } else {
            hitAlbumWithId(studentID: userID)
        }
        remarktableView.delegate = self
        remarktableView.dataSource = self
        remarktableView.register(UINib(nibName: "RemarkPopUPCell", bundle: nil), forCellReuseIdentifier: "RemarkPopUPCell")
    }
    
    //------------------------------------------------------
    
    //MARK: API Call
    
    func getComments(userID: Int, albumID: String) {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        let param = ["user_id":userID,"portfolio_id":albumID] as? [String:Any] ?? [:]
        ApiManager.shared.Request(type: AlbumModelDataa.self, methodType: .Post, url: baseUrl+commentss, parameter: param) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.sync {
//                    self.albumDetailData = myObject
                    self.remarktableView.reloadData()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func hitAlbumWithId(studentID:Int){
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        let param = ["user_id":userID] as? [String:Any] ?? [:]
        ApiManager.shared.Request(type: AlbumModelDataa.self, methodType: .Post, url: baseUrl+remarkComments, parameter: param) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.sync {
//                    self.albumDetailData = myObject
                    self.remarktableView.reloadData()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func crossBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//------------------------------------------------------

//MARK: Table View delegate and datasource

extension RemarkPopUPVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemarkPopUPCell", for: indexPath) as! RemarkPopUPCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
