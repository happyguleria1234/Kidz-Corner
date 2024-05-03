//
//  AttendanceCell.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 14/10/23.
//

import UIKit

class AttendanceCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.parentView.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2, shadowColor: .black, cornerRadius: 8)
                
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
