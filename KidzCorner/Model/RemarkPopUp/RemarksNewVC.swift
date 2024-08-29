//
//  RemarksNewVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 29/08/24.
//

import Foundation
import UIKit

class RemarksNewVC: UIViewController {
    
    //------------------------------------------------------
    
    //MARK: Outlets
    
    var userID = Int()
    var albumID = String()
    var comesFrom = String()
    var portFolioData = [PortFolioDataModelDatum]()
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var remarktableView: UITableView!
    
    //------------------------------------------------------
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remarktableView.delegate = self
        remarktableView.dataSource = self
        getComments(userID: userID, albumID: albumID)
        dataView.clipsToBounds = true
        dataView.layer.cornerRadius = 20
        dataView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        remarktableView.register(UINib(nibName: "RemarkPopUPCell", bundle: nil), forCellReuseIdentifier: "RemarkPopUPCell")
    }
    
    func applyTopCornerRadius(to view: UIView, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }

    
    //------------------------------------------------------
    
    //MARK: API Call
    
    func getComments(userID: Int, albumID: String) {
        //        DispatchQueue.main.async {
        //            startAnimating((self.tabBarController?.view)!)
        //        }
        let param = ["user_id":userID,"portfolio_id":albumID] as? [String:Any] ?? [:]
        ApiManager.shared.Request(type: PortFolioDataModel.self, methodType: .Post, url: baseUrl+commentss, parameter: param) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.sync {
                    self.portFolioData = myObject?.data ?? []
                    self.remarktableView.reloadData()
                    self.lblCount.text = "\(myObject?.data?.count ?? 0) Comments"
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
        self.dismiss(animated: true)
    }
    
}

//------------------------------------------------------

//MARK: Table View delegate and datasource

extension RemarksNewVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portFolioData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemarkPopUPCell", for: indexPath) as! RemarkPopUPCell
        let cellData = portFolioData[indexPath.row]
        cell.setDataPortfolio(listData: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
