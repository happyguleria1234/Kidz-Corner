import UIKit

class AnnouncementCell: UITableViewCell {
    
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var imageAnnouncement: UIImageView!
    @IBOutlet weak var stackLabels: UIStackView!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async { [self] in
            imageAnnouncement.layer.cornerRadius = 10
//            viewOuter.defaultShadow2()
            viewOuter.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2, shadowColor: .black, cornerRadius: 8)
        }
    }
}

