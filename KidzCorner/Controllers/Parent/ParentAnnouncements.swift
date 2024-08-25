import UIKit

class ParentAnnouncements: UIViewController {
    
    @IBOutlet weak var lbl_title: UILabel!
    var announcementsData: AnnouncementChildrenModel?
    var childrenData: [ChildData]?
    var comesFrom = String()
    var type = String()
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableAnnouncements: UITableView!
    
    @IBOutlet weak var labelNoAnnouncements: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupViews()
        getChildrenList()
        getAnnouncements()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func backFunc(_ sender: Any) {
        if comesFrom == "" {
            self.navigationController?.popViewController(animated: true)
        } else {
            let roleId = UserDefaults.standard.integer(forKey: myRoleId)
            if roleId == 4 {
                gotoHome()
            } else {
                gotoHomeTeacher()
            }
        }
    }
    
    func setupViews() {
        switch type {
        case "announcement":
            lbl_title.text = "Announcement"
        case "weekly_update":
            lbl_title.text = "Weekly Update"
        case "bulleting":
            lbl_title.text = "Bulleting"
        default:
            break
        }
    }
    
    func setupTable() {
        tableAnnouncements.register(UINib(nibName: "ParentAnnouncementCell", bundle: nil), forCellReuseIdentifier: "ParentAnnouncementCell")
        tableAnnouncements.delegate = self
        tableAnnouncements.dataSource = self
        tableAnnouncements.backgroundColor = .clear
        
    }
    
    func getAnnouncements() {
        if comesFrom == "" {
            startAnimating((self.tabBarController?.view)!)
        }
        let params = ["componse_type": type]
        ApiManager.shared.Request(type: AnnouncementChildrenModel.self, methodType: .Get, url: baseUrl+evulationData, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.announcementsData = myObject
                DispatchQueue.main.async { [self] in
                    if myObject?.data?.count != 0 {
                        tableAnnouncements.isHidden = false
                        tableAnnouncements.reloadData()
                    } else {
                        tableAnnouncements.isHidden = true
                    }
                }
            } else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }

    func getChildrenList() {
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.childrenData = myObject?.data
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    @IBAction func btnChats(_ sender: UIButton) {
        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatsVC") as? ChatsVC {
            nextVC.isComming = "Parent"
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    @IBAction func didTapNotification(_ sender: UIButton) {
        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC {
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension ParentAnnouncements: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.announcementsData?.data?.count ?? 0
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParentAnnouncementCell", for: indexPath) as! ParentAnnouncementCell
        let data = self.announcementsData?.data?[indexPath.row]
        
        cell.nameLbl.text = data?.title
        cell.dateLbl.text = data?.date ?? ""
        cell.lblName.text = data?.user?.name
        let userProfileUrl = URL(string: imageBaseUrl + (data?.file ?? ""))
        cell.imgCell.kf.setImage(with: userProfileUrl, placeholder: UIImage(named: "placeholderImage"))
        cell.descriptionLbl.attributedText = data?.announcmentDescription?.htmlAttributedString2()
        
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == "bulleting" {
            if let urls = URL(string: imageBaseUrl + (self.announcementsData?.data?[indexPath.row].file ?? "")) {
                UIApplication.shared.open(urls)
            }
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParentAnnouncement") as! ParentAnnouncement
            let data = self.announcementsData?.data?[indexPath.row]
            if let childData = childrenData {
                for child in childData {
                    if child.id == data?.userID {
                        vc.childName = child.name?.capitalized
                    }
                }
            }
            vc.announcementId = data?.id
            vc.announcementDate = data?.date
            vc.announcementTitle = data?.title
            vc.announcementDescription = data?.announcmentDescription
            vc.announcementImage = data?.file
            vc.announcementStatus = data?.status
            vc.announcementType = data?.announcementType
            vc.announcementPDF = data?.attachment
            vc.anouncementData = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension UIView {
    /// show drop shadow under view
    /// - Parameter scale: bool variable to enable scaling
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1

    }
}
