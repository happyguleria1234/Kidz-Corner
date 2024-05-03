import UIKit
import Foundation

class InvoiceCell: UITableViewCell {
    
    @IBOutlet weak var viewOuter: GradientView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var viewLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func labelColors(_ color: UIColor) {
        labelName.textColor = color
        labelDate.textColor = color
        labelStatus.textColor = color
        labelAmount.textColor = color
    }
    
}
