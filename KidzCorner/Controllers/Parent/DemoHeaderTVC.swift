//
//  DemoHeaderTVC.swift
//  Ttwej
//
//  Created by cqlapple on 12/07/24.
//

import UIKit

class DemoHeaderTVC: UITableViewCell {
    //MARK: OUTLETS
    @IBOutlet weak var lblStream: UILabel!
    @IBOutlet weak var viewTopic : UIView!
    @IBOutlet weak var viewBad : UIView!
    @IBOutlet weak var viewImproving : UIView!
    @IBOutlet weak var viewGood : UIView!
    @IBOutlet weak var viewExcellent : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
