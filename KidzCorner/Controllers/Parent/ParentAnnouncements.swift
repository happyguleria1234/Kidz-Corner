import UIKit

class ParentAnnouncements: UIViewController {
    
    var announcementsData: AnnouncementChildrenModel?
    var childrenData: [ChildData]?
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableAnnouncements: UITableView!
    
    @IBOutlet weak var labelNoAnnouncements: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupViews()
        getChildrenList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAnnouncements()
        
    }
    
    @IBAction func backFunc(_ sender: Any) {
        
    }
    
    func setupViews() {
        
    }
    
    func setupTable() {
        tableAnnouncements.register(UINib(nibName: "AnnouncementCell", bundle: nil), forCellReuseIdentifier: "AnnouncementCell")
        tableAnnouncements.delegate = self
        tableAnnouncements.dataSource = self
        tableAnnouncements.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = false
    }
    
    func getAnnouncements() {
        startAnimating((self.tabBarController?.view)!)
        let params = [String: String]()
        ApiManager.shared.Request(type: AnnouncementChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAnnouncement, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                
                print(myObject)
                
                self.announcementsData = myObject
                DispatchQueue.main.async { [self] in
                    if myObject?.data?.count != 0 {
                        tableAnnouncements.isHidden = false
                        tableAnnouncements.reloadData()
//                        labelNoAnnouncements.isHidden = true
                    }
                    else {
//                        labelNoAnnouncements.isHidden = false
                        tableAnnouncements.isHidden = true
                    }
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }

    func getChildrenList()
    {
        
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    
                    self.childrenData = myObject?.data
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    @IBAction func btnChats(_ sender: UIButton) {
        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatsVC") as? ChatsVC {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath) as! AnnouncementCell
        let data = self.announcementsData?.data?[indexPath.row]

        cell.labelTitle.text = data?.title
        cell.labelDate.text = data?.date ?? ""
        cell.imageAnnouncement.sd_setImage(with: URL(string: imageBaseUrl+(data?.attachment ?? "")), placeholderImage: .announcementPlaceholder)
        cell.viewOuter.defaultShadow()
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
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
}
