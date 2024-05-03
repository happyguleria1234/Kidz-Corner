import UIKit

class DevicesCell: UITableViewCell {
    
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var labelName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
         //   self.viewOuter.layer.cornerRadius = 10
       //     self.viewOuter.defaultShadow()
        }
        
        
    }
}
