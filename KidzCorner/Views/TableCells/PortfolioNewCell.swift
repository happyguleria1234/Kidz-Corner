//
//  PortfolioNewCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 21/06/24.
//

import UIKit

class PortfolioNewCell: UITableViewCell {
    
// MARK: - OUTLETS
    @IBOutlet weak var portfolioListView: UIView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNamelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var messagebtn: UIButton!
    @IBOutlet weak var headinglbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var potfolioImgvw: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
