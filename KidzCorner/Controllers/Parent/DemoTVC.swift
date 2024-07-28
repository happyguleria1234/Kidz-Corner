//
//  DemoTVC.swift
//  Ttwej
//
//  Created by cqlapple on 12/07/24.
//

import UIKit

class DemoTVC: UITableViewCell {

    @IBOutlet weak var lblSubject: UILabel!
    
    @IBOutlet weak var bad: UIImageView!
    @IBOutlet weak var improving: UIImageView!
    @IBOutlet weak var good: UIImageView!
    @IBOutlet weak var excellent: UIImageView!
    
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
