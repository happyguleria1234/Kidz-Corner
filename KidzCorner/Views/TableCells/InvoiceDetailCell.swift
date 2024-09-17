import UIKit

class InvoiceDetailCell: UITableViewCell {
    
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_paid: UILabel!
    @IBOutlet weak var viewOuter: GradientView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var bottomLine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
