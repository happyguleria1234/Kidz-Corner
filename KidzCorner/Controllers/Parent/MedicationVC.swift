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
    var studentID = Int()
//    var datePickerHandler: DatePickerHandler!
    
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
        page_control.numberOfPages = childrenData.count
        coll_childs.isPagingEnabled = true
        tabBarController?.tabBar.isHidden = true
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
        showIndicator()
        let medicationData = getAllMedicationData()
        var stuArr = [Int]()
//        stuArr.append(studentID)
        
        let params: [String: Any] = [
            "user_id[]": [studentID],
            "name[]": medicationData.map { $0["name"] ?? "" },
            "date[]": medicationData.map { $0["date"] ?? "" },
            "how_many_time_day[]": medicationData.map { $0["how_many_time_day"] ?? "" },
            "before_lunch[]": medicationData.map { $0["before_lunch"] ?? "" },
            "after_lunch[]": medicationData.map { $0["after_lunch"] ?? "" },
            "remark": txt_remarks.text ?? ""
        ]

        print("params is here *******", params)

        var parameters: [[String: Any]] = []

        for (key, value) in params {
            if let values = value as? [String] {
                for val in values {
                    parameters.append([
                        "key": key,
                        "value": val,
                        "type": "text"
                    ])
                }
            } else if let intValues = value as? [Int] { // Handling integer arrays like user_id[]
                for intVal in intValues {
                    parameters.append([
                        "key": key,
                        "value": "\(intVal)", // Converting int to string for API format
                        "type": "text"
                    ])
                }
            } else {
                parameters.append([
                    "key": key,
                    "value": "\(value)", // Handling other non-array values
                    "type": "text"
                ])
            }
        }
        // Generate boundary string using a unique per-app string
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        
        for param in parameters {
            let paramName = param["key"] as! String
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(paramName)\"\r\n".data(using: .utf8)!)
            
            if let contentType = param["contentType"] as? String {
                body.append("Content-Type: \(contentType)\r\n".data(using: .utf8)!)
            }
            
            let paramType = param["type"] as! String
            if paramType == "text" {
                let paramValue = param["value"] as! String
                body.append("\r\n\(paramValue)\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let postData = body
        
        // Set up URL request
        let url = URL(string: "https://kidzcorner.live/api/medication")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        // Setting up Basic Authentication if USERNAME and PASSWORD are provided
        let USERNAME = "yourUsername" // Replace with actual USERNAME
        let PASSWORD = "yourPassword" // Replace with actual PASSWORD
        
        if !USERNAME.isEmpty {
            let loginString = "\(USERNAME):\(PASSWORD)"
            guard let loginData = loginString.data(using: .utf8) else {
                return
            }
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }
        
        // Setting up Bearer Token if available
        if let myToken = UserDefaults.standard.string(forKey: "myToken") {
            request.setValue("Bearer \(myToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Setting Content-Type header
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Execute the request
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.stopIndicator()
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self?.showAlert(message: "An error occurred: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    self?.showAlert(message: "No data received from the server.")
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                    
                    // Show a success message and pop the view controller
                    self?.showAlert(message: "Data added successfully!") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self?.showAlert(message: "Failed to parse response.")
                }
            }
        }
        
        task.resume()
    }

    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        // Assuming you are calling this from a view controller
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
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
        // Validate all medication cells
        for row in 0..<tableData.count {
            let indexPath = IndexPath(row: row, section: 0)
            guard let medicationCell = tblList.cellForRow(at: indexPath) as? MedicationCell else {
                continue
            }
            
            if !validateMedicationCell(medicationCell) {
                return
            }
        }
        
        // Convert params to the required format for the requestWithSingle function
        let formattedParams: [[String: Any]] = params.map { key, value in
            var finalValue: String
            
            if let valueArray = value as? [String] {
                // Join array values into a single string
                finalValue = valueArray.joined(separator: ", ")
            } else {
                // Use value as is, assuming it's already a string
                finalValue = "\(value)"
            }
            
            return [
                "key": key,
                "value": finalValue,
                "type": "text" // Assuming all parameters are text; adjust if needed
            ]
        }
        
        // Send the API request
        ApiManager.shared.requestWithSingle(
            type: MedicalModel.self,
            url: baseUrl + apiChildMedication,
            parameters: formattedParams
        ) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    // Handle success
                    print("Medication data sent successfully")
                } else {
                    Toast.show(message: error?.localizedDescription ?? "Something went wrong", controller: self, color: .red)
                }
            }
        }
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
                    self.studentID = childrenData.first?.studentProfile?.userID ?? 0
                    self.coll_childs.reloadData()
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
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

extension MedicationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        // Make the cell take the full width of the collection view
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row < childrenData.count {
            self.studentID = childrenData[indexPath.item].studentProfile?.userID ?? 0
            print("its studentID ***", studentID)
        } else {
            print("Index out of range")
        }
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
        openDatePicker { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = formatter.string(from: date)
            cell.tf_date.text = formattedDate
            print(date, "Formatted Date: \(formattedDate)")
        }
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

