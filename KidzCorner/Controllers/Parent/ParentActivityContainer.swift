import UIKit

class ParentActivityContainer: UIViewController {
    
    var childInfo: ChildAttendanceModel?
    var portfolioData: ChildPortfolioModel?
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var viewOuter: UIView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelClass: UILabel!
    
    @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var viewAttendance: UIView!
    
    @IBOutlet weak var attendanceTriangle: UIView!
    @IBOutlet weak var activityTriangle: UIView!
    
    @IBOutlet weak var viewTable: UIView!
    
    @IBOutlet weak var tableActivity: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerTable()
        getChildDetailsApi(date: Date().shortDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getParentPortfolio()
        printt("Activity Container Appeared")
    }
    
    
    @IBAction func logoutFunc(_ sender: Any) {
        let sb = UIStoryboard(name: "Auth", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignIn") as! SignIn
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    
    @IBAction func activityButton(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
    
    func setupViews() {
        DispatchQueue.main.async { [self] in
        self.viewTable.layer.cornerRadius = 10
            self.viewTable.shadowWithRadius(radius: 10)
            viewOuter.defaultShadow()
            viewOuter.layer.cornerRadius = 20
            viewActivity.layer.cornerRadius = 20
            viewAttendance.layer.cornerRadius = 20
            setDownTriangle(triangleView: attendanceTriangle)
            setDownTriangle(triangleView: activityTriangle)
            
            activityTriangle.isHidden = false
            attendanceTriangle.isHidden = true
            
    }
    }
    
    func registerTable() {
        tableActivity.register(UINib(nibName: "DashboardTableCell", bundle: nil), forCellReuseIdentifier: "DashboardTableCell")
        tableActivity.delegate = self
        tableActivity.dataSource = self
    }
    
    func getChildDetailsApi(date: String) {
        
        var params = [String: String]()
        params = ["date": date,
                ]
        
        ApiManager.shared.Request(type: ChildAttendanceModel.self, methodType: .Get, url: baseUrl+apiChildAttendance, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {

                print(myObject)
                self.childInfo = myObject
                DispatchQueue.main.async {
                    self.setupChildDetails()
                }
                
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func setupChildDetails() {
        
        let data = self.childInfo?.data
        
        self.labelName.text = data?.children?.name ?? ""
        self.labelClass.text = "Class: \(data?.children?.studentProfile?.className?.name ?? "")"
        
        self.imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(data?.children?.image ?? "")), placeholderImage: .placeholderImage)
        
    }
    
    func getParentPortfolio() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
    
        let params = [String: String]()
        
        ApiManager.shared.Request(type: ChildPortfolioModel.self, methodType: .Get, url: baseUrl+apiChildPortfolio, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async { [self] in
                    
                    print(myObject)
                    portfolioData = myObject
                    DispatchQueue.main.async {
                        
                        if myObject?.data?.count != 0 {
                        self.tableActivity?.reloadData()
                        }
                        else {
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
}

extension ParentActivityContainer: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.portfolioData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableCell", for: indexPath) as! DashboardTableCell
        
        let data = self.portfolioData?.data?[indexPath.row]
        
        cell.cellContent = data?.portfolioImage
      
        cell.imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(data?.teacher?.image ?? "")), placeholderImage: .placeholderImage)
       
        cell.labelName.text = data?.teacher?.name ?? ""
        cell.labelTitle.text = data?.title ?? ""
        cell.labelDomain.text = data?.domain?.name ?? ""
        cell.labelDescription.text = data?.postContent ?? ""
        cell.labelTime.text = data?.postDate ?? ""
        
        cell.buttonLike.setImage(UIImage(named: "likeEmpty"), for: .normal)
        cell.buttonLike.setImage(UIImage(named: "likeFilled"), for: .selected)
        
        cell.buttonLike.tag = indexPath.row
        
      //  cell.buttonLike.addTarget(self, action: #selector(likeFunc), for: .touchUpInside)
        
     //   cell.viewOuter.defaultShadow()
        
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .clear
        return cell
    }
}
