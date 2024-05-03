import UIKit

class StatsCell: UITableViewCell {
    
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelStatOne: UILabel!
    @IBOutlet weak var labelStatTwo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async { [self] in
            imageProfile.layer.cornerRadius = imageProfile.bounds.height/2.0
            viewOuter.layer.cornerRadius = 10
        }
        
    }
    
}
