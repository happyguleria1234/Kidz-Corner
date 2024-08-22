//
//  RemarkPopUPCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 19/08/24.
//

import UIKit

class RemarkPopUPCell: UITableViewCell {
    
//    MARK: OUTLETS
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        imgCell.layer.cornerRadius = imgCell.frame.height / 2
        imgCell.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
