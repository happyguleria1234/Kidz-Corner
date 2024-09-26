import UIKit
import Lightbox

class TeacherAnnouncement: UIViewController {
    
    var anouncementData: AnnouncementModelData?
    var announcementId: Int?
    var announcementStatus: Int?
    var announcementTitle: String?
    var announcementDescription: String?
    var announcementDate: String?
    var announcementImage: String?
    var announcementType: Int?
    var announcementPDF: String?
    var comesFrom = String()
    var attachmentArray = [String]()
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblAnnouncement: UITableView!
    @IBOutlet weak var viewPFD: UIStackView!
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var imageAnnouncement: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var buttonDeny: UIButton!
    @IBOutlet weak var attachmentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tblAnnouncement.register(UINib(nibName: "PaymentAnnouncementCell", bundle: nil), forCellReuseIdentifier: "PaymentAnnouncementCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkViewType()
        self.tabBarController?.tabBar.isHidden = true
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
    
    @IBAction func acceptFunc(_ sender: Any) {
        acceptRejectAnnouncement(status: "1")
    }
    
    @IBAction func denyFunc(_ sender: Any) {
        acceptRejectAnnouncement(status: "2")
    }
    
    @IBAction func didTapAttachment(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PdfVC2") as! PdfVC2
        vc.anouncementData = anouncementData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkViewType() {
        
        switch announcementType {
        case 1:
            stackButtons.isHidden = false
        case 2:
            stackButtons.isHidden = true
            labelStatus.isHidden = true
        default:
            stackButtons.isHidden = true
            labelStatus.isHidden = true
        }
        setupAnnouncementStatus()
    }
    
    func setupViews() {
        DispatchQueue.main.async { [self] in
            imageAnnouncement.layer.cornerRadius = 10
            buttonAccept.layer.cornerRadius = 10
            buttonDeny.layer.cornerRadius = 10
            
            // ALSO IMAGE ANNOUNCEMENT
            labelTitle.text = announcementTitle ?? ""
            //            labelDescription.text = announcementDescription ?? ""
            labelDescription.attributedText = announcementDescription?.htmlAttributedString()
//            imageAnnouncement.sd_setImage(with: URL(string: imageBaseUrl+(anouncementData?.file ?? "")), placeholderImage: .announcementPlaceholder)
            let userProfileUrl = URL(string: imageBaseUrl+(anouncementData?.file ?? ""))
            imageAnnouncement.kf.setImage(with: userProfileUrl, placeholder: UIImage(named: "placeholderImage"))
            labelDate.text = announcementDate
            if self.announcementPDF != "" {
                self.attachmentLabel.text = "Attachment" + "." + (URL(string: imageBaseUrl + (announcementPDF ?? ""))?.pathExtension ?? "")
                self.attachmentLabel.superview?.isHidden = false
            } else {
                self.attachmentLabel.text = "Attachment" + "." + (URL(string: imageBaseUrl + (announcementPDF ?? ""))?.pathExtension ?? "")
                self.attachmentLabel.superview?.isHidden = false
            }
            
        }
    }
    
    func getArray(attachment: String?) {
        attachmentArray = attachment?.components(separatedBy: ",") ?? []
        tblAnnouncement.reloadData()
    }
    
    func setupAnnouncementStatus() {
        if announcementType == 1 {
            switch announcementStatus {
            case 0:
                labelStatus.isHidden = true
                stackButtons.isHidden = false
            case 1:
                ///Accepted
                stackButtons.isHidden = true
                labelStatus.isHidden = false
                labelStatus.text = "Accepted"
                self.attachmentLabel.superview?.isHidden = false
                labelStatus.textColor = UIColor(named: "acceptColor")
            case 2:
                ///Rejected
                stackButtons.isHidden = true
                labelStatus.isHidden = false
                labelStatus.text = "Rejected"
                labelStatus.textColor = UIColor(named: "denyColor")
                ///Not Defined
            case .none:
                printt("None")
                labelStatus.isHidden = true
                stackButtons.isHidden = false
            case .some(_):
                printt("Some")
                labelStatus.isHidden = true
                stackButtons.isHidden = false
            }
        }
        
        if anouncementData?.attachment != nil{
            getArray(attachment: anouncementData?.attachment ?? "")
        }
    }
    
    func acceptRejectAnnouncement(status: String) {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        var params = [String: String]()
        params = ["announcement_id": String(self.announcementId ?? 0),
                  "status": status]
        
        ApiManager.shared.Request(type: BaseModel.self, methodType: .Post, url: baseUrl+apiAcceptRejectAnnouncement, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
}

extension TeacherAnnouncement: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachmentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentAnnouncementCell", for: indexPath) as! PaymentAnnouncementCell
        cell.attachmentLbl.text = extractFileName(from: attachmentArray[indexPath.row])
        DispatchQueue.main.async {
            self.tblHeight.constant = self.tblAnnouncement.contentSize.height
        }
        cell.attachmentBtn.tag = indexPath.row
        cell.attachmentBtn.addTarget(self, action: #selector(loadData(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func loadData(sender: UIButton) {
        if attachmentArray[sender.tag].contains(".pdf") == true {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
            vc.invoiceId = 0
            if let urls = URL(string: imageBaseUrl + (self.attachmentArray[sender.tag])) {
                vc.pdfURL = urls
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            var images = [LightboxImage]()
            images.append(LightboxImage(imageURL: URL(string: imageBaseUrl + (self.attachmentArray[sender.tag]))!))
            let controller = LightboxController(images: images,startIndex: 0)
            controller.dynamicBackground = true
            self.present(controller, animated: true)
        }
    }
}


func extractFileName(from filePath: String) -> String {
    // Use NSString to get the last path component
    let fileName = (filePath as NSString).lastPathComponent
    return fileName
}
