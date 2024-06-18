import UIKit
import SDWebImage

class TeacherAnnouncements: UIViewController {
    
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
    }
    
    @IBAction func btnChats(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Parent", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatsVC") as? ChatsVC
        vc?.isComming = "Teachers"
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    func setupViews() {
        
    }
    func setupTable() {
        tableAnnouncements.register(UINib(nibName: "AnnouncementCell", bundle: nil), forCellReuseIdentifier: "AnnouncementCell")
        tableAnnouncements.delegate = self
        tableAnnouncements.dataSource = self
        tableAnnouncements.backgroundColor = .clear
    }
    
    func getAnnouncements() {
    
        startAnimating((self.tabBarController?.view)!)
        let params = [String: String]()
       
        ApiManager.shared.Request(type: AnnouncementModel.self, methodType: .Get, url: baseUrl+apiTeacherAnnouncement, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.announcementsData = myObject
               // print(myObject)
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
}

extension TeacherAnnouncements: UITableViewDelegate, UITableViewDataSource {
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
        
        print("File \(data?.file)")
        
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
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
