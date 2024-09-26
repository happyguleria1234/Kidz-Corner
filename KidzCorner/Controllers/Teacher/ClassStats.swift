import UIKit
import DropDown
import AVFoundation

class ClassStats: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private var datePicker = UIDatePicker()
    private var doneButton = UIButton()
    
    var isPickerPresented: Bool = false
    
    let dropDown = DropDown()
    
    var classAttendance: ClassAttendanceModel?
    var classesData: AllClassesModel?
    let session = AVCaptureSession()
    var statHeader: String = "Temperature"
    var stat1: String = "Temp 1"
    var stat2: String = "Temp 2"
    
    var typeSelection: Int = 0
    
    var classId: Int?
    
    var currentDate: String = Date().shortDate
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var labelClassName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonDate: UIButton!
    @IBOutlet weak var tableStats: UITableView!
    @IBOutlet weak var buttonClasses: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        let myClass = UserDefaults.standard.integer(forKey: myClass)
        if myClass != 0 {
            self.classId = myClass
            getAttendance(classId: self.classId ?? 0, date: currentDate)
        } else {
            getClasses()
        }
    }
    
    // MARK: - Constants

    private enum Constants {
      static let alertTitle = "Scanning is not supported"
      static let alertMessage = "Your device does not support scanning a code from an item. Please use a device with a camera."
      static let alertButtonTitle = "OK"
    }

    // MARK: - set up camera

    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()

            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            session.addInput(input)
            session.addOutput(output)
            
            output.metadataObjectTypes = [.qr]
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            
            view.layer.addSublayer(previewLayer)
            
            session.startRunning()
        } catch {

            showAlert()
            print(error)
        }
    }

    // MARK: - Alert

    func showAlert() {
            let alert = UIAlertController(title: Constants.alertTitle,
                                          message: Constants.alertMessage,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.alertButtonTitle,
                                          style: .default))
            present(alert, animated: true)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {

            guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                      metadataObject.type == .qr,
                      let stringValue = metadataObject.stringValue else { return }
            
            print(stringValue)
        }
    
    @IBAction func bluetoothFunc(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Devices") {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func classesFunc(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectClass") as! SelectClass
        
        vc.classes = self.classesData
        vc.delegate = self
        
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false, completion: {
            
        })
    }
    
    
    @IBAction func qrScannerBtn(_ sender: UIButton) {
        let vc = ScannerViewController()
        vc.callBack = { userData in
            self.getClasses()
            self.getClassesNew(userID: userData.id,classID: userData.classes)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getStudentData(userID: Int,classID:[Int]) {
        ApiManager.shared.Request(type: StudentDataScanner.self, methodType: .Get, url: baseUrl+"student/\(userID)/profile", parameter: [:]) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async { [self] in
                    var isAdded = false
                    for i in 0..<classID.count {
                        for j in 0..<(classesData?.data?.count ?? 0) {
                            if classID[i] == classesData?.data?[j].id {
                                isAdded = true
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeacherPortfolio") as! TeacherPortfolio
                                vc.studentId = myObject?.data?.id ?? 0
                                vc.studentName = myObject?.data?.name ?? ""
                                vc.studentImage = myObject?.data?.image ?? ""
                                myObject?.data?.assignedStudentClasses?.forEach({ assignedClass in
                                    if classID.contains(assignedClass.pivot?.classID ?? 0) {
                                        vc.studentClass = assignedClass.name ?? ""
                                    }
                                })
                                vc.tempMorning = myObject?.data?.studentAttendace?.morningTemp ?? ""
                                vc.tempEvening = myObject?.data?.studentAttendace?.eveningTemp ?? ""
                                vc.middleTemperature = myObject?.data?.studentAttendace?.eveningTemp ?? ""
                                vc.timeIn = myObject?.data?.studentAttendace?.timeIn ?? ""
                                vc.timeOut = myObject?.data?.studentAttendace?.timeOut ?? ""
                                self.navigationController?.pushViewController(vc, animated: true)
                                break
                            }
                        }
                        if isAdded {
                            break
                        }
                    }

                    if !isAdded {
                        Toast.show(message: "Class not assigned to you.", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: UIColor.red)
                    }
                }
            }
            else {
                printt("Error fetching classes")
            }
        }
    }
    
    @IBAction func changeClassFunc(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectClass") as! SelectClass
//
//        vc.classes = self.classesData
//        vc.delegate = self
//
//        vc.modalPresentationStyle = .overFullScreen
//        self.navigationController?.present(vc, animated: false, completion: {
//
//        })
        
    }
    
    func getClasses() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        let params = [String: String]()
        ApiManager.shared.Request(type: AllClassesModel.self, methodType: .Get, url: baseUrl+apiGetAllClasses, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.classesData = myObject
                UserDefaults.standard.setValue(myObject?.data?[0].id, forKey: myClass)
                
                self.classId = myObject?.data?[0].id
                
                self.getAttendance(classId: myObject?.data?[0].id ?? 0, date: self.currentDate)
                
            }
            else {
               printt("Error fetching classes")
            }
        }
    }
    
    
    func getClassesNew(userID: Int,classID:[Int]) {
        let params = [String: String]()
        ApiManager.shared.Request(type: AllClassesModel.self, methodType: .Get, url: baseUrl+apiGetAllClasses, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.classesData = myObject
                self.getStudentData(userID: userID,classID: classID)
            }
            else {
               printt("Error fetching classes")
            }
        }
    }
    
    func setupTable() {
        tableStats.register(UINib(nibName: "StatsHeader", bundle: nil), forCellReuseIdentifier: "StatsHeader")
        tableStats.register(UINib(nibName: "StatsCell", bundle: nil), forCellReuseIdentifier: "StatsCell")
        tableStats.delegate = self
        tableStats.dataSource = self
        tableStats.backgroundColor = .clear
    }
    
    func setupViews() {
        labelDate.text = "(\(Date().shortDate))"
        buttonDate.addTarget(self, action: #selector(dateSelected), for: .touchUpInside)
        
        dropDown.dismissMode = .onTap
        
        dropDown.anchorView = gradientView
        dropDown.bottomOffset = CGPoint(x: 0, y: gradientView.bounds.height)
        
        dropDown.dataSource = ["Temperature","Attendance"]
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.statHeader = item
            self?.typeSelection = index
            if index == 0 {
                self?.stat1 = "Temp 1"
                self?.stat2 = "Temp 2"
            }
            else if index == 1 {
                self?.stat1 = "Time In"
                self?.stat2 = "Time Out"
            }
            
            DispatchQueue.main.async {
                self?.tableStats.reloadData()
            }
        }
    }
    
    func getAttendance1(classId: Int,date: String) {
        var params = [String: Any]()
        params = ["date": date,
                  "class_id": String(classId)]
        
        ApiManager.shared.Request(type: ClassAttendanceModel.self, methodType: .Get, url: baseUrl+apiClassAttendance, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async { [self] in
                    self.classAttendance = myObject
                    tableStats.reloadData()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
   
    func getAttendance(classId: Int,date: String) {
        var params = [String: Any]()
        params = ["date": date,
                  "class_id": String(classId)]
        
        ApiManager.shared.Request(type: ClassAttendanceModel.self, methodType: .Get, url: baseUrl+apiClassAttendance, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async { [self] in
                    self.classAttendance = myObject
                    tableStats.reloadData()
                    if myObject?.data?.count != 0 {
                        self.labelClassName.text = myObject?.data?[0].className?.name ?? ""
                    }
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    @objc func selection(sender: UIButton) {
        dropDown.show()
    }
    
    @objc func dateSelected(sender: UIButton) {
        if isPickerPresented {
            isPickerPresented = false
            self.datePicker.removeFromSuperview()
            self.doneButton.removeFromSuperview()
        } else {
            showPicker()
        }
    }
    
    func showPicker() {
        isPickerPresented = true
        let picker : UIDatePicker = datePicker
        picker.textColor = .black
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
        }
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        let size = self.view.frame.size
        picker.frame = CGRect(x: 0.0, y: size.height/2.0 + 100, width: size.width, height: 200)
        picker.backgroundColor = UIColor.white
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = UIColor(named: "gradientBottom")
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)
        doneButton.frame = CGRect(x: self.view.right-70, y: picker.top, width: 70.0, height: 37.0)
        
        self.view.addSubview(picker)
        self.view.addSubview(doneButton)
    }
    
    @objc func dismissPicker(sender: UIButton) {
        isPickerPresented = false
        doneButton.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateStyle = .long
        displayDateFormatter.timeStyle = .none
        displayDateFormatter.dateFormat = "dd MMMM yyyy"
        
        let actualDateFormatter = DateFormatter()
        actualDateFormatter.dateStyle = .long
        actualDateFormatter.timeStyle = .none
        actualDateFormatter.dateFormat = "dd-MM-yyyy"
        
        labelDate.text = "(\(actualDateFormatter.string(from: sender.date)))"
   
        currentDate = actualDateFormatter.string(from: sender.date)
    
        //Use actual Date to get attendance for that date
        getAttendance(classId: self.classId ?? 0, date: actualDateFormatter.string(from: sender.date))
    }
}

extension ClassStats: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classAttendance?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let indx = IndexPath(row: 0, section: section)
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsHeader", for: indx) as! StatsHeader
        
        cell.buttonStat.addTarget(self, action: #selector(selection), for: .touchUpInside)
        
        cell.labelStat.text = statHeader
        cell.labelStat1.text = stat1
        cell.labelStat2.text = stat2
        
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath) as! StatsCell
        let data = self.classAttendance?.data?[indexPath.row]

        cell.labelName.text = data?.name ?? ""
        cell.imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(data?.image ?? "")), placeholderImage: .placeholderImage)
        
        if typeSelection == 0 {
            
            if let morningTemperature = data?.attendance?.morningTemp {
                cell.labelStatOne.text = "\(morningTemperature)"
            }
            else {
                cell.labelStatOne.text = "-"
            }
            if let eveningTemperature = data?.attendance?.eveningTemp {
                cell.labelStatTwo.text = "\(eveningTemperature)"
            } else {
                cell.labelStatTwo.text = "-"
            }
            if data?.attendance?.thirdTemperature != nil {
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = .black
                printt("Third \(data?.attendance?.thirdTemperature)")
            } else {
                cell.accessoryType = .none
            }
        }
        else if typeSelection == 1 {
            cell.accessoryType = .none
            cell.labelStatOne.text = data?.attendance?.timeIn ?? "Absent"
            
            if cell.labelStatOne.text == "Absent" {
                cell.labelStatTwo.text = data?.attendance?.timeOut ?? "Absent"
            }
            else {
            cell.labelStatTwo.text = data?.attendance?.timeOut ?? "-"
        }
        }
        cell.viewOuter.shadowWithRadius(radius: 10)
        cell.backgroundColor = .clear
        return cell
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        let touch = touches.first
//        if touch?.view != datePicker.superview {
//            if !datePicker.isHidden {
//                print("Hiding Date Picker")
//                datePicker.isHidden = true
//            }
//        }
//        self.view.endEditing(true)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeacherPortfolio") as! TeacherPortfolio
        
        let data = self.classAttendance?.data?[indexPath.row]
        vc.studentId = data?.id ?? 0
        vc.studentName = data?.name ?? ""
        vc.studentClass = data?.className?.name ?? ""
        printt("ClassID \(self.classId ?? -1)")
        vc.classId = self.classId ?? 0
        vc.studentImage = data?.image ?? ""
        
        vc.tempMorning = data?.attendance?.morningTemp ?? ""
        vc.tempEvening = data?.attendance?.eveningTemp ?? ""
        vc.middleTemperature = data?.attendance?.thirdTemperature ?? ""
        
        vc.timeIn = data?.attendance?.timeIn ?? ""
        vc.timeOut = data?.attendance?.timeOut ?? ""
    
        self.navigationController?.pushViewController(vc, animated: true)
        }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if self.classAttendance?.data?[indexPath.row].attendance?.thirdTemperature != nil {
            return true
        }
        else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if let thirdTemperature = self.classAttendance?.data?[indexPath.row].attendance?.thirdTemperature {
            
            let contextItem = UIContextualAction(style: .normal, title: "Temp 3 \n \(thirdTemperature)") {  (contextualAction, view, boolValue) in
                view.backgroundColor = UIColor(named: "gradientTop")
                view.layer.cornerRadius = 10
                
                //Code I want to do here
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
        } else {
            return nil
        }
    }
}

