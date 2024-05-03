import UIKit

class InvoiceDetailHeader: UITableViewCell {
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelCycle: UILabel!
    @IBOutlet weak var labelDueDate: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.viewDetails.defaultShadow()
        }
        
    }
    
}
