import UIKit

class AnnouncementCell: UITableViewCell {
    
    @IBOutlet weak var viewOuter: UIView!
    
    @IBOutlet weak var imageAnnouncement: UIImageView!
    
    @IBOutlet weak var stackLabels: UIStackView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async { [self] in
            viewOuter.layer.cornerRadius = 10
            imageAnnouncement.layer.cornerRadius = imageAnnouncement.bounds.width/2.0
        }
    }
    
    
}

