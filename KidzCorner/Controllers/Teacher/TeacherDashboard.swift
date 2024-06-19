import UIKit

class TeacherDashboard: UIViewController {
    
    var dashboardData: [DashboardModelData]?
    var currentPage = 1
    var nextPage = 0
    var isLoading = false
   
    
    @IBOutlet weak var tableHome: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTable()
        
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDashboard()
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
    
    func setupViews() {
        
    }
    func setupTable() {
        tableHome.register(UINib(nibName: "DashboardTableCell", bundle: nil), forCellReuseIdentifier: "DashboardTableCell")
        tableHome.delegate = self
        tableHome.dataSource = self
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
                }
            }
        }
    }
    
    func getDashboard(page: Int = 1) {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        
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
}

extension TeacherDashboard: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.dashboardData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTypesCell", for: indexPath) as! DashboardTypesCell
            cell.btnTap1.addTarget(self, action: #selector(buttonTap1(sender:)), for: .touchUpInside)
            cell.btnTap2.addTarget(self, action: #selector(buttonTap2(sender:)), for: .touchUpInside)
            cell.btnTap3.addTarget(self, action: #selector(buttonTap3(sender:)), for: .touchUpInside)
            cell.btnTap4.addTarget(self, action: #selector(buttonTap4(sender:)), for: .touchUpInside)
            cell.btnTap5.addTarget(self, action: #selector(buttonTap5(sender:)), for: .touchUpInside)
            cell.btnTap6.addTarget(self, action: #selector(buttonTap6(sender:)), for: .touchUpInside)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableCell", for: indexPath) as! DashboardTableCell
            
            let data = self.dashboardData?[indexPath.row]
            
            cell.cellContent = self.dashboardData?[indexPath.row].portfolioImage
            cell.collectionImages.tag = indexPath.row
            cell.collectionImages.reloadData()
            
            cell.imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(data?.teacher?.image ?? "")), placeholderImage: .placeholderImage)
            cell.postData = data
            cell.labelName.text = data?.teacher?.name ?? ""
            cell.labelTitle.text = data?.title ?? ""
            cell.labelDescription.text = data?.postContent ?? ""
            cell.labelTime.text = data?.postDate ?? ""
            cell.labelDomain.text = data?.domain?.name ?? ""
            cell.buttonLike.setImage(UIImage(named: "likeEmpty"), for: .normal)
            cell.buttonLike.setImage(UIImage(named: "likeFilled"), for: .selected)
            if data?.is_collage == 0 {
                cell.collectionHeight.constant = 350
            } else {
                cell.collectionHeight.constant = 280
            }
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
    }
    
    @objc func buttonTap1(sender: UIButton) {
        print("1")
        tabBarController?.selectedIndex = 2
    }
    
    @objc func buttonTap2(sender: UIButton) {
        print("2")
    }
    
    @objc func buttonTap3(sender: UIButton) {
        print("3")
        tabBarController?.selectedIndex = 3
    }
    
    @objc func buttonTap4(sender: UIButton) {
        print("4")
    }
    
    @objc func buttonTap5(sender: UIButton) {
        print("5")
    }
    
    @objc func buttonTap6(sender: UIButton) {
        print("6")
        tabBarController?.selectedIndex = 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 330
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - tableViewHeight - 100 && self.nextPage != 0 && !isLoading {
            getDashboard(page: nextPage)
        }
    }
}

//MARK: Obj-C Functions
extension TeacherDashboard {
    
    @objc func likeFunc(sender: UIButton) {
        print(sender.tag)
        likeAPI(row: sender.tag)
    }
    @objc func commentFunc(sender: UIButton) {
        print("CommentFunc")
        
        let vc = Comments().instance() as! Comments
        vc.portfolioId = self.dashboardData?[sender.tag].id ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: Like Comment Functions

extension TeacherDashboard {
    
    func likeAPI(row: Int) {
        var params: [String: String]
        params = ["portfolio_id": String(self.dashboardData?[row].id ?? 0)]
        ApiManager.shared.Request(type: LikeModel.self, methodType: .Post, url: baseUrl+apiLikePortfolio, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                let totalLikes = (self.dashboardData?[row].totalLikes ?? 0)
                let rowToReload = IndexPath(row: row, section: 0)
                if myObject?.data == 1 {
                    self.dashboardData?[row].isLike = 1
                    self.dashboardData?[row].totalLikes = totalLikes + 1
                }
                else if myObject?.data == 2 {
                    self.dashboardData?[row].isLike = 0
                    self.dashboardData?[row].totalLikes = totalLikes - 1
                }
                
                    self.tableHome.reloadRows(at: [rowToReload], with: .automatic)
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
}
