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
    
    @IBOutlet weak var lblTitle2: UILabel!
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
        self.tabBarController?.tabBar.isHidden = true
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
            stackButtons.isHidden = false
        case 2:
            stackButtons.isHidden = true
            labelStatus.isHidden = true
        default:
            stackButtons.isHidden = true
            labelStatus.isHidden = true
        }
        
        if anouncementData?.attachment == nil{
            viewPFD.isHidden = true
        } else {
            if anouncementData?.attachment?.contains(".pdf") == true {
                lblFile.text = "announcement.pdf"
            } else {
                lblFile.text = "image.jpg"
            }
            viewPFD.isHidden = false
        }
        setupAnnouncementStatus()
    }
    
    func setupViews() {
        DispatchQueue.main.async { [self] in
//            viewOuter.giveShadowAndRoundCorners(shadowOffset: CGSize.zero, shadowRadius: 10, opacity: 0.2, shadowColor: .black, cornerRadius: 10)
            imageAnnouncement.layer.cornerRadius = 10
            buttonAccept.layer.cornerRadius = 10
            buttonDeny.layer.cornerRadius = 10
            
            // ALSO IMAGE ANNOUNCEMENT
            labelTitle.text = announcementTitle ?? ""
            labelDescription.text = announcementDescription ?? ""
            labelDescription.attributedText = announcementDescription?.htmlAttributedString()
            let userProfileUrl = URL(string: imageBaseUrl+(anouncementData?.file ?? ""))
            imageAnnouncement.kf.setImage(with: userProfileUrl, placeholder: UIImage(named: "placeholderImage"))

//            imageAnnouncement.sd_setImage(with: URL(string: imageBaseUrl+(anouncementData?.file ?? "")), placeholderImage: .announcementPlaceholder)
            labelDate.text = announcementDate
            lblTitle2.text = "\(childName ?? "")"
            
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

extension String {
    func htmlAttributedString2(fontSize: CGFloat = 13, headingFontSize: CGFloat = 17) -> NSAttributedString? {
        // Remove <br> tags and any resulting double spaces
        let cleanedHTMLString = self.replacingOccurrences(of: "<br>", with: "")
            .replacingOccurrences(of: "<br/>", with: "")
            .replacingOccurrences(of: "<br />", with: "")
            .replacingOccurrences(of: "\n\n", with: "\n")
        
        guard let data = cleanedHTMLString.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }

        do {
            let attributedString = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf16.rawValue
                ],
                documentAttributes: nil
            )

            let fullRange = NSRange(location: 0, length: attributedString.length)
            
            // Set the text color to rgba(113, 117, 118, 1)
            let customColor = UIColor(red: 113/255, green: 117/255, blue: 118/255, alpha: 1)
            attributedString.addAttribute(.foregroundColor, value: customColor, range: fullRange)

            // Adjust the paragraph style to remove any extra spacing
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 0 // Set line spacing to 0 to remove extra space
            paragraphStyle.paragraphSpacing = 0 // Set paragraph spacing to 0 to remove extra space
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)

            // Adjust fonts based on the HTML tags
            attributedString.enumerateAttribute(.font, in: fullRange) { value, range, _ in
                if let font = value as? UIFont {
                    var resizedFont: UIFont

                    // Check if range is within a specific HTML tag
                    let paragraphRange = (self as NSString).range(of: "<p>")
                    let headingRange = (self as NSString).range(of: "<h")

                    // Adjust font size based on HTML tag
                    if range.location >= paragraphRange.location && range.location < paragraphRange.location + paragraphRange.length {
                        resizedFont = UIFont(name: "Poppins-Regular", size: fontSize) ?? font.withSize(fontSize)
                    } else if range.location >= headingRange.location && range.location < headingRange.location + headingRange.length {
                        resizedFont = UIFont(name: "Poppins-Bold", size: headingFontSize) ?? font.withSize(headingFontSize)
                    } else {
                        resizedFont = UIFont(name: "Poppins-Regular", size: fontSize) ?? font.withSize(fontSize)
                    }

                    attributedString.addAttribute(.font, value: resizedFont, range: range)
                }
            }

            return attributedString
        } catch {
            return nil
        }
    }
}

extension String {
    func htmlAttributedString(fontSize: CGFloat = 15, headingFontSize: CGFloat = 19) -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }

        do {
            let attributedString = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf16.rawValue
                ],
                documentAttributes: nil
            )

            let fullRange = NSRange(location: 0, length: attributedString.length)
            
            // Set the text color to rgba(113, 117, 118, 1)
            let customColor = UIColor(red: 113/255, green: 117/255, blue: 118/255, alpha: 1)
            attributedString.addAttribute(.foregroundColor, value: customColor, range: fullRange)

            attributedString.enumerateAttribute(.font, in: fullRange) { value, range, _ in
                if let font = value as? UIFont {
                    var resizedFont: UIFont

                    // Check if range is within a specific HTML tag
                    let paragraphRange = (self as NSString).range(of: "<p>")
                    let headingRange = (self as NSString).range(of: "<h")

                    // Adjust font size based on HTML tag
                    if range.location >= paragraphRange.location && range.location < paragraphRange.location + paragraphRange.length {
                        resizedFont = UIFont(name: "Poppins-Regular", size: fontSize) ?? font.withSize(fontSize)
                    } else if range.location >= headingRange.location && range.location < headingRange.location + headingRange.length {
                        resizedFont = UIFont(name: "Poppins-Bold", size: headingFontSize) ?? font.withSize(headingFontSize)
                    } else {
                        resizedFont = UIFont(name: "Poppins-Regular", size: fontSize) ?? font.withSize(fontSize)
                    }

                    attributedString.addAttribute(.font, value: resizedFont, range: range)
                }
            }

            return attributedString
        } catch {
            return nil
        }
    }
}

