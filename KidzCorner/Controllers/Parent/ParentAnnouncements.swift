import UIKit

class ParentAnnouncements: UIViewController {
    
    var announcementsData: AnnouncementChildrenModel?
    var childrenData: [ChildData]?
    var comesFrom = String()
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
        let params = [String: String]()
        ApiManager.shared.Request(type: AnnouncementChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAnnouncement, parameter: params) { error, myObject, msgString, statusCode in
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
        let userProfileUrl = URL(string: imageBaseUrl+(data?.attachment ?? ""))
        cell.imgCell.kf.setImage(with: userProfileUrl,placeholder: UIImage(named: "placeholderImage"))
//        cell.imgCell.sd_setImage(with: URL(string: imageBaseUrl+(data?.attachment ?? "")), placeholderImage: .announcementPlaceholder)
        
//        cell.descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
//        cell.descriptionLbl.heightAnchor.constraint(equalToConstant: cell.descriptionLbl.frame.height).isActive = true
//        cell.layoutIfNeeded()
        if let attributedText = data?.announcmentDescription?.htmlAttributedString() {
            cell.descriptionLbl.attributedText = attributedText
            cell.descriptionLbl.adjustHeight(maxLines: 4)
        }
        cell.descriptionLbl.attributedText = data?.announcmentDescription?.htmlAttributedString()
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParentAnnouncement") as! ParentAnnouncement
        
        let data = self.announcementsData?.data?[indexPath.row]
        
        if let childData = childrenData {
            for child in childData {
                
                printt("Announcement Child Id \(data?.userID) Parent Child Id \(child.id)")
                
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
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
   
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


func configureLabel(_ label: UILabel) {
    // Set the maximum number of lines
    label.numberOfLines = 3 // Set this to your desired maximum number of lines

    // Set the minimum scale factor to scale down the text if needed
    label.minimumScaleFactor = 0.5 // This scales the text down to 50% of its original size if needed

    // Optionally set adjustsFontSizeToFitWidth to true if you want the text to adjust its font size to fit the width
    label.adjustsFontSizeToFitWidth = true

    // Optionally set line break mode if needed
    label.lineBreakMode = .byTruncatingTail // You can choose other modes like .byWordWrapping, .byCharWrapping, etc.
}
