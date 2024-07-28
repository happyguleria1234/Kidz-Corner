//
//  SelectEvalutions.swift
//  KidzCorner
//
//  Created by Happy Guleria on 22/07/24.
//

import UIKit

protocol SelectEvulation {
    func selectedClass(selectEvulationID: Int)
}

class SelectEvalutions: UIViewController {
    
    var userID = Int()
    var delegate: SelectEvulation?
    var evaluationArr = [DemoDatum]()
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var tableClasses: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hitEvaluationList(userId: userID)
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
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func bottomDismiss(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }
    
    func setupTable() {
        tableClasses.register(UINib(nibName: "ClassesCell", bundle: nil), forCellReuseIdentifier: "ClassesCell")
        tableClasses.delegate = self
        tableClasses.dataSource = self
    }
    
    func hitEvaluationList(userId:Int){
        let param = ["userId":userId]
        ApiManager.shared.Request(type: DemoAlbumModel.self, methodType: .Get, url: baseUrl+evaluationList, parameter: param) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.evaluationArr = myObject?.data ?? []
                    self.tableClasses.reloadData()
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
}

extension SelectEvalutions: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.evaluationArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesCell", for: indexPath) as! ClassesCell
        cell.labelName.text = evaluationArr[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false) { [weak self] in
            self?.delegate?.selectedClass(selectEvulationID: self?.evaluationArr[indexPath.row].id ?? 0)
        }
    }
}

