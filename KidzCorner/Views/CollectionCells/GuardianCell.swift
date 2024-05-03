import UIKit

class GuardianCell: UICollectionViewCell {
    @IBOutlet weak var imageGuardian: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewAddImage: UIView!
    @IBOutlet weak var buttonAddImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.viewAddImage.layer.cornerRadius = self.viewAddImage.bounds.height/2.0
            self.viewAddImage.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
            self.imageGuardian.layer.cornerRadius = self.imageGuardian.bounds.height/2.0
            
            
        }
    }
}
