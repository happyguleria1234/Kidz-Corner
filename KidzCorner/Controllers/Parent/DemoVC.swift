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

class DemoVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var btnDrop: UIButton!
    // Convert demoArr to an array of Category structs
    var categories: [Category] = []
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
    var evaluationSkillArr = [DateElement]()
    var evalutionRatingArr = [Rating]()
    var EvaluatiomSkillModel:EvaluatiomSkillAlbumModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserTypeDropDown()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hitEvaluationList(userId: UserDefaults.standard.string(forKey: myUserid) ?? "")
    }
    
    //MARK: DropDown Functionality
    func setupUserTypeDropDown() {
        userTypeDropDown.anchorView = btnDrop
        userTypeDropDown.bottomOffset = CGPoint(x: 70, y: (btnDrop.bounds.height) - 10)
        userTypeDropDown.dataSource = self.evaluationArr.compactMap({ $0.name ?? "" })
        userTypeDropDown.selectionAction = { [weak self] (index, item) in
            self?.userTypeDropDown.hide()
            self?.evaluationArr.forEach({ data in
                if item == data.name {
                    self?.hitEvalutionFilterList(Id: data.id ?? 0, userID: UserDefaults.standard.string(forKey: myUserid) ?? "")
                }
            })
        }
    }
    
    func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            $0.customCellConfiguration = nil
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterBtn(_ sender: UIButton) {
        userTypeDropDown.show()
    }
    
    
    func hitEvaluationList(userId:String){
        let param = ["userId":userId]
        ApiManager.shared.Request(type: DemoAlbumModel.self, methodType: .Get, url: baseUrl+evaluationList, parameter: param) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.evaluationArr = myObject?.data ?? []
                    self.tblView.reloadData()
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func hitEvalutionFilterList(Id:Int,userID:String){
        ApiManager.shared.Request(type: EvaluatiomSkillAlbumModel.self, methodType: .Get, url: baseUrl+eavluationfilterList + "\(Id)?userId=\(userID)", parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.EvaluatiomSkillModel = myObject
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
}

extension DemoVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "DemoHeaderTVC") as! DemoHeaderTVC
        headerCell.lblStream.text = categories[section].name

            return headerCell
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].items.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTVC") as! DemoTVC
        let subjects = categories[indexPath.section]
        cell.lblSubject.text = subjects.items[indexPath.row]
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
