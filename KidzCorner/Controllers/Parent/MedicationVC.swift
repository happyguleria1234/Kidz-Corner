//
//  MedicationVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 08/09/24.
//


import UIKit
import DropDown
import Foundation

class MedicationVC : UIViewController {
    
    //------------------------------------------------------
    
    //MARK: Variables and Outlets
    
    @IBOutlet weak var tbl_height: NSLayoutConstraint!
    @IBOutlet weak var page_control: UIPageControl!
    @IBOutlet weak var coll_childs: UICollectionView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var txt_remarks: UITextView!
    
    let dropDown = DropDown()
    var tableData: [String] = []
    var childrenData = [ChildData]()
    var datePickerHandler: DatePickerHandler!

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
        sendChildsMedicationData(params: params)
    }
        
    
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
        showIndicator()
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { [self] error, myObject, msgString, statusCode in
            stopIndicator()
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.childrenData = myObject?.data ?? []
                    self.coll_childs.reloadData()
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
 
    
    private func showIndicator() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
    }
    
    private func stopIndicator() {
        DispatchQueue.main.async {
            stopAnimating()
        }
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
        var jsonStr = String()
        print(params)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON String: \(jsonString)")
                jsonStr = jsonString
            }
        } catch {
            print("Error converting dictionary to JSON: \(error.localizedDescription)")
        }
        
        ApiManager.shared.Request(type: BaseModel.self, methodType: .Post, url: baseUrl+apiChildMedication, parameter: params) { error, myObject, messageStr, statusCode in
            debugPrint(error)
            if statusCode == 200 {
                print(myObject)
            } else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
        
//        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Post, url: baseUrl+apiChildMedication, parameter: params) { error, myObject, msgString, statusCode in
//            DispatchQueue.main.async {
//                if statusCode == 200 {
//                    // Handle success
//                } else {
//                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
//                }
//            }
//        }
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
        return childrenData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildCell", for: indexPath) as! ChildCell
        cell.lbl_name.text = childrenData[indexPath.row].name?.uppercased()
        cell.lbl_class.text = childrenData[indexPath.row].studentProfile?.className?.name
        if let userProfileUrlString = childrenData[indexPath.row].image,
           let userProfileUrl = URL(string: imageBaseUrl + userProfileUrlString) {
            cell.img_user.kf.setImage(with: userProfileUrl)
        }
        cell.img_user.contentMode = .scaleAspectFill
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

extension MedicationVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationCell", for: indexPath) as! MedicationCell
        cell.btnDelete.isHidden = (tableData.count == 1)
        
        // Set up the tag for identifying the row
        cell.btnDelete.tag = indexPath.row
        cell.btn_day.tag = indexPath.row
        cell.btn_before.tag = indexPath.row
        cell.btn_after.tag = indexPath.row
        cell.btnDate.tag = indexPath.row
        
        // Add actions for buttons
        cell.btnDate.addTarget(self, action: #selector(showDatePicker(_:)), for: .touchUpInside)
        cell.btn_day.addTarget(self, action: #selector(loadNumbersOfDay(_:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(deleteCell(_:)), for: .touchUpInside)
        
        // Add actions for before and after buttons
        cell.btn_before.addTarget(self, action: #selector(toggleBeforeButton(_:)), for: .touchUpInside)
        cell.btn_after.addTarget(self, action: #selector(toggleAfterButton(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    @objc func toggleBeforeButton(_ sender: UIButton) {
        let index = sender.tag
        guard let cell = tblList.cellForRow(at: IndexPath(row: index, section: 0)) as? MedicationCell else { return }

        if cell.btn_before.isSelected {
            // If 'Before' is already selected, unselect it
            cell.btn_before.isSelected = false
        } else {
            // Select 'Before' and unselect 'After'
            cell.btn_before.isSelected = true
            cell.btn_after.isSelected = false
        }
    }

    @objc func toggleAfterButton(_ sender: UIButton) {
        let index = sender.tag
        guard let cell = tblList.cellForRow(at: IndexPath(row: index, section: 0)) as? MedicationCell else { return }

        if cell.btn_after.isSelected {
            // If 'After' is already selected, unselect it
            cell.btn_after.isSelected = false
        } else {
            // Select 'After' and unselect 'Before'
            cell.btn_after.isSelected = true
            cell.btn_before.isSelected = false
        }
    }

    @objc func deleteCell(_ sender: UIButton) {
        let index = sender.tag
        tableData.remove(at: index)
        tblList.reloadData()
    }

    @objc func loadNumbersOfDay(_ sender: UIButton) {
        guard let indexPath = getIndexPath(for: sender) else { return }
        let cell = tblList.cellForRow(at: indexPath) as! MedicationCell
        
        dropDown.dataSource = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        dropDown.anchorView = sender
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            cell.tf_day.text = item
        }
        dropDown.direction = .bottom
        dropDown.show()
    }
    
    @objc func showDatePicker(_ sender: UIButton) {
        guard let indexPath = getIndexPath(for: sender) else { return }
        let cell = tblList.cellForRow(at: indexPath) as! MedicationCell

        // Assuming DatePickerHandler handles the presentation of date picker
        let datePickerHandler = DatePickerHandler(parentView: self.view, textField: cell.tf_day)
        
        // Set up the callback for when the date is selected
        datePickerHandler.onDateSelected = { [weak self] selectedDate in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium // You can customize the date format here
            let formattedDate = formatter.string(from: selectedDate)
            cell.tf_day.text = formattedDate
        }
        
        // Optionally, handle the cancel or done button actions in DatePickerHandler
        datePickerHandler.showDatePicker() // Assuming showDatePicker() presents the date picker
    }

    func getIndexPath(for sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tblList)
        return tblList.indexPathForRow(at: buttonPosition)
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