extension ClassStats: classSelected {
    func selectedClass(classId: Int, className: String) {
        DispatchQueue.main.async { [self] in
            labelClassName.text = className
            UserDefaults.standard.setValue(classId, forKey: myClass)
            self.classId = classId
            getAttendance1(classId: self.classId ?? 0, date: currentDate)
        }
    }
}



// MARK: - MedicalModel
struct StudentDataScanner: Codable {
    let status: Int?
    let message: String?
    let data: StudentDataScannerDataClass?
}

// MARK: - DataClass
struct StudentDataScannerDataClass: Codable {
    let id: Int?
    let toyyibpayUsername, toyyibpaySecret, toyyibpayCategory, facebookAccessToken: String?
    let classID, activeChildID: Int?
    let name: String?
    let quickbooksID: Int?
    let createdBy: Int?
    let status: String?
    let roleID: Int?
    let email, emailVerifiedAt: String?
    let image, document, address: String?
    let contactNumber: String?
    let gender: String?
    let islogin: Int?
    let userLoginType, adminApprove: String?
    let createdAt: String?
    let updatedAt, userStatus, chatToken: String?
    let active: Int?
    let dob: String?
    let leavePlanID: Int?
    let deviceToken: String?
    let deviceType, assignedForm, countryID: Int?
    let assignSchools: String?
    let isChat: Int?
    let selectedYear, showSchoolToHeadquarter, supervisorMenu, idCardNo: String?
    let lastLogin: String?
    let studentAttendace: StudentDataScannerStudentAttendace?
    let assignedStudentClasses: [StudentDataScannerAssignedStudentClass]?

