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
        setupViews()
        imgCell.layer.cornerRadius = 10
    }
    
    func setData(userData: AlbumModelDatum) {
        nameLbl.text = userData.name?.capitalized
        countLbl.text = "\(userData.images_count ?? 0) Photos"
        if let url = URL(string: imageBaseUrl + (userData.thumbnail ?? "")) {
            imgCell.sd_setImage(with: url, placeholderImage: .placeholderImage, options: [.scaleDownLargeImages])
        }
    }
    
    
    func setupViews() {
        DispatchQueue.main.async { [self] in
            listSuperView.layer.cornerRadius = 10
            listSuperView.layer.shadowColor = UIColor.black.cgColor
            listSuperView.layer.shadowOpacity = 1
            listSuperView.layer.shadowOffset = CGSize.zero
            listSuperView.layer.shadowRadius = 8
        }
    }
    
}
