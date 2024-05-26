import UIKit

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkViewType()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptFunc(_ sender: Any) {
        acceptRejectAnnouncement(status: "1")
    }
    
    @IBAction func denyFunc(_ sender: Any) {
        acceptRejectAnnouncement(status: "2")
    }
    
    @IBAction func didTapAttachment(_ sender: Any) {
        //        if announcementPDF?.contains(".pdf") == true {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PdfVC2") as! PdfVC2
        vc.anouncementData = anouncementData
        self.navigationController?.pushViewController(vc, animated: true)
        //        } else {
        //            if let urlStr = self.anouncementData?.attachment, let url = URL(string: imageBaseUrl + urlStr) {
        //                UIApplication.shared.open(url)
        //            }
        //        }
    }
    
    func checkViewType() {
        
        print("AType \(announcementType)")
        print("AStatus \(announcementStatus)")
        
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
            viewOuter.giveShadowAndRoundCorners(shadowOffset: CGSize.zero, shadowRadius: 10, opacity: 0.2, shadowColor: .black, cornerRadius: 10)
            imageAnnouncement.layer.cornerRadius = imageAnnouncement.bounds.height/2.0
            buttonAccept.layer.cornerRadius = 10
            buttonDeny.layer.cornerRadius = 10
            
            // ALSO IMAGE ANNOUNCEMENT
            labelTitle.text = announcementTitle ?? ""
            labelDescription.text = announcementDescription ?? ""
            imageAnnouncement.sd_setImage(with: URL(string: imageBaseUrl+(announcementImage ?? "")), placeholderImage: .announcementPlaceholder)
            labelDate.text = announcementDate
//            
//            if let url = self.anouncementData?.attachment  {
//                self.attachmentLabel.text = "Attachment" + "." + (URL(string: imageBaseUrl + url)?.pathExtension ?? "")
//                self.attachmentLabel.superview?.isHidden = false
//            } else {
//                self.attachmentLabel.superview?.isHidden = true
//            }
            
            if self.announcementPDF != "" {
                self.attachmentLabel.text = "Attachment" + "." + (URL(string: imageBaseUrl + (announcementPDF ?? ""))?.pathExtension ?? "")
                self.attachmentLabel.superview?.isHidden = false
            } else {
                self.attachmentLabel.text = "Attachment" + "." + (URL(string: imageBaseUrl + (announcementPDF ?? ""))?.pathExtension ?? "")
                self.attachmentLabel.superview?.isHidden = false
            }
            
        }
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
        
        if anouncementData?.attachment == nil && anouncementData?.file == nil{
            viewPFD.isHidden = true
        } else {
            viewPFD.isHidden = false
        }
    }
    
    ///Status = 0 - Not Read, 1 - Accept, 2 - Reject
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