    enum CodingKeys: String, CodingKey {
        case id
        case toyyibpayUsername = "toyyibpay_username"
        case toyyibpaySecret = "toyyibpay_secret"
        case toyyibpayCategory = "toyyibpay_category"
        case facebookAccessToken = "facebook_access_token"
        case classID = "class_id"
        case activeChildID = "active_child_id"
        case name
        case quickbooksID = "quickbooks_id"
        case createdBy = "created_by"
        case status
        case roleID = "role_id"
        case email
        case emailVerifiedAt = "email_verified_at"
        case image, document, address
        case contactNumber = "contact_number"
        case gender, islogin
        case userLoginType = "user_login_type"
        case adminApprove = "admin_approve"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userStatus = "user_status"
        case chatToken = "chat_token"
        case active, dob
        case leavePlanID = "leave_plan_id"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case assignedForm = "assigned_form"
        case countryID = "country_id"
        case assignSchools = "assign_schools"
        case isChat = "is_chat"
        case selectedYear = "selected_year"
        case showSchoolToHeadquarter = "show_school_to_headquarter"
        case supervisorMenu = "supervisor_menu"
        case idCardNo = "id_card_no"
        case lastLogin = "last_login"
        case studentAttendace = "student_attendace"
        case assignedStudentClasses = "assigned_student_classes"
    }
}

