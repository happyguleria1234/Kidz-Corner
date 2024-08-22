//
//  AnnouncementCell2.swift
//  KidzCorner
//
//  Created by Happy Guleria on 18/08/24.
//

import UIKit

class AnnouncementCell2: UITableViewCell {

    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var img_user: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img_user.cornerRadius = 10
        // Initialization code
    }
    
}
