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
    
    @IBOutlet weak var badRatingView: UIView!
    @IBOutlet weak var improvingRatingView: UIView!
    @IBOutlet weak var GoodRatingView: UIView!
    @IBOutlet weak var excelentRatingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
