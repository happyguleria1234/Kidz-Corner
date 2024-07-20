import UIKit
import FSCalendar

class ParentPortfolio: UIViewController {
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var viewOuter: UIView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelClass: UILabel!
    
    @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var viewAttendance: UIView!
    
    @IBOutlet weak var attendanceTriangle: UIView!
    @IBOutlet weak var activityTriangle: UIView!
    
    @IBOutlet weak var viewOuterAttendance: UIView!
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonDate: UIButton!
    
    @IBOutlet weak var labelMorningTime: UILabel!
    @IBOutlet weak var labelMorningTemperature: UILabel!
    @IBOutlet weak var imageMorningParent: UIImageView!
    @IBOutlet weak var labelMorningParent: UILabel!
    
    @IBOutlet weak var labelEveningTime: UILabel!
    @IBOutlet weak var labelEveningTemperature: UILabel!
    @IBOutlet weak var imageEveningParent: UIImageView!
    @IBOutlet weak var labelEveningParent: UILabel!

    @IBOutlet weak var labelNoPosts: UILabel!
    
    @IBOutlet weak var viewTableActivity: UIView!
    @IBOutlet weak var tableActivity: UITableView!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var attendanceTableView: UITableView!
    @IBOutlet weak var studentProfileCollectionView: UICollectionView! {
        didSet {
            studentProfileCollectionView.delegate = self
            studentProfileCollectionView.dataSource = self
            studentProfileCollectionView.register(UINib(nibName: "StudentProfileCell", bundle: nil), forCellWithReuseIdentifier: "StudentProfileCell")
            studentProfileCollectionView.isPagingEnabled = true
        }
    }
    
    @IBOutlet var buttonNextChild: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var activityCalendarCenter: NSLayoutConstraint!
    @IBOutlet weak var activityCalendarBtn: UIButton!
    @IBOutlet weak var attendanceBtn: UIButton!
    @IBOutlet weak var profileOuterView: UIView!
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var attendanceView: UIView!
    @IBOutlet weak var viewDropOff: UIView!
    @IBOutlet weak var viewPickup: UIView!
    
    var isPickerPresented: Bool = false
    var datePicker = UIDatePicker()
    var comesFrom = String()

    var childrenIds: [Int] {
        if let ids = UserDefaults.standard.array(forKey: myChildrenIds) as? [Int] {
            return ids
        }
        else {
            return [0]
        }
    }
    
    var currentChildIndex: Int = 0
    
    private var doneButton = UIButton()
    
