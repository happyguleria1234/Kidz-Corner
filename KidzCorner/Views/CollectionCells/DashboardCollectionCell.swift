import UIKit

class DashboardCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imagePost: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async { [self] in
           // imagePost.layer.cornerRadius = 20
        }
    }
}
