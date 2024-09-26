import UIKit
import FSCalendar
import DropDown
import RYCOMSDK
import YPImagePicker

class TeacherPortfolio: UIViewController {
    
    private var doneButton = UIButton()
    private var datePicker = UIDatePicker()
    var isPickerPresented: Bool = false
    
    var selectedMode :Int? //for Celcious
    var tempCount: Int? //maximum 3 times, remaining temperature count variable
    var storeTemp1,storeTemp2,storeTemp3: String?
    var isSyncEnabled: Bool = false
    
    var currentDate: String = Date().shortDate
    var comesFrom = String()
    var studentId: Int = 0
    var classId = 0
    var studentName: String = ""
    var studentClass: String = ""
    var studentImage = String()
    
    var isMorningEvening: String?
    
    var syncMorning: Bool = false
    var syncEvening: Bool = false
    
    var selectedMorningGuardianIndex: Int = 0
    var selectedEveningGuardianIndex: Int = 0
    
    var tempMorning: String = "-"
    var tempEvening: String = "-"
    
    var middleTemperature: String = ""
    
    var timeIn: String?
    var timeOut: String?
    
    var attendanceData: StudentAttendanceModel?
    var portfolioData: ChildPortfolioModel?
    var activitiesData: [ActivityData]?
    
    var guardianData: GuardianListModel?
    var parentIds: [Int]?
    var parentNames: [String]?
    var parentImages: [String]?
    
    var morningGuardianPhoto: UIImage?
    var eveningGuardianPhoto: UIImage?
    
    var attendanceDataNew: [AttendanceData] = [.init(name: "Drop Off:", time: "-", temperature: "-"), .init(name: "Pick Up:", time: "-", temperature: "-")]{
        didSet { attendanceTableView.reloadData() }
    }
    
    let parentDropdown = DropDown()
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelClass: UILabel!
    @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var viewAttendance: UIView!
    @IBOutlet weak var attendanceTriangle: UIView!
    @IBOutlet weak var activityTriangle: UIView!
    @IBOutlet weak var viewTableActivity: UIView!
    
    @IBOutlet weak var buttonAddPortfolio: UIButton!
    @IBOutlet weak var tableActivity: UITableView!
   
    @IBOutlet weak var buttonSync: UIButton!
    @IBOutlet weak var viewOuterAttendance: UIView!
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonDate: UIButton!
    
    @IBOutlet weak var labelMorningTime: UILabel!
    @IBOutlet weak var labelMorningTemperature: UILabel!
   
    @IBOutlet weak var labelEveningTime: UILabel!
    @IBOutlet weak var labelEveningTemperature: UILabel!
    
    @IBOutlet weak var collectionMorning: UICollectionView!
    @IBOutlet weak var collectionEvening: UICollectionView!
    
    @IBOutlet weak var labelNoPosts: UILabel!
    
    @IBOutlet weak var gradientView: GradientView!
    
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var attendanceTableView: UITableView!
    @IBOutlet weak var attendanceView: UIView!
    @IBOutlet weak var viewDropOff: UIView!
    @IBOutlet weak var viewPickup: UIView!
    @IBOutlet weak var addActivityButton: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var activityCalendarCenter: NSLayoutConstraint!
    @IBOutlet weak var activityCalendarBtn: UIButton!
    @IBOutlet weak var attendanceBtn: UIButton!
    @IBOutlet weak var profileOuterView: UIView!
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var imageMorningParent: UIImageView!
    @IBOutlet weak var labelMorningParent: UILabel!
    
    @IBOutlet weak var imageEveningParent: UIImageView!
    @IBOutlet weak var labelEveningParent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isMorningEvening = "Morning"
        buttonSync.isHidden = false
        
        AttendanceContainer().delegate = self
        attendanceContainer()
        setupViews()
        registerCollection()
        registerTable()
        
