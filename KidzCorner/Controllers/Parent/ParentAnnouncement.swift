import UIKit

class ParentAnnouncement: UIViewController {
    
    var childName: String?
    var announcementId: Int?
    var announcementStatus: Int?
    var announcementTitle: String?
    var announcementDescription: String?
    var announcementDate: String?
    var announcementImage: String?
    var announcementType: Int?
    var announcementPDF: String?
    var anouncementData: AnnouncementChildrenModelData?

    @IBOutlet weak var viewPFD: UIStackView!
    @IBOutlet weak var viewOuter: UIView!
    
    @IBOutlet weak var lblFile: UILabel!
    @IBOutlet weak var imageAnnouncement: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var buttonDeny: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViews()
        checkViewType()
        
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAttachment(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PdfVC") as! PdfVC
        vc.anouncementData = anouncementData
        self.navigationController?.pushViewController(vc, animated: true)
//
//        if let urlStr = self.announcementPDF, let url = URL(string: imageBaseUrl + urlStr) {
//            UIApplication.shared.open(url)
//        }
    }
    
    @IBAction func acceptFunc(_ sender: Any) {
        acceptRejectAnnouncement(status: "1")
    }
    
    @IBAction func denyFunc(_ sender: Any) {
        acceptRejectAnnouncement(status: "2")
    }
    
    func checkViewType() {
        switch announcementType {
        case 1:
//            viewPFD.isHidden = false
            stackButtons.isHidden = false
        case 2:
            stackButtons.isHidden = true
            labelStatus.isHidden = true
        default:
//            viewPFD.isHidden = true
            stackButtons.isHidden = true
            labelStatus.isHidden = true
        }
        
        if anouncementData?.attachment == nil{
            viewPFD.isHidden = true
        } else {
            if anouncementData?.attachment?.contains(".pfd") == true {
                lblFile.text = "announcement.pfd"
            } else {
                lblFile.text = "image.jpg"
            }
            viewPFD.isHidden = false
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
            imageAnnouncement.sd_setImage(with: URL(string: imageBaseUrl+(anouncementData?.file ?? "")), placeholderImage: .announcementPlaceholder)
            labelDate.text = announcementDate
            labelName.text = "\(childName ?? "")"
            
        }
    }
    
    func setupAnnouncementStatus() {
        if announcementType == 1 {
            switch announcementStatus {
            case 0:
                stackButtons.isHidden = false
                labelStatus.text = ""
                viewPFD.isHidden = false
            case 1:
                //Accepted
                stackButtons.isHidden = true
                labelStatus.isHidden = false
                labelStatus.text = "Accepted"
                labelStatus.textColor = UIColor(named: "acceptColor")
                if announcementPDF != "" {
                    viewPFD.isHidden = false
                } else if announcementType == 1 {
                    viewPFD.isHidden = true
                }
            case 2:
                //Rejected
                stackButtons.isHidden = true
                labelStatus.isHidden = false
                labelStatus.text = "Rejected"
                viewPFD.isHidden = true
                labelStatus.textColor = UIColor(named: "denyColor")
                //Not Defined
            case .none:
                printt("None")
                viewPFD.isHidden = true
            case .some(_):
                printt("Some")
                viewPFD.isHidden = true
            }
        }
        if anouncementData?.attachment == nil{
            viewPFD.isHidden = true
        } else {
            viewPFD.isHidden = false
        }
    }

    //Status = 0 - Not Read, 1 - Accept, 2 - Reject
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
