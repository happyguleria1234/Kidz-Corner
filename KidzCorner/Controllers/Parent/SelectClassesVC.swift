//
//  SelectClassesVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 10/08/24.
//

import UIKit

protocol SelectClasses {
    func selectedClasses(selectedEvaluationIDs: [Int])
}

class SelectClassesVC: UIViewController {
    
    var userID = Int()
    var delegate: SelectClasses?
    
    var evaluationArr: AllClassesModel?
    var selectedEvaluationIDs = [Int]()
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var tableClasses: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        getClasses()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableClasses.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    //  MARK: Tabel Height
    
    override func viewWillDisappear(_ animated: Bool) {
        tableClasses.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                tblHeight.constant = newsize.height
            }
        }
    }
    
    @IBAction func topDismiss(_ sender: Any) {
        self.dismiss(animated: false) { [weak self] in
            self?.delegate?.selectedClasses(selectedEvaluationIDs: self?.selectedEvaluationIDs ?? [])
        }
    }
    
    @IBAction func bottomDismiss(_ sender: Any) {
        self.dismiss(animated: false) { [weak self] in
            self?.delegate?.selectedClasses(selectedEvaluationIDs: self?.selectedEvaluationIDs ?? [])
        }
    }
    
    func setupTable() {
        tableClasses.delegate = self
        tableClasses.dataSource = self
        tableClasses.register(UINib(nibName: "ClassesCell", bundle: nil), forCellReuseIdentifier: "ClassesCell")
    }
    
    func getClasses() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        let params = [String: String]()
        ApiManager.shared.Request(type: AllClassesModel.self, methodType: .Get, url: baseUrl+apiGetAllClasses, parameter: params) { [self] error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.evaluationArr = myObject
                DispatchQueue.main.async { [self] in
                    tableClasses.reloadData()
                }
            }
            else {
               printt("Error fetching classes")
            }
        }
    }
    
}

extension SelectClassesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.evaluationArr?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesCell", for: indexPath) as! ClassesCell
        let data = self.evaluationArr?.data?[indexPath.row]
        cell.labelName.text = data?.name ?? ""
        if selectedEvaluationIDs.contains(data?.id ?? 0) {
            cell.contentView.backgroundColor = UIColor.white
            cell.labelName.textColor = UIColor.black
        } else {
            cell.contentView.backgroundColor = UIColor(named: "gradientBottom")!
            cell.labelName.textColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedID = self.evaluationArr?.data?[indexPath.row].id
        if let index = selectedEvaluationIDs.firstIndex(of: selectedID ?? 0) {
            selectedEvaluationIDs.remove(at: index)
        } else {
            selectedEvaluationIDs.append(selectedID ?? 0)
        }
        tableView.reloadData()
    }
}
