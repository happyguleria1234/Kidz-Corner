//
//  NotificationCell.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 01/07/23.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var invoiceBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.notificationImage.layer.cornerRadius = self.notificationImage.bounds.height / 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
