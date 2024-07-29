//
//  DemoHeaderTVC.swift
//  Ttwej
//
//  Created by cqlapple on 12/07/24.
//

import UIKit

class DemoHeaderTVC: UITableViewCell {

    @IBOutlet weak var lblExcellent: UILabel!
    @IBOutlet weak var lblGood: UILabel!
    @IBOutlet weak var lblImprove: UILabel!
    @IBOutlet weak var lblBas: UILabel!
    
    @IBOutlet weak var BadHeaderView: UIView!
    @IBOutlet weak var improvingHeaderView: UIView!
    @IBOutlet weak var goodHeaderView: UIView!
    @IBOutlet weak var excelentHeaderView: UIView!
    
    
    
    
    @IBOutlet weak var lblStream: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
