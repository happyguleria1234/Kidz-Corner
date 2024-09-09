//
//  MedicationVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 08/09/24.
//


import UIKit
import Foundation

class MedicationVC : UIViewController {
    
    //------------------------------------------------------
    
    //MARK: Variables and Outlets
    
    @IBOutlet weak var tbl_height: NSLayoutConstraint!
    @IBOutlet weak var page_control: UIPageControl!
    @IBOutlet weak var coll_childs: UICollectionView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var txt_remarks: UITextView!
    
    var tableData: [String] = [] // Data source for the table view
    var childrenData = [ChildData]()

    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit {
        //same like dealloc in ObjectiveC
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Function
    
    func setData() {
        tblList.delegate = self
        tblList.dataSource = self
        coll_childs.delegate = self
        coll_childs.dataSource = self
        tblList.register(UINib(nibName: "MedicationCell", bundle: nil), forCellReuseIdentifier: "MedicationCell")
        tableData = ["Cell 1"]
        page_control.numberOfPages = 3
        coll_childs.isPagingEnabled = true
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnAddCells(_ sender: Any) {
        tableData.append("New Cell \(tableData.count + 1)")
        tblList.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendChildsMedication(_ sender: Any) {
        // add Validations
        let medicationData = getAllMedicationData()
        
        let params: [String: Any] = [
            "user_id": "5291",
            "name": medicationData.map { $0["name"] ?? "" },
            "date": medicationData.map { $0["date"] ?? "" },
            "how_many_time_day": medicationData.map { $0["how_many_time_day"] ?? "" },
            "before_lunch": medicationData.map { $0["before_lunch"] ?? "" },
            "after_lunch": medicationData.map { $0["after_lunch"] ?? "" },
            "remark": txt_remarks.text ?? ""
        ]
        
        // Send data to API
        sendChildsMedicationData(params: params)    }
        
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        getAllChildsAPI()
    }
        
    //------------------------------------------------------

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tblList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    //------------------------------------------------------
    
    //MARK: Table Height
        
    override func viewWillDisappear(_ animated: Bool) {
        tblList.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        coll_childs.collectionViewLayout.invalidateLayout()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                tbl_height.constant = newsize.height
            }
        }
    }
    
    //------------------------------------------------------
    
    // MARK: Functions
    func getAllChildsAPI() {
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.childrenData = myObject?.data ?? []
                   // self.getChildDetailsApi(date: Date().shortDate, childId: self.childrenData.first?.id)
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func getAllMedicationData() -> [[String: Any]] {
        var dataArray: [[String: Any]] = []
        
        for cell in tblList.visibleCells {
            if let medicationCell = cell as? MedicationCell {
                let cellData = medicationCell.getData()
                dataArray.append(cellData)
            }
        }
        
        return dataArray
    }
 

    func sendChildsMedicationData(params: [String: Any]) {
        for row in 0..<tableData.count {
            let indexPath = IndexPath(row: row, section: 0)
            
            // Safely get the cell at the given index path
            guard let medicationCell = tblList.cellForRow(at: indexPath) as? MedicationCell else {
                // Skip this iteration if the cell cannot be cast
                continue
            }
            
            // Validate the cell
            if !validateMedicationCell(medicationCell) {
                return
            }
        }
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Post, url: baseUrl+apiChildMedication, parameter: params) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    // Handle success
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }

    func validateMedicationCell(_ cell: MedicationCell) -> Bool {
        var isValid = true
        
        if cell.tf_name.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            Toast.toast(message: "Please fill in the name.", controller: self)
            isValid = false
        }
        
        if cell.tf_date.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            Toast.toast(message: "Please fill in the date.", controller: self)
            isValid = false
        }
        
        if cell.tf_day.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            Toast.toast(message: "Please fill in the number of days.", controller: self)
            isValid = false
        }
        
        if !cell.btn_before.isSelected && !cell.btn_after.isSelected {
            Toast.toast(message: "Please select at least one of before or after lunch.", controller: self)
            isValid = false
        }
        
        return isValid
    }

    
}

extension MedicationVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildCell", for: indexPath) as! ChildCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        page_control.currentPage = Int(pageIndex)
    }
    
}

extension MedicationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationCell", for: indexPath) as! MedicationCell
        cell.btnDelete.isHidden = (tableData.count == 1)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteCell(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    @objc func deleteCell(_ sender: UIButton) {
        let index = sender.tag
        tableData.remove(at: index)
        tblList.reloadData()
    }
}


class ChildCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_class: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var img_user: UIImageView!

    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

