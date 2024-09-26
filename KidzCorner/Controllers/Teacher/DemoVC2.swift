//
//  DemoVC2.swift
//  KidzCorner
//
//  Created by Happy Guleria on 28/07/24.
//

import UIKit
import Kingfisher

class DemoVC2: UIViewController, SelectEvulation {
    
    @IBOutlet weak var tbl1Height: NSLayoutConstraint!
    @IBOutlet weak var tblList2: UITableView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblView2: NSLayoutConstraint!
    
    var userID = Int()
    var selectedTitle = String()
    var categories: [Category] = []
    var evaluationArr = [DemoDatum]()
    var remarksData = [RemarkModelDataList]()
    var evaluatiomSkillModel:EvaluatiomSkillAlbumModel?
    var demoArr: [String: [String]] = [
        "Arts": ["Drama", "Painting", "Drawing", "Dance"],
        "Arts 2": ["Drama", "Painting 2", "Drawing 2", "Dance 2"],
        "Arts 3": ["Drama 3", "Painting 3", "Drawing 3", "Dance 3"]]
    
    var dataCountSec = [[Int]]()

    //------------------------------------------------------
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbltitle.text = selectedTitle
        for (categoryName, items) in demoArr {
            let category = Category(name: categoryName, items: items)
            categories.append(category)
        }
        tblList2.delegate = self
        tblList2.delegate = self
        remarksData(studentID: userID)
        hitEvaluationList(userId: userID)
        tabBarController?.tabBar.isHidden = true
        tblList2.register(UINib(nibName: "RemarkPopUPCell", bundle: nil), forCellReuseIdentifier: "RemarkPopUPCell")
        tblList2.register(UINib(nibName: "SummaryCell", bundle: nil), forCellReuseIdentifier: "SummaryCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblList2.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        DispatchQueue.main.async {
            self.updateTableHeights()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableHeights()
        if #available(iOS 15.0, *) {
                tblList2.sectionHeaderTopPadding = 0
           
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tblView.removeObserver(self, forKeyPath: "contentSize")
        tblList2.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //MARK: - TABLE VIEW HEIGHT OBSERVER
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            updateTableHeights()
        }
    }
    
    private func updateTableHeights() {
        tbl1Height.constant = tblView.contentSize.height
        tblView2.constant = tblList2.contentSize.height
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
    
    func remarksData(studentID: Int) {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
                
        ApiManager.shared.Request(type: RemarkModelData.self, methodType: .Post, url: baseUrl + remarkComments, parameter: ["user_id": userID]) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.remarksData = myObject?.data ?? []
                DispatchQueue.main.sync {
                    self.tblList2.reloadData()
                }
            } else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    @IBAction func btnRemarks(_ sender: Any) {
        DispatchQueue.main.async { [self] in
            let storyboard = UIStoryboard(name: "Parent", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
            vc.userID = userID
            vc.comesFrom = "invoice"
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
        if tableView == tblView {
            return evaluatiomSkillModel?.data?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblView {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "DemoHeaderTVC") as! DemoHeaderTVC
            headerCell.lblStream.text = evaluatiomSkillModel?.data?[section].name ?? ""
            let ratings = evaluatiomSkillModel?.ratings ?? []
            headerCell.updateViewsWithRatings(ratings)
            return headerCell
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblView {
            return evaluatiomSkillModel?.data?[section].skills?.count ?? 0
        } else {
            return remarksData.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTVC") as! DemoTVC
            if let ratings = evaluatiomSkillModel?.ratings {
                configureWithRatings(ratings, forCell: cell, at: indexPath)
            }
            let subjects = evaluatiomSkillModel?.data?[indexPath.section].skills
            cell.lblSubject.text = subjects?[indexPath.row].name
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell") as! SummaryCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RemarkCells") as! RemarkCells
                let cellData = remarksData[indexPath.row - 1]
                cell.setData(listData: cellData)
                updateTableHeights()
                return cell
            }
        }
    }
    
    func configureWithRatings(_ ratings: [Rating], forCell cell: DemoTVC, at indexPath: IndexPath) {
        // Initially hide all views
        cell.GoodRatingView.isHidden = true
        cell.improvingRatingView.isHidden = true
        cell.badRatingView.isHidden = true
        cell.excelentRatingView.isHidden = true

        guard let subjects = evaluatiomSkillModel?.data?[indexPath.section].skills else { return }
        guard let subject = subjects[indexPath.row].evolution else { return }
        
        let remarkType = subject.remarkType ?? ""

        // Loop through the ratings and configure the cell views accordingly
        for rating in ratings {
            switch rating.name {
            case "Good":
                if remarkType == "1" {
                    cell.GoodRatingView.isHidden = false
                    cell.good.image = UIImage(named: "star")
                }
            case "Bad":
                if remarkType == "3" {
                    cell.badRatingView.isHidden = false
                    cell.bad.image = UIImage(named: "star")
                }
            case "Improvement":
                if remarkType == "2" {
                    cell.improvingRatingView.isHidden = false
                    cell.improving.image = UIImage(named: "star")
                }
            case "Excellent":
                if remarkType == "4" {
                    cell.excelentRatingView.isHidden = false
                    cell.excellent.image = UIImage(named: "star")
                }
            default:
                break
            }
        }
    }

    
//    func configureWithRatings(_ ratings: [Rating], forCell cell: DemoTVC, at indexPath: IndexPath) {
//        // Initially hide all views
//        cell.GoodRatingView.isHidden = true
//        cell.improvingRatingView.isHidden = true
//        cell.badRatingView.isHidden = true
//        cell.excelentRatingView.isHidden = true
//
//        let subjects = evaluatiomSkillModel?.data?[indexPath.section].skills
//
//        // Loop through the ratings and configure the cell views accordingly
//        for rating in ratings {
//            guard let subject = subjects?[indexPath.row].evolution else { continue }
//            
//            let remarkType = subject.remarkType ?? ""
//
//            switch rating.name {
//            case "Good":
//                if remarkType == "1" {
//                    cell.GoodRatingView.isHidden = false
//                    cell.good.image = UIImage(named: "star")
//                }
//            case "Bad":
//                if remarkType == "3" {
//                    cell.badRatingView.isHidden = false
//                    cell.bad.image = UIImage(named: "star")
//                }
//            case "Improvement":
//                if remarkType == "2" {
//                    cell.improvingRatingView.isHidden = false
//                    cell.improving.image = UIImage(named: "star")
//                }
//            case "Excellent":
//                if remarkType == "4" {
//                    cell.excelentRatingView.isHidden = false
//                    cell.excellent.image = UIImage(named: "star")
//                }
//            default:
//                break
//            }
//            
//            cell.GoodRatingView.isHidden = true
//            cell.badRatingView.isHidden = true
//            cell.improvingRatingView.isHidden = true
//            cell.excelentRatingView.isHidden = true
//            
//            // Loop through the ratings array and update views and labels based on rating name
//            for rating in ratings {
//                switch rating.name {
//                case "Good":
//                    cell.GoodRatingView.isHidden = false
//                case "Bad":
//                    cell.badRatingView.isHidden = false
//                case "Improvement":
//                    cell.improvingRatingView.isHidden = false
//                case "Excellent":
//                    cell.excelentRatingView.isHidden = false
//                default:
//                    break
//                }
//            }
//            
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblView{
            return UITableView.automaticDimension
         } else {
             return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return CGFloat.leastNormalMagnitude
    }
    
}


class RemarkCells: UITableViewCell {
    
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(listData: RemarkModelDataList) {
        lbl_title.text = listData.user?.name
        lbl_description.text = listData.description ?? ""
        let userProfileUrl = URL(string: imageBaseUrl+(listData.user?.image ?? ""))
        imgUser.kf.setImage(with: userProfileUrl)
    }
    
}

