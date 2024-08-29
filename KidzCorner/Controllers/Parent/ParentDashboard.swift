import UIKit

struct ButtonsData {
    var name: String
    var imgName: String
}

var selectedType = 0

class ParentDashboard: UIViewController {
    
    var dashboardData: [DashboardModelData]?
    var currentPage = 1
    var nextPage = 0
    var isLoading = false
    var portfolioData: [ChildPortfolioModelData]?
    var childrenData = [ChildData]()
    var childInfo: ChildAttendanceModel?
    var buttonsData = [ButtonsData]()
    
    @IBOutlet weak var buttonCollection: UICollectionView!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var collAttendance: UICollectionView!
    @IBOutlet weak var dateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var tableHome: UITableView!
    @IBOutlet weak var checkedInBtn: UIButton!
    @IBOutlet weak var checkInstatuslbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var collHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTable()
        updateTokens()
        buttonsData.append(ButtonsData(name: "Attendance", imgName: "Attendnce1"))
        buttonsData.append(ButtonsData(name: "Evaluation", imgName: "ratings"))
        buttonsData.append(ButtonsData(name: "Calender", imgName: "CalenderHome"))
        buttonsData.append(ButtonsData(name: "Portfolio", imgName: "Portfolio"))
        buttonsData.append(ButtonsData(name: "Finance", imgName: "Finance1"))
        buttonsData.append(ButtonsData(name: "Board", imgName: "broad"))
        buttonsData.append(ButtonsData(name: "Bulleting", imgName: "Bulleting and weekly update"))
        buttonsData.append(ButtonsData(name: "Weekly Update", imgName: "Framessss"))
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if comesForImages != "Images" {
            getDashboard()
            getChildrenList()
            getAllChildsAPI()
        }
        comesForImages = ""
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    
    @IBAction func buttonTap1(sender: UIButton) {
        print("1")
        selectedType = 1
        tabBarController?.selectedIndex = 3
    }
    
    @IBAction func buttonTap2(sender: UIButton) {
        selectedType = 0
        tabBarController?.selectedIndex = 3
    }
    
