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
    var remarksData = [RemarkModelDataList]()
    var portFolioData = [PortFolioDataModelDatum]()
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var remarktableView: UITableView!
    
    //------------------------------------------------------
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if comesFrom == "Album" {
            getComments(userID: userID, albumID: albumID)
        } else {
            remarksData(studentID: userID)
        }
        remarktableView.delegate = self
        remarktableView.dataSource = self
        remarktableView.register(UINib(nibName: "RemarkPopUPCell", bundle: nil), forCellReuseIdentifier: "RemarkPopUPCell")
    }
    
    //------------------------------------------------------
    
    //MARK: API Call
    
    func getComments(userID: Int, albumID: String) {
        let param = ["user_id":userID,"portfolio_id":albumID] as? [String:Any] ?? [:]
        ApiManager.shared.Request(type: PortFolioDataModel.self, methodType: .Post, url: baseUrl+commentss, parameter: param) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.sync {
                    self.portFolioData = myObject?.data ?? []
                    self.remarktableView.reloadData()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func remarksData(studentID: Int) {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
                
        ApiManager.shared.Request(type: RemarkModelData.self, methodType: .Post, url: baseUrl + remarkComments, parameter: ["user_id": userID]) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.remarksData = myObject?.data ?? []
                DispatchQueue.main.sync {
                    self.remarktableView.reloadData()
                }
            } else {
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
        if comesFrom == "Album" {
            return portFolioData.count
        } else {
            return remarksData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemarkPopUPCell", for: indexPath) as! RemarkPopUPCell
        if comesFrom == "Album" {
            let cellData = portFolioData[indexPath.row]
            cell.setDataPortfolio(listData: cellData)
        } else {
            let cellData = remarksData[indexPath.row]
            cell.setData(listData: cellData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
