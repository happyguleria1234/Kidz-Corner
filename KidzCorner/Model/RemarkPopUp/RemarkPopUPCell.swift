//
//  RemarkPopUPCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 19/08/24.
//

import UIKit
import Kingfisher

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
    
    func setData(listData: RemarkModelDataList) {
        nameLbl.text = listData.user?.name
        descriptionLbl.text = listData.description ?? ""
        let userProfileUrl = URL(string: imageBaseUrl+(listData.user?.image ?? ""))
        imgCell.kf.setImage(with: userProfileUrl)
    }
    
    func setDataPortfolio(listData: PortFolioDataModelDatum) {
        nameLbl.text = listData.user?.name
        descriptionLbl.text = listData.post ?? ""
        let userProfileUrl = URL(string: imageBaseUrl+(listData.user?.image ?? ""))
        imgCell.kf.setImage(with: userProfileUrl)
    }

    
}