        buttonSync.addTarget(self, action: #selector(syncAttendance), for: .touchUpInside)
        
        buttonAddPortfolio.addTarget(self, action: #selector(addPortfolio), for: .touchUpInside)
        
        buttonDate.addTarget(self, action: #selector(dateSelected), for: .touchUpInside)
        labelDate.text = Date().longDate
        
        self.calendar.scope = .week
        calendar.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getTeacherPorfolio()
        
        labelDate.text = Date().longDate
   
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.getChildAttendance(date: Date().shortDate)
        }
        
        getParentsList()
        
        setupBluetooth()
        UserDefaults.standard.set(studentId, forKey: "selectedStudent")
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapAddActivityButton(_ sender: Any) {
        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AddActivityVC") as? AddActivityVC {
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true)
        }
    }
    @IBAction func activityFunc(_ sender: Any) {
        /*
        activityContainer()
        // containerHeight.constant = 350
        viewTableActivity.isHidden = false
        
        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC {
            nextVC.modalTransitionStyle = .crossDissolve
            nextVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(nextVC, animated: true)
        }
         */
        activityCalendarCenter.priority = UILayoutPriority(998)
        activityCalendarBtn.tintColor = UIColor(named: "gradientBottom")
        attendanceBtn.tintColor = .white
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        self.activityTableView.isHidden = false
        self.attendanceView.isHidden = true
        buttonSync.isHidden = true
    }
    @IBAction func attendanceFunc(_ sender: Any) {
        //  containerHeight.constant = 350
        /*
         attendanceContainer()
         viewTableActivity.isHidden = true
         */
        activityCalendarCenter.priority = UILayoutPriority(996)
        attendanceBtn.tintColor = UIColor(named: "gradientBottom")
        activityCalendarBtn.tintColor = .white
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        self.attendanceView.isHidden = false
        self.activityTableView.isHidden = true
        if Date().shortDate == calendar.selectedDate?.shortDate {
            buttonSync.isHidden = false
        } else {
            buttonSync.isHidden = true
        }
    }
    
    @objc func dateSelected(sender: UIButton) {
        printt("DateSelected")
        if isPickerPresented {
            isPickerPresented = false
            self.doneButton.removeFromSuperview()
            self.datePicker.removeFromSuperview()
        }
        else {
            // datePicker = nil
            showPicker()
        }
    }
    
    func setupBluetooth() {
        RYBlueToothTool.sharedInstance().delegate = self
        selectedMode = 2
    }
    
    func showPicker() {
        isPickerPresented = true
        let picker : UIDatePicker = datePicker
        
        picker.textColor = .black
        
        picker.tintColor = .black
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            
            // Fallback on earlier versions
        }
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        //        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
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
        
        labelDate.text = displayDateFormatter.string(from: sender.date)
        