// MARK: - AssignedStudentClass
struct StudentDataScannerAssignedStudentClass: Codable {
    let id, companyID: Int?
    let name: String?
    let isNapsMeals: Int?
    let ageGroupID: Int?
    let isactive, createdAt, updatedAt: String?
    let deletedAt: String?
    let pivot: StudentDataScannerPivot?

    enum CodingKeys: String, CodingKey {
        case id
        case companyID = "company_id"
        case name
        case isNapsMeals = "is_naps_meals"
        case ageGroupID = "age_group_id"
        case isactive
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case pivot
    }
}

// MARK: - Pivot
struct StudentDataScannerPivot: Codable {
    let userID, classID: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case classID = "class_id"
    }
}

// MARK: - StudentAttendace
struct StudentDataScannerStudentAttendace: Codable {
    let id, userID: Int?
    let sendBy: String?
    let classID, companyID: Int?
    let sendByImage, pickBy, pickByImage: String?
    let userType: Int?
    let checkinHealth, checkoutHealth, reason, checkInBy: String?
    let checkOutBy, leaveID, leaveStatusBy, leaveStatus: String?
    let checkinNotes, checkoutNotes: String?
    let reportStatus: String?
    let reportSendDate, reportSendTime: String?
    let date, timeIn: String?
    let timeOut, morningTemp, eveningTemp, otherTemp: String?
    let otherTempTime: String?
    let status: String?
    let session: String?
    let classMove, isactive: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case sendBy = "send_by"
        case classID = "class_id"
        case companyID = "company_id"
        case sendByImage = "send_by_image"
        case pickBy = "pick_by"
        case pickByImage = "pick_by_image"
        case userType = "user_type"
        case checkinHealth = "checkin_health"
        case checkoutHealth = "checkout_health"
        case reason
        case checkInBy = "check_in_by"
        case checkOutBy = "check_out_by"
        case leaveID = "leave_id"
        case leaveStatusBy = "leave_status_by"
        case leaveStatus = "leave_status"
        case checkinNotes = "checkin_notes"
        case checkoutNotes = "checkout_notes"
        case reportStatus = "report_status"
        case reportSendDate = "report_send_date"
        case reportSendTime = "report_send_time"
        case date
        case timeIn = "time_in"
        case timeOut = "time_out"
        case morningTemp = "morning_temp"
        case eveningTemp = "evening_temp"
        case otherTemp = "other_temp"
        case otherTempTime = "other_temp_time"
        case status, session
        case classMove = "class_move"
        case isactive
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
