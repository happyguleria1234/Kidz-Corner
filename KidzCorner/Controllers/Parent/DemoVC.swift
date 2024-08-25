//
//  DemoVC.swift
//  Ttwej
//
//  Created by cqlapple on 12/07/24.
//

import UIKit
import DropDown

struct Category {
    var name: String
    var items: [String]
}

class DemoVC: UIViewController, SelectEvulation {
    
    var userID = Int()
    var comesFrom = Int()
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lbltitle: UILabel!
    
    var categories: [Category] = []
    var selectedTitle = String()
    var demoArr: [String: [String]] = [
        "Arts": ["Drama", "Painting", "Drawing", "Dance"],
        "Arts 2": ["Drama", "Painting 2", "Drawing 2", "Dance 2"],
        "Arts 3": ["Drama 3", "Painting 3", "Drawing 3", "Dance 3"]
    ]
    
    //MARK: - DropDown's
    let userTypeDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.userTypeDropDown
        ]
    }()
    
    var evaluationArr = [DemoDatum]()
    var evaluatiomSkillModel:EvaluatiomSkillAlbumModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        self.tabBarController?.tabBar.isHidden = true
        if userID != 0 {
            hitEvaluationList(userId: userID)
        }
        apiCall = { [self] in
            if userID != 0 {
                hitEvaluationList(userId: userID)
            }
        }
        lbltitle.text = selectedTitle

    }
    @IBAction func btnRemarks(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Parent", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RemarkPopUPVC") as! RemarkPopUPVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func selectedClass(selectEvulationID: Int) {
        hitEvalutionFilterList(Id: selectEvulationID)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        if comesFrom != 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            let roleId = UserDefaults.standard.integer(forKey: myRoleId)
            if roleId == 4 {
                gotoHome()
            } else {
                gotoHomeTeacher()
            }
        }
    }
    
    @IBAction func filterBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectEvalutions") as! SelectEvalutions
        vc.delegate = self
        vc.userID = userID
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)
    }
    
    func hitEvaluationList(userId:Int){
        let param = ["userId":userId]
        ApiManager.shared.Request(type: DemoAlbumModel.self, methodType: .Get, url: baseUrl+evaluationList, parameter: param) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.evaluationArr = myObject?.data ?? []
                    if self.evaluationArr.count > 0 {
                        self.hitEvalutionFilterList(Id: self.evaluationArr.first?.id ?? 0)
                    }
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func hitEvalutionFilterList(Id:Int){
        let param = ["userId":userID]
        ApiManager.shared.Request(type: EvaluatiomSkillAlbumModel.self, methodType: .Get, url: baseUrl+eavluationfilterList + "\(Id)", parameter: param) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.evaluatiomSkillModel = myObject
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
}

extension DemoVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return evaluatiomSkillModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "DemoHeaderTVC") as! DemoHeaderTVC
        headerCell.lblStream.text = evaluatiomSkillModel?.data?[section].name ?? ""
        updateRatingViews(for: headerCell, with: evaluatiomSkillModel?.data?[section].skills ?? [])
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluatiomSkillModel?.data?[section].skills?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTVC") as! DemoTVC
        let subjects = evaluatiomSkillModel?.data?[indexPath.section].skills
        updateRatingViews(for: cell, with: subjects ?? [])
        
        evaluatiomSkillModel?.ratings?.forEach({ data in
            if Int(subjects?[indexPath.row].evolution?.remarkType ?? "") == data.id {
                switch subjects?[indexPath.row].evolution?.remarkType ?? "" {
                case "1":
                    cell.good.image = UIImage(named: "star")
                    cell.GoodRatingView.isHidden = false
                case "2":
                    cell.improving.image = UIImage(named: "star")
                    cell.improvingRatingView.isHidden = false
                case "3":
                    cell.bad.image = UIImage(named: "star")
                    cell.badRatingView.isHidden = false
                case "4":
                    cell.excellent.image = UIImage(named: "star")
                    cell.excelentRatingView.isHidden = false
                default:
                    print("")
                    cell.GoodRatingView.isHidden = true
                    cell.badRatingView.isHidden = true
                    cell.improvingRatingView.isHidden = true
                    cell.excelentRatingView.isHidden = true
                }
            }else{
                
            }
        })
        cell.lblSubject.text = subjects?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DemoVC{
    //Update cell
    func updateRatingViews(for cell: DemoTVC, with data: [Datum]) {
        let hasBadRemark = data.contains { skill in
            return skill.evolution?.remarkType == "3"
        }
        cell.badRatingView.isHidden = !hasBadRemark

        let hasGoodRemark = data.contains { skill in
            return skill.evolution?.remarkType == "1"
        }
        cell.GoodRatingView.isHidden = !hasGoodRemark

        let hasImproving = data.contains { skill in
            return skill.evolution?.remarkType == "2"
        }
        cell.improvingRatingView.isHidden = !hasImproving

        let hasExcellent = data.contains { skill in
            return skill.evolution?.remarkType == "4"
        }
        cell.excelentRatingView.isHidden = !hasExcellent
    }
    //Update header
    func updateRatingViews(for cell: DemoHeaderTVC, with data: [Datum]) {
        let hasBadRemark = data.contains { skill in
            return skill.evolution?.remarkType == "3"
        }
        cell.BadHeaderView.isHidden = !hasBadRemark

        let hasGoodRemark = data.contains { skill in
            return skill.evolution?.remarkType == "1"
        }
        cell.goodHeaderView.isHidden = !hasGoodRemark

        let hasImproving = data.contains { skill in
            return skill.evolution?.remarkType == "2"
        }
        cell.improvingHeaderView.isHidden = !hasImproving

        let hasExcellent = data.contains { skill in
            return skill.evolution?.remarkType == "4"
        }
        cell.excelentHeaderView.isHidden = !hasExcellent
    }
}
