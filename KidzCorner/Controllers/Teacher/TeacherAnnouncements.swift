import UIKit
import SDWebImage

class TeacherAnnouncements: UIViewController {
    
    var comesFrom = String()
    var announcementsData: AnnouncementModel?
    
    @IBOutlet weak var labelNoAnnouncements: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var tableAnnouncements: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAnnouncements()
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
    
    @IBAction func btnChats(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Parent", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatsVC") as? ChatsVC
        vc?.isComming = "Teachers"
        self.navigationController?.pushViewController(vc!, animated: true)
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
        if comesFrom != "Notif" {
            startAnimating((self.tabBarController?.view)!)
        }
        let params = [String: String]()
        ApiManager.shared.Request(type: AnnouncementModel.self, methodType: .Get, url: baseUrl+apiTeacherAnnouncement, parameter: params) { error, myObject, msgString, statusCode in
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
}

extension TeacherAnnouncements: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.descriptionLbl.attributedText = data?.description?.htmlAttributedString2()
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeacherAnnouncement") as! TeacherAnnouncement
        let data = self.announcementsData?.data?[indexPath.row]
        vc.anouncementData = data
        vc.announcementId = data?.id
        vc.announcementDate = data?.date
        vc.announcementTitle = data?.title
        vc.announcementDescription = data?.description
        vc.announcementImage = data?.file
        vc.announcementStatus = data?.status
        vc.announcementPDF = data?.attachment
        vc.announcementType = data?.announcementType
        vc.anouncementData = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