    var portfolioData: ChildPortfolioModel?
    var childInfo: ChildAttendanceModel?
    var childrenData: [ChildData]? {
        didSet {
            self.studentProfileCollectionView.reloadData()
            labelDate.text = Date().longDate
            
            if childrenData?.count != 0 && childrenData != nil {
                if let childId = childrenData?[0].id {
                    getParentPortfolio(for: childId)
                    getChildDetailsApi(date: Date().shortDate, childId: childId)
                }
            }
        }
    }
    var activitiesData: [ActivityData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable()
        AttendanceContainer().delegate = self
        buttonDate.addTarget(self, action: #selector(dateSelected), for: .touchUpInside)
//        attendanceContainer()
        setupViews()
        self.calendar.scope = .week
        calendar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllChildsAPI()
        
        if selectedType == 1 {
            activityCalendarCenter.priority = UILayoutPriority(996)
            attendanceBtn.tintColor = UIColor(named: "gradientBottom")
            activityCalendarBtn.tintColor = .white
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            self.attendanceTableView.isHidden = true
            self.attendanceView.isHidden = false
            self.activityTableView.isHidden = true
        } else {
            activityCalendarCenter.priority = UILayoutPriority(998)
            activityCalendarBtn.tintColor = UIColor(named: "gradientBottom")
            attendanceBtn.tintColor = .white
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            self.activityTableView.isHidden = false
            self.attendanceTableView.isHidden = true
            self.attendanceView.isHidden = true
        }
        
        getParentPortfolio(for: childrenIds[currentChildIndex])
        labelDate.text = Date().longDate
        getChildDetailsApi(date: Date().shortDate, childId: childrenIds[currentChildIndex])
    }
    
    
    @IBAction func tappedMorningParentImage(_ sender: Any) {
        if let image = imageMorningParent.image, image != UIImage(named: "placeholderImage")! {
            if let viewController = UIStoryboard(name: "Common", bundle: nil).instantiateViewController(withIdentifier: "DisplayImage") as? DisplayImage {
                viewController.imageToDisplay = image
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func tappedEveningParentImage(_ sender: Any) {
        if let image = imageEveningParent.image {
            if let viewController = UIStoryboard(name: "Common", bundle: nil).instantiateViewController(withIdentifier: "DisplayImage") as? DisplayImage {
                viewController.imageToDisplay = image
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func backFunc(_ sender: Any) {
    }
    
    @IBAction func nextChildFunc(_ sender: Any) {
        print("ChildrenIDs \(self.childrenIds) CurrentChild \(self.childrenIds[currentChildIndex])")
        
        //If on the last index, move to first.
        if childrenIds[currentChildIndex] == childrenIds.last {
            currentChildIndex = 0
        }
        else {
            currentChildIndex += 1
        }
        
        // Call the APIs to reload the child's info.
        getParentPortfolio(for: childrenIds[currentChildIndex])
        getChildDetailsApi(date: Date().shortDate, childId: childrenIds[currentChildIndex])
    }
    
    @IBAction func logoutFunc(_ sender: Any) {
        
        UserDefaults.standard.setValue(false, forKey: isLoggedIn)
        UserDefaults.standard.removeObject(forKey: myUserid)
        UserDefaults.standard.removeObject(forKey: myToken)
        UserDefaults.standard.removeObject(forKey: myName)
        UserDefaults.standard.removeObject(forKey: myImage)
        UserDefaults.standard.removeObject(forKey: myRoleId)
        
        UserDefaults.standard.removeObject(forKey: "BluetoothUUID")
        let sb = UIStoryboard(name: "Auth", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignIn") as! SignIn
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func activityFunc(_ sender: Any) {
//        containerHeight.constant = 750

//        viewTableActivity.isHidden = false
//        activityContainer()
        
        activityCalendarCenter.priority = UILayoutPriority(998)
        activityCalendarBtn.tintColor = UIColor(named: "gradientBottom")
        attendanceBtn.tintColor = .white
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        self.activityTableView.isHidden = false
        self.attendanceTableView.isHidden = true
        self.attendanceView.isHidden = true
        
    }
    @IBAction func attendanceFunc(_ sender: Any) {
        //        containerHeight.constant = 350
        
        /*
         attendanceContainer()
         viewTableActivity.isHidden = true
         brandsbarker@gmail.com Orisen123*
         */
        activityCalendarCenter.priority = UILayoutPriority(996)
        attendanceBtn.tintColor = UIColor(named: "gradientBottom")
        activityCalendarBtn.tintColor = .white
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        self.attendanceTableView.isHidden = true
        self.attendanceView.isHidden = false
        self.activityTableView.isHidden = true
    }
    
    func attendanceContainer() {
        activityTriangle.isHidden = true
        attendanceTriangle.isHidden = false
    }
    func activityContainer() {
        activityTriangle.isHidden = false
        attendanceTriangle.isHidden = true
    }
    
    func setupViews() {
        DispatchQueue.main.async { [self] in
            
            if (childrenIds.count ?? 0) > 1 {
                buttonNextChild.isHidden = false
            }
            else {
                buttonNextChild.isHidden = true
            }
            
            imageMorningParent.layer.cornerRadius = imageMorningParent.bounds.height/2.0
            imageEveningParent.layer.cornerRadius = imageEveningParent.bounds.height/2.0
            
            viewOuterAttendance.shadowWithRadius(radius: 10)
            viewOuterAttendance.layer.cornerRadius = 10
            
            viewActivity.layer.cornerRadius = 20
            viewTableActivity.shadowWithRadius(radius: 10)
            viewTableActivity.layer.cornerRadius = 10
            
            viewOuter.defaultShadow()
            viewOuter.layer.cornerRadius = 20
            viewActivity.layer.cornerRadius = 20
            viewAttendance.layer.cornerRadius = 20
            setDownTriangle(triangleView: attendanceTriangle)
            setDownTriangle(triangleView: activityTriangle)
            
            attendanceContainer()
            
            /*
             profileOuterView.superview?.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2
                                                                     , shadowColor: .black, cornerRadius: 10)
            */
             
            self.profileOuterView.layer.cornerRadius = profileOuterView.layer.bounds.height/2
            self.imageProfile.layer.cornerRadius = imageProfile.layer.bounds.height/2
            parentView.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2, shadowColor: .black, cornerRadius: 28)
            parentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.viewDropOff.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2, shadowColor: .black, cornerRadius: 8)
            self.viewPickup.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2, shadowColor: .black, cornerRadius: 8)
            
            if comesFrom == "Home" {
                attendanceContainer()
            }
            
        }
    }
  
    
    @objc func dateSelected(sender: UIButton) {
        
        print("DateSelected")
        
        if isPickerPresented {
            isPickerPresented = false
            
            let actualDateFormatter = DateFormatter()
            actualDateFormatter.dateStyle = .long
            actualDateFormatter.timeStyle = .none
            actualDateFormatter.dateFormat = "dd-MM-yyyy"
            
            getChildDetailsApi(date: actualDateFormatter.string(from: datePicker.date), childId: childrenIds[currentChildIndex])
            
            self.doneButton.removeFromSuperview()
            self.datePicker.removeFromSuperview()
        }
        else {
       // datePicker = nil
        showPicker()
        }
    }
        
    func showPicker() {
        isPickerPresented = true
        let picker : UIDatePicker = datePicker
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
        
        labelDate.text = displayDateFormatter.string(from: sender.date)
   
        //Use actual Date to get attendance for that date
        getChildDetailsApi(date: actualDateFormatter.string(from: sender.date), childId: childrenIds[currentChildIndex])
    }
    
    func getChildDetailsApi(date: String, childId: Int?) {
        
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        var params = [String: String]()
        
        if let id = childId {
            params = ["date": date,
                      "student_id": String(id)
                    ]
        }
        else {
            params = ["date": date]
        }
        
        ApiManager.shared.Request(type: ChildAttendanceModel.self, methodType: .Get, url: baseUrl+apiChildAttendance, parameter: params) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    
                    printt("CHILDATTENDANCE \(myObject?.data)")
                    
                    self.childInfo = myObject
                    self.setupChildDetails()
                    
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
                self.getActivitiesAPI(date: date, studentId: childId)
            }
        }
    }
    
    func setupChildDetails() {
        
        let data = self.childInfo?.data
        
        printt("Data \(String(describing: data?.attendance?.sender))")
        
        self.labelName.text = data?.children?.name ?? ""
        self.labelClass.text = "Class: \(data?.children?.studentProfile?.className?.name ?? "")"
        
        self.imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(data?.children?.image ?? "")), placeholderImage: .placeholderImage)
        
        if let morningTemperature = data?.attendance?.morningTemp {
            labelMorningTemperature.text = "Temp: \(morningTemperature)"
        }
        else {
            labelMorningTemperature.text = "-"
        }
        
        if let eveningTemperature = data?.attendance?.eveningTemp {
            labelEveningTemperature.text = "Temp: \(eveningTemperature)"
        }
        else {
            labelEveningTemperature.text = "-"
        }
        
        self.labelMorningTime.text = data?.attendance?.timeIn ?? "-"
        self.labelEveningTime.text = data?.attendance?.timeOut ?? "-"
        self.labelMorningParent.text = data?.attendance?.sender?.name ?? "-"
        self.labelEveningParent.text = data?.attendance?.picker?.name ?? "-"
        
        if let imgUrl = URL(string: imageBaseUrl+(data?.attendance?.sender?.image ?? "")) {
            self.imageMorningParent.sd_setImage(with: imgUrl, placeholderImage: .placeholderImage)
        }
        if let imgUrl = URL(string: imageBaseUrl+(data?.attendance?.picker?.image ?? "")) {
            self.imageEveningParent.sd_setImage(with: imgUrl, placeholderImage: .placeholderImage)
        }
        
        else {
            labelMorningTemperature.text = "-"
            labelEveningTemperature.text = "-"
            
            self.labelMorningTime.text = "-"
            self.labelEveningTime.text = "-"
            self.labelMorningParent.text = "-"
            self.labelEveningParent.text = "-"
            
            imageMorningParent.image = .placeholderImage
            imageEveningParent.image = .placeholderImage
        }
    }
}

extension ParentPortfolio: DateSelected {
    
    func dateTapped() {
        printt("Dateeee")
    }
}


//MARK: Portfolio Stuff
extension ParentPortfolio: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func getParentPortfolio(for childId: Int?) {
       
        var params = [String: String]()
        
        if let id = childId {
            let params = ["student_id": String(id)]
        }
        
        ApiManager.shared.Request(type: ChildPortfolioModel.self, methodType: .Get, url: baseUrl+apiChildPortfolio, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async { [self] in
                    printt("CHILDPORTFOLIO \(myObject?.data)")
                    portfolioData = myObject
                    DispatchQueue.main.async { [self] in
                        
                        if myObject?.data?.count != 0 {
                        self.tableActivity?.reloadData()
                            labelNoPosts.isHidden = true
                            tableActivity.isHidden = false
                        }
                        else {
                            labelNoPosts.isHidden = false
                            tableActivity.isHidden = true
                            Toast.toast(message: "No activity posts yet", controller: self)
                        }
                    }
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableActivity {
            return self.portfolioData?.data?.count ?? 0
        } else {
            let count = self.activitiesData?.count ?? 0
            if count == 0 {
                activityTableView.setEmptyMessage("No activity found!")
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
            
            cell.labelName.text = data?.teacher?.name ?? ""
            cell.labelTitle.text = data?.title ?? ""
            cell.labelDomain.text = data?.domain?.name ?? ""
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
            //   cell.viewOuter.defaultShadow()
            
            cell.layer.cornerRadius = 20
            cell.backgroundColor = .clear
            return cell
        } else if tableView == activityTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as? ActivityCell
            let item = self.activitiesData?[indexPath.row]
            cell?.selectionStyle = .none
            cell?.startTimeLabel.text = item?.startTimeHours
            cell?.endTimeLabel.text = item?.endTimeHours
            cell?.titleLabel.text = item?.title
            cell?.descriptionLabel.text = item?.descriptions
            cell?.moreButton.isHidden = true
            return cell ?? UITableViewCell()
        } else if tableView == attendanceTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath) as? AttendanceCell
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
extension ParentPortfolio {
    
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

extension ParentPortfolio {
    
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

extension ParentPortfolio: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame = CGRect(origin: calendar.frame.origin , size: bounds.size)
        // Do other updates here
        print(CGRect(origin: calendar.frame.origin , size: bounds.size))
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        getChildDetailsApi(date: date.shortDate, childId: self.childrenData?[self.currentChildIndex].id)
    }
}

extension ParentPortfolio: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        childrenData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudentProfileCell", for: indexPath) as! StudentProfileCell
        let data = childrenData?[indexPath.row]
        cell.nameLabel.text = data?.name ?? ""
        cell.classLabel.text = "Class: \(data?.studentProfile?.className?.name ?? "")"
        
        cell.studentImage.sd_setImage(with: URL(string: imageBaseUrl+(data?.image ?? "")), placeholderImage: .placeholderImage)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print(childrenData?[indexPath.row].name)
    }
    
    func getAllChildsAPI()
    {
        
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    
                    printt("PARENT_ALL_CLASSES \(myObject?.data)")
                    
                    self.childrenData = myObject?.data
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
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
        
        if scrollView == self.studentProfileCollectionView {
            var visibleRect = CGRect()
            visibleRect.origin = studentProfileCollectionView.contentOffset
            visibleRect.size = studentProfileCollectionView.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = studentProfileCollectionView.indexPathForItem(at: visiblePoint) else { return }
            self.currentChildIndex = indexPath.item
            printt("Evening Collection Index \(indexPath.item)")
            getChildDetailsApi(date: calendar.selectedDate?.shortDate ?? Date().shortDate, childId: self.childrenData?[self.currentChildIndex].id)
        }
    }
    
    func getActivitiesAPI(date: String, studentId: Int?) {
        guard let studentId else { return }
        let params: [String: Any] = ["date": date,
                                     "user_id": studentId,
                                     "per_page": "30"
                           ]
        ApiManager.shared.Request(type: ActivitiesModel.self, methodType: .Get, url: baseUrl+getActivity, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    guard let data = myObject?.data?.data else { return }
                    self.activitiesData = data
                    self.activityTableView.reloadData()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
}