    @IBAction func buttonTap3(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Payments") as! Payments
        comesForImages = "Images"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonTap4(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Parent", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
        vc.comesFrom = "4"
        comesForImages = "Images"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonTap5(sender: UIButton) {
        print("5")
        let storyboard = UIStoryboard(name: "Parent", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
        vc.comesFrom = "1"
        comesForImages = "Images"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonTap6(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParentAnnouncements") as! ParentAnnouncements
        comesForImages = "Images"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //    MARK: CHECKED-IN BUTTON ACTION
    @IBAction func checkedInBtn(_ sender: UIButton) {
        
    }
    
    func setupViews() {
        
    }
    
    func setupCollectionView() {
        collAttendance.dataSource = self
        collAttendance.delegate = self
        if let layout = collAttendance.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        // Enable paging
        collAttendance.isPagingEnabled = true
    }
    
    func setupTable() {
        tableHome.register(UINib(nibName: "DashboardTableCell", bundle: nil), forCellReuseIdentifier: "DashboardTableCell")
        tableHome.delegate = self
        tableHome.dataSource = self
    }
    
    func getAllChildsAPI() {
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.childrenData = myObject?.data ?? []
                    self.getChildDetailsApi(date: Date().shortDate, childId: self.childrenData.first?.id)
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func updateTokens() {
        ApiManager.shared.Request(type: CommonModel.self, methodType: .Post, url: baseUrl + updateToken, parameter: ["token":UserDefaults.standard.string(forKey: myDeviceToken) ?? "123"]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func getChildDetailsApi(date: String, childId: Int?) {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        var params = [String: String]()
        if let id = childId {
            params = ["date": date,"student_id": String(id)]
        } else {
            params = ["date": date]
        }
        ApiManager.shared.Request(type: ChildAttendanceModel.self, methodType: .Get, url: baseUrl+apiChildAttendance, parameter: params) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async { [self] in
                if statusCode == 200 {
                    printt("CHILDATTENDANCE \(myObject?.data)")
                    self.childInfo = myObject
                    if childInfo?.data?.attendance != nil {
                        if childInfo?.data?.attendance?.timeIn != "" && childInfo?.data?.attendance?.timeOut != ""{
                            collHeight.constant = 60
                        } else {
                            collHeight.constant = 0
                        }
                    } else {
                        //                        collHeight.constant = 60
                        collHeight.constant = 0
                    }
                    self.collAttendance.reloadData()
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func updateToLatestVersion(latestVersion: String) {
        if let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            
            if let current = Double(currentVersion), let latest = Double(latestVersion) {
                if latest > current {
                    let alertController = UIAlertController(title: "Update Available",
                                                            message: "A new version of the app is available. Would you like to update?",
                                                            preferredStyle: .alert)
                    let updateAction = UIAlertAction(title: "Update", style: .default) { (_) in
                        if let url = URL(string: "https://apps.apple.com/app/1467363872"),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                    let cancelAction = UIAlertAction(title: "Later", style: .cancel, handler: nil)
                    alertController.addAction(updateAction)
                    alertController.addAction(cancelAction)
                    // Assuming this code is inside a UIViewController subclass
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func getDashboard(page: Int = 1) {
        let params: [String: String] = ["page": "\(page)", "per_page": "4"]
        self.isLoading = true
        ApiManager.shared.Request(type: DashboardModelNew.self, methodType: .Get, url: baseUrl+apiDashboard, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                
                if let latestVersion = myObject?.latest_version {
                    DispatchQueue.main.async {
                        self.updateToLatestVersion(latestVersion: latestVersion)
                    }
                }
                
                self.isLoading = false
                self.currentPage = myObject?.data?.currentPage ?? 1
                if myObject?.data?.nextPageURL != nil {
                    self.nextPage = self.currentPage + 1
                } else {
                    self.nextPage = 0
                }
                
                if self.currentPage == 1 {
                    self.dashboardData = myObject?.data?.data
                } else {
                    self.dashboardData?.append(contentsOf: myObject?.data?.data ?? [])
                }
                
                DispatchQueue.main.async {
                    self.tableHome.reloadData()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    @IBAction func didTapNotification(_ sender: Any) {
        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC {
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension ParentDashboard: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.portfolioData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableCell", for: indexPath) as! DashboardTableCell
        let data = self.portfolioData?[indexPath.row]
        cell.cellContent = self.portfolioData?[indexPath.row].portfolioImage
        cell.collectionImages.tag = indexPath.row
        cell.collectionImages.reloadData()
        cell.imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(data?.teacher?.image ?? "")), placeholderImage: .placeholderImage)
        cell.postData2 = data
        cell.comesFrom = "Parent"
        cell.labelName.text = data?.teacher?.name ?? ""
        cell.labelTitle.text = data?.title?.capitalized ?? ""
        cell.labelDescription.text = data?.postContent ?? ""
        cell.labelTime.text = data?.postDate ?? ""
        cell.viewComment.isHidden = true
        cell.labelDomain.text = data?.domain?.name ?? ""
        cell.buttonLike.setImage(UIImage(named: "likeEmpty"), for: .normal)
        cell.buttonLike.setImage(UIImage(named: "likeFilled"), for: .selected)
        
        if data?.isLike == 1 {
            cell.buttonLike.isSelected = true
        }
        else if data?.isLike == 0 {
            cell.buttonLike.isSelected = false
        }
        cell.view = self
        cell.buttonLike.tag = indexPath.row
        cell.buttonComment.tag = indexPath.row
        cell.buttonShare.tag = indexPath.row
        cell.buttonWriteComment.tag = indexPath.row
        
        cell.buttonLike.addTarget(self, action: #selector(likeFunc), for: .touchUpInside)
        cell.buttonComment.addTarget(self, action: #selector(commentFunc), for: .touchUpInside)
        cell.buttonWriteComment.addTarget(self, action: #selector(commentFunc), for: .touchUpInside)
        
        cell.labelComments.text = String(data?.totalComments ?? 0)
        printt("Unread \(data?.unreadComment ?? -1)")
        if data?.unreadComment == 1 {
            cell.hideUnreadCommentViews(false)
        }
        else {
            cell.hideUnreadCommentViews(true)
        }
        cell.labelLikes.text = String(data?.totalLikes ?? 0)
        cell.viewOuter.defaultShadow()
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}

//MARK: Obj-C Functions
extension ParentDashboard {
    @objc func likeFunc(sender: UIButton) {
        print(sender.tag)
        likeAPI(row: sender.tag)
    }
    @objc func commentFunc(sender: UIButton) {
        print("CommentFunc")
        
        let vc = Comments().instance() as! Comments
        vc.portfolioId = self.portfolioData?[sender.tag].id ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Like Comment Functions
extension ParentDashboard {
    
    func likeAPI(row: Int) {
        var params: [String: String]
        params = ["portfolio_id": String(self.portfolioData?[row].id ?? 0)]
        ApiManager.shared.Request(type: LikeModel.self, methodType: .Post, url: baseUrl+apiLikePortfolio, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                let totalLikes = (self.portfolioData?[row].totalLikes ?? 0)
                let rowToReload = IndexPath(row: row, section: 0)
                if myObject?.data == 1 {
                    self.portfolioData?[row].isLike = 1
                    self.portfolioData?[row].totalLikes = totalLikes + 1
                }
                else if myObject?.data == 2 {
                    self.portfolioData?[row].isLike = 0
                    self.portfolioData?[row].totalLikes = totalLikes - 1
                }
                DispatchQueue.main.async {
                    self.tableHome.reloadRows(at: [rowToReload], with: .automatic)
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func getParentPortfolio(for childId: Int?, completion: @escaping ([ChildPortfolioModelData]?) -> Void) {
        
        var params = [String: String]()
        
        if let id = childId {
            params = ["student_id": String(id)]
        }
        
        ApiManager.shared.Request(type: ChildPortfolioModel.self, methodType: .Get, url: baseUrl+apiChildPortfolio, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    completion(myObject?.data)
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func getChildrenList()
    {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    
                    if let data = myObject?.data {
                        let group = DispatchGroup()
                        
                        let dateFormatter = ISO8601DateFormatter()
                        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                        
                        var firstChildData = true
                        for child in data {
                            group.enter()
                            self.getParentPortfolio(for: child.id) { portfolioData in
                                if let portfolio = portfolioData {
                                    
                                    if firstChildData {
                                        self.portfolioData = portfolio
                                        firstChildData = false
                                    }
                                    else {
                                        for newPost in portfolio {
                                            if !(self.portfolioData?.contains(where: { $0.id == newPost.id }) ?? false) {
                                                self.portfolioData?.append(newPost)
                                            }
                                        }
                                    }
                                }
                                group.leave()
                            }
                        }
                        
                        group.notify(queue: .main) { [self] in
                            
                            self.portfolioData?.sort { firstData, secondData in
                                if let firstDate = dateFormatter.date(from: firstData.createdAt ?? ""),
                                   let secondDate = dateFormatter.date(from: secondData.createdAt ?? "") {
                                    // Return true if firstDate should come before secondDate
                                    return firstDate > secondDate
                                }
                                return false
                            }
                            
                            if let data = self.portfolioData {
                                for post in data {
                                    printt("CREATED AT \(post.createdAt ?? "")")
                                }
                            }
                            if portfolioData?.count != 0 {
                                DispatchQueue.main.async {
                                    self.tableHome.reloadData()
                                }
                            }
                            else {
                                Toast.toast(message: "No activity posts yet", controller: self)
                            }
                        }
                    }
                    else {
                        Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                    }
                    
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
}


class AttandenceCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblChekIn: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ParentDashboard: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == buttonCollection {
            return 4
        } else {
            return childrenData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == buttonCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonsCell", for: indexPath) as! ButtonsCell
            switch indexPath.row {
            case 0:
                cell.lblName.text = buttonsData[0].name
                cell.iconImg.image = UIImage(named: buttonsData[0].imgName)
                cell.name2.text = buttonsData[1].name
                cell.img2.image = UIImage(named: buttonsData[1].imgName)
            case 1:
                cell.lblName.text = buttonsData[2].name
                cell.iconImg.image = UIImage(named: buttonsData[2].imgName)
                cell.name2.text = buttonsData[3].name
                cell.img2.image = UIImage(named: buttonsData[3].imgName)
            case 2:
                cell.lblName.text = buttonsData[4].name
                cell.iconImg.image = UIImage(named: buttonsData[4].imgName)
                cell.name2.text = buttonsData[5].name
                cell.img2.image = UIImage(named: buttonsData[5].imgName)
            case 3:
                cell.lblName.text = buttonsData[6].name
                cell.iconImg.image = UIImage(named: buttonsData[6].imgName)
                cell.name2.text = buttonsData[7].name
                cell.img2.image = UIImage(named: buttonsData[7].imgName)
            default:
                break
            } 
            cell.btn1Tap.tag = indexPath.row
            cell.btn2Tap.tag = indexPath.row
            cell.btn1Tap.addTarget(self, action: #selector(gotoScreens(sender:)), for: .touchUpInside)
            cell.btn2Tap.addTarget(self, action: #selector(gotoScreens2(sender:)), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttandenceCell", for: indexPath) as! AttandenceCell
            if childInfo?.data?.attendance?.timeIn != "" && childInfo?.data?.attendance?.timeOut == nil{
                cell.lblChekIn.text = "Checked In"
                cell.lblDate.text = childInfo?.data?.attendance?.timeIn ?? ""
            } else if childInfo?.data?.attendance?.timeOut != "" && childInfo?.data?.attendance?.timeIn != ""{
                cell.lblChekIn.text = "Checked Out"
                cell.lblDate.text = childInfo?.data?.attendance?.timeOut ?? ""
            } else {
                cell.lblChekIn.text = "Check In"
            }
            return cell
        }
    }
    
    @objc func gotoScreens(sender: UIButton) {
        switch sender.tag {
        case 0:
            selectedType = 1
            tabBarController?.selectedIndex = 3
        case 1:
            selectedType = 0
            tabBarController?.selectedIndex = 3
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Payments") as! Payments
            comesForImages = "Images"
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let storyboard = UIStoryboard(name: "Parent", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
            vc.comesFrom = "5"
            comesForImages = "Images"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    @objc func gotoScreens2(sender: UIButton) {
        switch sender.tag {
        case 0:
            let storyboard = UIStoryboard(name: "Parent", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
            vc.comesFrom = "4"
            comesForImages = "Images"
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "Parent", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
            vc.comesFrom = "1"
            comesForImages = "Images"
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            
            let storyboard = UIStoryboard(name: "Parent", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
            vc.comesFrom = "6"
            comesForImages = "Images"
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            
            let storyboard = UIStoryboard(name: "Parent", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
            vc.comesFrom = "7"
            comesForImages = "Images"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == buttonCollection {
            let noOfCellsInRow = 3
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: size)
        } else {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        let previousPage = Int((scrollView.contentOffset.x + scrollView.frame.size.width) / pageWidth)
        if currentPage > previousPage {
            let childId = childrenData[currentPage].id ?? 0
            self.getChildDetailsApi(date: Date().shortDate, childId: childId)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collAttendance.collectionViewLayout.invalidateLayout()
    }
}


class ButtonsCell: UICollectionViewCell {
    
    @IBOutlet weak var btn2Tap: UIButton!
    @IBOutlet weak var btn1Tap: UIButton!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
