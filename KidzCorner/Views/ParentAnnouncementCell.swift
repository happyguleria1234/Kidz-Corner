//
//  ParentAnnouncementCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 19/08/24.
//

import UIKit

class ParentAnnouncementCell: UITableViewCell {

    //------------------------------------------------------
    
    //MARK: Outlets
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        descriptionLbl.numberOfLines = 4 // Allow multiple lines
//        descriptionLbl.lineBreakMode = .byWordWrapping
        imgCell.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
