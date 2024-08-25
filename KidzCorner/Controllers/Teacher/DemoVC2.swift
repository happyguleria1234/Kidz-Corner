//
//  DemoVC2.swift
//  KidzCorner
//
//  Created by Happy Guleria on 28/07/24.
//

import UIKit


class DemoVC2: UIViewController, SelectEvulation {
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    var userID = Int()
    var selectedTitle = String()
    var categories: [Category] = []
    var evaluationArr = [DemoDatum]()
    
    var evaluatiomSkillModel:EvaluatiomSkillAlbumModel?
    var demoArr: [String: [String]] = [
        "Arts": ["Drama", "Painting", "Drawing", "Dance"],
        "Arts 2": ["Drama", "Painting 2", "Drawing 2", "Dance 2"],
        "Arts 3": ["Drama 3", "Painting 3", "Drawing 3", "Dance 3"]]
    
//    var dataCountSec = [[1,1,1,1] , [1,0,1,0] , [0,0,0,1]]
    var dataCountSec = [[Int]]()

    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        lbltitle.text = selectedTitle
        for (categoryName, items) in demoArr {
            let category = Category(name: categoryName, items: items)
            categories.append(category)
        }
        hitEvaluationList(userId: userID)
        tabBarController?.tabBar.isHidden = true
    }
    
    func selectedClass(selectEvulationID: Int) {
        hitEvalutionFilterList(Id: selectEvulationID)
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
    
    func hitEvalutionFilterList(Id: Int) {
        let param = ["userId": userID]
        ApiManager.shared.Request(type: EvaluatiomSkillAlbumModel.self, methodType: .Get, url: baseUrl + eavluationfilterList + "\(Id)", parameter: param) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.evaluatiomSkillModel = myObject

                    // Safely unwrap the optional array
                    if let categories = self.evaluatiomSkillModel?.data {
                        // Initialize dataCountSec with the appropriate dimensions
                        self.dataCountSec = categories.map { category in
                            return Array(repeating: 0, count: category.skills?.count ?? 0)
                        }

                        for (categoryIndex, category) in categories.enumerated() {
                            if let skills = category.skills {
                                for (skillIndex, skill) in skills.enumerated() {
                                    if let evolution = skill.evolution {
                                        // Check if evolution.remark_type matches any rating object ID
                                        if let ratings = myObject?.ratings {
                                            for rating in ratings {
                                                if evolution.remarkType == "\(rating.id ?? 0)" {
                                                    // Ensure categoryIndex and skillIndex are within bounds
                                                    if categoryIndex < self.dataCountSec.count &&
                                                       skillIndex < self.dataCountSec[categoryIndex].count {
                                                        self.dataCountSec[categoryIndex][skillIndex] = 1
                                                    }
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    self.tblView.reloadData()
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    @IBAction func btnRemarks(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Parent", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RemarkPopUPVC") as! RemarkPopUPVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: TABLE VIEW DELEGATE AND DATA SOURCES
extension DemoVC2: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return evaluatiomSkillModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "DemoHeaderTVC") as! DemoHeaderTVC
        headerCell.lblStream.text = evaluatiomSkillModel?.data?[section].name ?? ""
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluatiomSkillModel?.data?[section].skills?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTVC") as! DemoTVC
        let subjects = evaluatiomSkillModel?.data?[indexPath.section].skills
        evaluatiomSkillModel?.ratings?.forEach({ data in
            print("VALUE ********* ",subjects?[indexPath.row].evolution?.remarkType ?? "")
            let value = subjects?[indexPath.row].evolution?.remarkType ?? ""
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
                case "":
                    print("")
                    cell.GoodRatingView.isHidden = true
                    cell.badRatingView.isHidden = true
                    cell.improvingRatingView.isHidden = true
                    cell.excelentRatingView.isHidden = true
                default:
                    print("")
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
