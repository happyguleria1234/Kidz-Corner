import UIKit
import DropDown

class ClassStats: UIViewController {
    
    private var datePicker = UIDatePicker()
    private var doneButton = UIButton()
    
    var isPickerPresented: Bool = false
    
    let dropDown = DropDown()
    
    var classAttendance: ClassAttendanceModel?
    var classesData: AllClassesModel?
    
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
        
        let myClass = UserDefaults.standard.integer(forKey: myClass)
        
        if myClass != 0 {
            self.classId = myClass
            getAttendance(classId: self.classId ?? 0, date: currentDate)
        }
        else {
            getClasses()
        }
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
    
    func setupTable() {
        tableStats.register(UINib(nibName: "StatsHeader", bundle: nil), forCellReuseIdentifier: "StatsHeader")
        tableStats.register(UINib(nibName: "StatsCell", bundle: nil), forCellReuseIdentifier: "StatsCell")
        tableStats.delegate = self
        tableStats.dataSource = self
        tableStats.backgroundColor = .clear
    }
    
    func setupViews() {
        
//        buttonClasses.layer.cornerRadius = 5
//        buttonClasses.layer.borderColor = UIColor.white.cgColor
//        buttonClasses.layer.borderWidth = 2
        
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
   
    func getAttendance(classId: Int,date: String) {
        var params = [String: Any]()
        params = ["date": date,
                  "class_id": String(classId)]
        
        ApiManager.shared.Request(type: ClassAttendanceModel.self, methodType: .Get, url: baseUrl+apiClassAttendance, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {

                print(myObject)

                DispatchQueue.main.async { [self] in
                    self.classAttendance = myObject
                    tableStats.reloadData()
                    
                    if myObject?.data?.count != 0 {
                        self.labelClassName.text = myObject?.data?[0].className?.name ?? ""
                    }
                   
                   
                  //  self.labelDate.text = "( \(Date().shortDate) )"
                    
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
       
        printt("DateSelected")
        if isPickerPresented {
            isPickerPresented = false
            self.datePicker.removeFromSuperview()
            self.doneButton.removeFromSuperview()
        }
        else {
       // datePicker = nil
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
            // Fallback on earlier versions
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
            }
            else {
                cell.labelStatTwo.text = "-"
            }
            
            //For Third Temperature
            
            if data?.attendance?.thirdTemperature != nil {
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = .black
                printt("Third \(data?.attendance?.thirdTemperature)")
            }
            else {
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
        }
        else {
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
            getAttendance(classId: self.classId ?? 0, date: currentDate)
        }
    }
}