        //Use actual Date to get attendance for that date
        getChildAttendance(date: actualDateFormatter.string(from: sender.date))
        currentDate = actualDateFormatter.string(from: sender.date)
    }
    
    //MARK: Sync Attendance
    @objc func syncAttendance(sender: UIButton) {
      
        if self.isMorningEvening == "Morning" {
            self.syncMorningTemperature()
        }
        else if self.isMorningEvening == "Evening" {

            if middleTemperature == "" {
                //ALERT
                let alert = UIAlertController(title: "Checking Out?", message: "Is the student leaving?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { yup in
                    switch yup.style {
                    case .default:
                        self.syncEveningTemperature()
                        printt("Yuh")
                    case .cancel:
                        printt("nuh")
                    case .destructive:
                        printt("Thanos ?")
                    @unknown default:
                        fatalError()
                    }
                }))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { nope in
                    switch nope.style {
                    case .default:
                        self.syncMiddleTemperature()
                        printt("Nu Uh")
                    case .cancel:
                        printt("nuh")
                    case .destructive:
                        printt("Thanos ?")
                    @unknown default:
                        fatalError()
                    }
                }))
                self.present(alert, animated: true)
            }
            else {
                self.syncEveningTemperature()
            }
        }
    }
    
    //MARK: Add Portfolio
    @objc func addPortfolio(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectActivityPost") as! SelectActivityPost
        
        vc.currentDate = self.currentDate
        vc.studentId = self.studentId
        vc.classId = self.classId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func registerTable() {
        tableActivity.register(UINib(nibName: "DashboardTableCell", bundle: nil), forCellReuseIdentifier: "DashboardTableCell")
        tableActivity.delegate = self
        tableActivity.dataSource = self
        
        activityTableView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")
        activityTableView.register(UINib(nibName: "ActivityHeaderCell", bundle: nil), forCellReuseIdentifier: "ActivityHeaderCell")
        activityTableView.delegate = self
        activityTableView.dataSource = self
        
        attendanceTableView.register(UINib(nibName: "AttendanceCell", bundle: nil), forCellReuseIdentifier: "AttendanceCell")
        attendanceTableView.delegate = self
        attendanceTableView.dataSource = self
    }
    
    func registerCollection() {
        collectionMorning.register(UINib(nibName: "ParentCell", bundle: nil), forCellWithReuseIdentifier: "ParentCell")
        collectionMorning.delegate = self
        collectionMorning.dataSource = self
        
        collectionEvening.register(UINib(nibName: "ParentCell", bundle: nil), forCellWithReuseIdentifier: "ParentCell")
        collectionEvening.delegate = self
        collectionEvening.dataSource = self
    }
    
    func setupViews() {
        DispatchQueue.main.async { [self] in
            
            viewOuterAttendance.shadowWithRadius(radius: 10)
            viewOuterAttendance.layer.cornerRadius = 10
            
            viewTableActivity.shadowWithRadius(radius: 10)
            viewTableActivity.layer.cornerRadius = 10
            
            viewOuter.defaultShadow()
            viewOuter.layer.cornerRadius = 20
            
            viewAttendance.layer.cornerRadius = 20
            viewActivity.layer.cornerRadius = 20
            setDownTriangle(triangleView: attendanceTriangle)
            setDownTriangle(triangleView: activityTriangle)
            
            profileOuterView.superview?.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2
                                                                    , shadowColor: .black, cornerRadius: 10)
            self.profileOuterView.layer.cornerRadius = profileOuterView.layer.bounds.height/2
            self.imageProfile.layer.cornerRadius = imageProfile.layer.bounds.height/2
            parentView.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2, shadowColor: .black, cornerRadius: 28)
            parentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.viewDropOff.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2, shadowColor: .black, cornerRadius: 8)
            self.viewPickup.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2, shadowColor: .black, cornerRadius: 8)
            addActivityButton.isHidden = true
            
            activityCalendarCenter.priority = UILayoutPriority(996)
            attendanceBtn.tintColor = UIColor(named: "gradientBottom")
            activityCalendarBtn.tintColor = .white
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            self.attendanceView.isHidden = false
            self.activityTableView.isHidden = true
            if Date().shortDate == calendar.selectedDate?.shortDate {
                buttonSync.isHidden = false
            } else {
                buttonSync.isHidden = true
            }
            if comesFrom == "Home" {
                attendanceContainer()
            }
        }
    }
    
    func activityContainer() {
        activityTriangle.isHidden = false
        attendanceTriangle.isHidden = true
        
        //        ViewEmbedder.embed(withIdentifier: "ActivityContainer", parent: self, container: viewContainer) { AttendanceContainer in
        //
        //        }
    }
    
    func attendanceContainer() {
        activityTriangle.isHidden = true
        attendanceTriangle.isHidden = false
        
        //        ViewEmbedder.embed(withIdentifier: "AttendanceContainer", parent: self, container: viewContainer) { AttendanceContainer in
        //
        //        }
    }
    
    func getTeacherPorfolio() {
        //        DispatchQueue.main.async {
        //            startAnimating(self.view)
        //        }
        
        var params = [String: String]()
        params = ["user_id": String(self.studentId)]
        ApiManager.shared.Request(type: ChildPortfolioModel.self, methodType: .Get, url: baseUrl+apiStudentPortfolio, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async { [self] in
                    
                    portfolioData = myObject
                    DispatchQueue.main.async { [self] in
                        if myObject?.data?.count == 0 {
                            labelNoPosts.isHidden = false
                            tableActivity.isHidden = true
                        }
                        else {
                            labelNoPosts.isHidden = true
                            tableActivity.isHidden = false
                            tableActivity?.reloadData()
                        }
                         
                    }
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func getParentsList() {
        var params = [String: String]()
        params = ["user_id": String(studentId)]
        
        ApiManager.shared.Request(type: GuardianListModel.self, methodType: .Get, url: baseUrl+apiGuardianList, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    printt("GUARDIANLIST \(myObject?.data?.childrenParents)")
                    self.guardianData = myObject
                    self.setupGuardianCollection()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func getChildAttendance(date: String) {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        var params = [String: Any]()
        params = ["date": date,
                  "user_id": studentId
        ]
        
        ApiManager.shared.Request(type: StudentAttendanceModel.self, methodType: .Get, url: baseUrl+apiStudentAttendance, parameter: params) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async { [self] in
                if statusCode == 200 {
//                    printt("ClassID \(myObject?.data?.classID ?? 0)")
                    attendanceData = myObject
                    setupStudentDetails()
//                    classId = myObject?.data?.classID ?? 0
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
                
                self.getActivitiesAPI(date: date)
            }
        }
    }
    
    func getActivitiesAPI(date: String) {
        let params: [String: Any] = ["date": date,
                                     "user_id": studentId,
                                     "per_page": "30"
                           ]
        printt("Activities Parameters \(params)")
        ApiManager.shared.Request(type: ActivitiesModel.self, methodType: .Get, url: baseUrl+getActivity, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    guard let data = myObject?.data?.data else { return }
                    printt("Activities data \(myObject?.data?.data)")
                    self.activitiesData = data
                    self.activityTableView.reloadData()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func setupStudentDetails() {
        
        labelName.text = studentName
        labelClass.text = "Class: \(studentClass)"
        let userProfileUrl = URL(string: imageBaseUrl+(studentImage))
        DispatchQueue.main.async {
            self.imageProfile.kf.setImage(with: userProfileUrl, placeholder: UIImage(named: "placeholderImage"))
        }
//        imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(studentImage)), placeholderImage: .placeholderImage)
        
        //Data from API kcampus37@gmail.com Kinderc@mpus37
        let data = attendanceData?.data?.studentAttendace
        
        labelMorningTime.text = data?.timeIn ?? "-"
        labelEveningTime.text = data?.timeOut ?? "-"
        
        labelMorningTemperature.text = data?.morningTemp ?? "-"
        labelEveningTemperature.text = data?.eveningTemp ?? "-"
        
        attendanceDataNew = [.init(name: "Drop Off:", time: data?.timeIn ?? "-", temperature: data?.morningTemp ?? "-"), .init(name: "Pick Up:", time: data?.timeOut ?? "-", temperature: data?.eveningTemp ?? "-")]
        
        labelMorningParent.text = data?.sender?.name
        labelEveningParent.text = data?.picker?.name
        imageEveningParent.sd_setImage(with: URL(string: imageBaseUrl+(data?.sender?.image ?? "")), placeholderImage: .placeholderImage)
        imageEveningParent.sd_setImage(with: URL(string: imageBaseUrl+(data?.picker?.image ?? "")), placeholderImage: .placeholderImage)
        setupWhichSessionToSync()
    }
    
    func setupWhichSessionToSync() {
        
        printt("Morning \(labelMorningTemperature.text)")
        printt("Evening \(labelEveningTemperature.text)")
        
        if self.labelEveningTemperature.text == "-" {
            self.syncEvening = true
        }
        else {
            self.syncEvening = false
        }
        
        if self.labelMorningTemperature.text == "-" {
            self.syncMorning = true
        }
        else {
            self.syncMorning = false
        }
        printt("SyncMorning \(syncMorning)")
        printt("SyncEvening \(syncEvening)")
        
        setupGuardianCollection()
        
    }
    
    func setupGuardianCollection() {
        DispatchQueue.main.async { [self] in
            collectionMorning.reloadData()
            collectionEvening.reloadData()
        }
    }
    
    func setupParents() {
        parentIds = guardianData?.data?.childrenParents?.compactMap {
            $0.id
        }
        parentNames = guardianData?.data?.childrenParents?.compactMap {
            $0.name
        }
        parentImages = guardianData?.data?.childrenParents?.compactMap {
            $0.image
        }
       
        parentDropdown.dismissMode = .onTap
        parentDropdown.anchorView = self.buttonSync
        parentDropdown.dataSource = parentNames ?? []
        parentDropdown.topOffset = CGPoint(x: 0, y: buttonSync.bounds.height)
        parentDropdown.selectionAction = { (index: Int, item: String) in
            
        }
    }
}

extension TeacherPortfolio: DateSelected {
    func dateTapped() {
        printt("Dateeee")
    }
}
//MARK: Collection
extension TeacherPortfolio: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionMorning {
            
            if self.morningGuardianPhoto != nil {
                return 1
            }
            else {
            if self.syncMorning {
                return self.guardianData?.data?.childrenParents?.count ?? 0
            }
            else {
                return 1
            }
        }
        }
        else if collectionView == collectionEvening {
            if self.eveningGuardianPhoto != nil {
                return 1
            }
            else {
            if self.syncEvening {
                return self.guardianData?.data?.childrenParents?.count ?? 0
            }
            else {
                return 1
            }
    }
    }
        else {
            return 0
        }
    }
    @objc func addingMorningGuardingPhoto(sender: UIButton) {
        showImagePicker()
        
    }
    
    @objc func addingEveningGuardingPhoto(sender: UIButton) {
        showImagePicker()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionMorning {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParentCell", for: indexPath) as! ParentCell
            
            if !self.syncMorning {
                cell.viewAddImage.isHidden = true
            }
            
            if let image = self.morningGuardianPhoto {
                cell.imageGuardian.image = image
                cell.viewAddImage.isHidden = true
                return cell
            }
            
            else {
            
            let data = self.guardianData?.data?.childrenParents
          
            cell.buttonAddImage.addTarget(self, action: #selector(addingMorningGuardingPhoto), for: .touchUpInside)
            
            if self.syncMorning {
                cell.viewAddImage.isHidden = false
                cell.labelName.text = data?[indexPath.item].name
                if let img = data?[indexPath.item].image {
                    if let url = URL(string: imageBaseUrl+img) {
                        cell.imageGuardian.sd_setImage(with: url, placeholderImage: .placeholderImage)
                }
            }
                else {
                    cell.imageGuardian.image = .placeholderImage
                }
            }
            
            else {
                cell.labelName.text = self.attendanceData?.data?.studentAttendace?.sender?.name ?? "-"
                cell.imageGuardian.sd_setImage(with: URL(string: imageBaseUrl+(self.attendanceData?.data?.studentAttendace?.sender?.image ?? "")), placeholderImage: .placeholderImage)
            }
            
            cell.imageGuardian.layer.cornerRadius = cell.imageGuardian.bounds.height/2.0
            return cell
        }
        }
        else if collectionView == collectionEvening {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParentCell", for: indexPath) as! ParentCell
            
            if self.syncMorning {
                cell.viewAddImage.isHidden = true
            }
                if let image = self.eveningGuardianPhoto {
                    cell.imageGuardian.image = image
                    cell.viewAddImage.isHidden = true
                    return cell
                }
                else {
                let data = self.guardianData?.data?.childrenParents
                
                    if !self.syncMorning {
                        if !self.syncEvening {
                        cell.viewAddImage.isHidden = true
                    }
                        else {
                            cell.viewAddImage.isHidden = false
                        }
                    }
                
                cell.buttonAddImage.addTarget(self, action: #selector(addingEveningGuardingPhoto), for: .touchUpInside)
                
                if self.syncEvening {
                    cell.labelName.text = data?[indexPath.item].name
                    if let img = data?[indexPath.item].image {
                        if let url = URL(string: imageBaseUrl+img) {
                            cell.imageGuardian.sd_setImage(with: url, placeholderImage: .placeholderImage)
                    }
                }
                    else {
                        cell.imageGuardian.image = .placeholderImage
                    }
                }
                else {
                    cell.labelName.text = self.attendanceData?.data?.studentAttendace?.picker?.name ?? ""
                    cell.imageGuardian.sd_setImage(with: URL(string: imageBaseUrl+(self.attendanceData?.data?.studentAttendace?.picker?.image ?? "")), placeholderImage: .placeholderImage)
                    
                }
                    
                cell.imageGuardian.layer.cornerRadius = cell.imageGuardian.bounds.height/2.0
                return cell
            }
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        for cell in collectionMorning.visibleCells {
//                let indexPath = collectionMorning.indexPath(for: cell)
//            print("Morning Collection Index \(indexPath?.item)")
//            }
//
//        for cell in collectionEvening.visibleCells {
//                let indexPath = collectionEvening.indexPath(for: cell)
//            print("Evening Collection Index \(indexPath?.item)")
//            }
    
        if scrollView == collectionMorning {
            var visibleRect = CGRect()
                visibleRect.origin = collectionMorning.contentOffset
                visibleRect.size = collectionMorning.bounds.size
                let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                guard let indexPath = collectionMorning.indexPathForItem(at: visiblePoint) else { return }
            self.selectedMorningGuardianIndex = indexPath.item
            printt("Morning Collection Index \(indexPath.item)")
        }
        
        if scrollView == collectionEvening {
            var visibleRect = CGRect()
                visibleRect.origin = collectionEvening.contentOffset
                visibleRect.size = collectionEvening.bounds.size
                let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                guard let indexPath = collectionEvening.indexPathForItem(at: visiblePoint) else { return }
            self.selectedEveningGuardianIndex = indexPath.item
            printt("Evening Collection Index \(indexPath.item)")
        }
    }
}

//MARK: Bluetooth
extension TeacherPortfolio: RYBlueToothToolDelegate {
    
    func checkStudentValidate() -> Bool{
        return true
    }
    
    func getReturnValue(_ data: String!) {
        
        let dataArray = data.components(separatedBy: " ")
        if (dataArray.count < 2) {
            return;
        }
        if let count = Int(dataArray[1])  {
            if count == 16{
                if (dataArray.count != 13) {
                    return;
                }
                var temperature : Float = 0.0;
                if let count9Variable = Int(dataArray[9]){
                    
                    if count9Variable == 0{
                        
                        RYBlueToothTool.sharedInstance().setMode(1, unit: "℃")
                        self.selectedMode = 2
                    }
                }
                if let count10Variable = Int(dataArray[10]){
                    if count10Variable == 0{
                        //print("℃")
                    }else if count10Variable == 1{
                        //print("℃")
                    }
                }
                if self.selectedMode == 2 {
                    temperature = Float((Float(dataArray[6])! * 256.0 + Float(dataArray[5])!) / 10.0)
                //  Toast.toast(message: "Temperature = \(String(temperature))", controller: self)
                    
                    temperature = temperature.convertTemperatureToFahrenheit()
                    let temperatureString = String(temperature)
                    
                    if self.syncMorning == true {
                        DispatchQueue.main.async {
                            self.labelMorningTemperature.text = "\(temperatureString)°C"
                            self.isMorningEvening = "Morning"
                            self.buttonSync.isHidden = false
                            self.tempMorning = String(temperature)
                            self.isSyncEnabled = true
                            
                            self.attendanceDataNew[0].temperature = String(format: "%.2f", temperature)
                            
                            Toast.toast(message: "Sync the morning temperature = \(String(temperature))", controller: self)
                        }
                    }
                        
                    if self.syncMorning == false {
                        if self.syncEvening == true {
                            DispatchQueue.main.async {
                                self.labelEveningTemperature.text = "\(temperatureString)°C"
                                self.isMorningEvening = "Evening"
                                self.buttonSync.isHidden = false
                                self.tempEvening = String(temperature)
                                self.isSyncEnabled = true
                                
                                self.attendanceDataNew[1].temperature = String(temperature)
                                
                                Toast.toast(message: "Sync the evening temperature = \(String(format: "%.2f", temperature))", controller: self)
                            
                        }
                        }
                        else {
                            Toast.toast(message: "Attendance has already been marked", controller: self)
                        }
                        }
                    }
                }
            }
        }
    }

//MARK: Table
extension TeacherPortfolio: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableActivity {
            return self.portfolioData?.data?.count ?? 0
        } else if tableView == attendanceTableView {
            return attendanceDataNew.count
        } else {
            let count = self.activitiesData?.count ?? 0
            if count == 0 {
                tableView.setNoDataMessage("No activity found!")
            } else {
                activityTableView.restore()
            }
            return count
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableActivity {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableCell", for: indexPath) as! DashboardTableCell
            
            let data = self.portfolioData?.data?[indexPath.row]
            
            cell.cellContent = data?.portfolioImage
            cell.collectionImages.tag = indexPath.row
            cell.collectionImages.reloadData()
            
            cell.imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(data?.teacher?.image ?? "")), placeholderImage: .placeholderImage)
            
            cell.labelTitle.text = data?.title ?? ""
            cell.labelDomain.text = data?.domain?.name ?? ""
            cell.labelName.text = data?.teacher?.name ?? ""
            cell.labelDescription.text = data?.postContent ?? ""
            cell.labelTime.text = data?.postDate ?? ""
            
            cell.buttonLike.setImage(UIImage(named: "likeEmpty"), for: .normal)
            cell.buttonLike.setImage(UIImage(named: "likeFilled"), for: .selected)
            
            if data?.isLike == 1 {
                cell.buttonLike.isSelected = true
            }
            else if data?.isLike == 0 {
                cell.buttonLike.isSelected = false
            }
            
            cell.buttonLike.tag = indexPath.row
            cell.buttonComment.tag = indexPath.row
            cell.buttonShare.tag = indexPath.row
            cell.buttonWriteComment.tag = indexPath.row
            cell.buttonLike.addTarget(self, action: #selector(likeFunc), for: .touchUpInside)
            cell.buttonComment.addTarget(self, action: #selector(commentFunc), for: .touchUpInside)
            cell.buttonWriteComment.addTarget(self, action: #selector(commentFunc), for: .touchUpInside)
            cell.labelComments.text = String(data?.totalComments ?? 0)
            printt("Unread \(data?.unreadComment ?? -1)")
            cell.hideUnreadCommentViews(true)
            //        if data?.unreadComment == 1 {
            //            cell.hideUnreadCommentViews(false)
            //        }
            //        else {
            //            cell.hideUnreadCommentViews(true)
            //        }
            
            cell.labelLikes.text = String(data?.totalLikes ?? 0)
            
            //  cell.viewOuter.defaultShadow()
            cell.layer.cornerRadius = 20
            cell.backgroundColor = .clear
            return cell
        } else if tableView == activityTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as? ActivityCell
            let item = self.activitiesData?[indexPath.row]
            cell?.startTimeLabel.text = item?.startTimeHours
            cell?.endTimeLabel.text = item?.endTimeHours
            cell?.titleLabel.text = item?.title
            cell?.descriptionLabel.text = item?.descriptions
            cell?.moreButton.isHidden = true
            return cell ?? UITableViewCell()
        } else if tableView == attendanceTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath) as? AttendanceCell
            let data = attendanceDataNew[indexPath.row]
            cell?.nameLabel.text = data.name ?? ""
            cell?.temperatureLabel.text = data.temperature
            cell?.timeLabel.text = data.time
            return cell ?? UITableViewCell()
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: "ActivityHeaderCell") as! ActivityHeaderCell
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == activityTableView {
            return 40
        } else {
            return 0
        }
    }
}

//MARK: Obj-C Functions
extension TeacherPortfolio {
    
    @objc func likeFunc(sender: UIButton) {
        print(sender.tag)
        likeAPI(row: sender.tag)
    }
    @objc func commentFunc(sender: UIButton) {
        print("CommentFunc")
        
        let vc = Comments().instance() as! Comments
        vc.portfolioId = self.portfolioData?.data?[sender.tag].id ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: Like Comment Functions

extension TeacherPortfolio {
    
    func likeAPI(row: Int) {
        var params: [String: String]
        params = ["portfolio_id": String(self.portfolioData?.data?[row].id ?? 0)]
        ApiManager.shared.Request(type: LikeModel.self, methodType: .Post, url: baseUrl+apiLikePortfolio, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                let totalLikes = (self.portfolioData?.data?[row].totalLikes ?? 0)
                let rowToReload = IndexPath(row: row, section: 0)
                if myObject?.data == 1 {
                    self.portfolioData?.data?[row].isLike = 1
                    self.portfolioData?.data?[row].totalLikes = totalLikes + 1
                }
                else if myObject?.data == 2 {
                    self.portfolioData?.data?[row].isLike = 0
                    self.portfolioData?.data?[row].totalLikes = totalLikes - 1
                }
                DispatchQueue.main.async {
                    self.tableActivity.reloadRows(at: [rowToReload], with: .automatic)
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
}

//MARK: Sync Temperature APIs
extension TeacherPortfolio {
    
    func syncMorningTemperature() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        var imageData = [Data]()
        
        if let image = self.morningGuardianPhoto {
            let imgData = try! image.jpegData(compressionQuality: 0.1)
            imageData.append(imgData!)
        }
        else {
            guard let imageUrl = URL(string: imageBaseUrl + (guardianData?.data?.childrenParents?[selectedMorningGuardianIndex].image ?? "")) else { return }
            let imgData = try? Data(contentsOf: imageUrl)
            imageData.append(imgData ?? Data())
        }
        
        let currentTime: String = .currentTime
        
        var params = [String: Any]()
        
        params = ["user_id": self.studentId,
                  "time_in": currentTime,
                  "temperature": "\(self.labelMorningTemperature.text ?? "")",
                  //                      "temperature": "35C",
                  "temprature_type": "1",
                  "send_by": self.guardianData?.data?.childrenParents?[selectedMorningGuardianIndex].id ?? 0,
                  "date": currentDate
        ]
        
        print(params)
        ApiManager.shared.requestWithImage(type: BaseModel.self, url: baseUrl+apiAddAttendance, parameter: params, imageNames: ["attendanceImage"], imageKeyName: "parent", images: imageData) { error, myObject, messageStr, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    self.buttonSync.isHidden = true
                    self.syncMorning = false
                    Toast.toast(message: "Morning Attendance Synced Successfully", controller: self)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func syncMiddleTemperature() {
        var params = [String: Any]()
        params = ["user_id": self.studentId,
                  "temperature": "\(self.labelEveningTemperature.text ?? "")",
                  //                      "temperature": "\(self.labelEveningTemperature.text ?? "")F",
                  "temprature_type": "2",
                  "date": currentDate
        ]
        print(params)
        ApiManager.shared.Request(type: BaseModel.self, methodType: .Post, url: baseUrl+apiAddMiddleAttendance, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    Toast.toast(message: "Temperature Added Successfully", controller: self)
                    self.buttonSync.isHidden = true
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func syncEveningTemperature() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        var imageData = [Data]()
        
        if let image = self.eveningGuardianPhoto {
            let imgData = try? image.jpegData(compressionQuality: 0.1)
            imageData.append(imgData!)
        }
        else {
            guard let imageUrl = URL(string: imageBaseUrl + (guardianData?.data?.childrenParents?[selectedEveningGuardianIndex].image ?? "")) else { return }
            
            let imgData = try? Data(contentsOf: imageUrl)
            imageData.append(imgData ?? Data())
        }
        
        let currentTime: String = .currentTime
        
        var params = [String: Any]()
        params = ["user_id": self.studentId,
                  "time_out": currentTime,
                  "temperature": "\(self.labelEveningTemperature.text ?? "")",
                  //                      "temperature": "\(self.labelEveningTemperature.text ?? "")F",
                  "temprature_type": "1",
                  "pick_by": self.guardianData?.data?.childrenParents?[selectedEveningGuardianIndex].id ?? 0,
                  "date": currentDate
        ]
        print(params)
        
        ApiManager.shared.requestWithImage(type: BaseModel.self, url: baseUrl+apiAddMiddleAttendance, parameter: params, imageNames: ["attendanceImage"], imageKeyName: "parent", images: imageData) { error, myObject, messageStr, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    Toast.toast(message: "Evening Attendance Synced Successfully", controller: self)
                    self.buttonSync.isHidden = true
                    self.syncEvening = false
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
}

extension TeacherPortfolio {
    @objc func showImagePicker() {
        
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        
        config.shouldSaveNewPicturesToAlbum = false
       // config.video.compression = AVAssetExportPresetMediumQuality
        config.startOnScreen = .photo
        config.showsPhotoFilters = false
      //  config.showsFilters = false
        config.screens = [.library, .photo]
     //   config.screens = [.library,.photo]
        config.video.libraryTimeLimit = 500.0
        config.showsCrop = .none
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 9
        config.library.skipSelectionsGallery = true
        let picker = YPImagePicker(configuration: config)
        
        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                //print("Picker was canceled")
                picker.dismiss(animated: true, completion: {
                   // self.tabBarController?.selectedIndex = 0
                    //self.navigationController?.popViewController(animated: true)
                })
                return
            }
            _ = items.map { print("🧀 \($0)") }
            var imageArray: [UIImage] = []
            var imageDataArr: [Data] = []
            if items.count > 0{
                for (_,data) in items.enumerated(){
                    let firstItem = data
                    switch firstItem {
                    case .photo(let photo):
                        imageArray.append(photo.image)
                        do {
                            if self.syncMorning {
                                self.morningGuardianPhoto = photo.image
                                DispatchQueue.main.async {
                                    self.collectionMorning.reloadData()
                                }
                            }
                            else if self.syncEvening {
                                self.eveningGuardianPhoto = photo.image
                                DispatchQueue.main.async {
                                    self.collectionEvening.reloadData()
                                }
                            }
                            let imgData = try! photo.image.jpegData(compressionQuality: 0.1)
                            imageDataArr.append(imgData!)
                        }
                        catch {
                            print("Error converting image to data")
                        }
                    case .video(let _):
                        return
                    }
                }
                picker.dismiss(animated: true, completion: { [weak self] in
//                     let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ConfirmPost") as! ConfirmPost
//                        vc.imageDataArray = imageDataArr
//                        vc.selectedImages = imageArray
//                         vc.studentId = ""
//                    vc.delegate = self
//                        self?.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
        picker.definesPresentationContext = true
        picker.modalPresentationStyle = .overCurrentContext
        present(picker, animated: true, completion: nil)
    }
}

// MARK: - FSCalendar
extension TeacherPortfolio: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame = CGRect(origin: calendar.frame.origin , size: bounds.size)
        // Do other updates here
        print(CGRect(origin: calendar.frame.origin , size: bounds.size))
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        getChildAttendance(date: date.shortDate)
        let currentDate = date.shortDate
        let todayDate = Date().shortDate
        buttonSync.isHidden = (currentDate == todayDate) ? false : true
        collectionEvening.isHidden = (currentDate == todayDate) ? false : true
        collectionMorning.isHidden = (currentDate == todayDate) ? false : true
        
        imageMorningParent.isHidden = (currentDate == todayDate) ? true : false
        imageEveningParent.isHidden = (currentDate == todayDate) ? true : false
        labelMorningParent.isHidden = (currentDate == todayDate) ? true : false
        labelEveningParent.isHidden = (currentDate == todayDate) ? true : false
    }
}

struct AttendanceData {
    var name: String?
    var time: String?
    var temperature: String?
}
