//
//  UserListViewCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 21/06/24.
//

import UIKit

class UserListViewCell: UITableViewCell {

    
//    MARK: OUTLETS
    
    @IBOutlet weak var listSuperView: UIView!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
