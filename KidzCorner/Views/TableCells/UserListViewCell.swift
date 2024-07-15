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
            listSuperView.layer.cornerRadius = 20
            listSuperView.layer.borderColor = #colorLiteral(red: 0.8745093942, green: 0.8745102286, blue: 0.8917174935, alpha: 1)
            listSuperView.layer.borderWidth = 1
        }
    }
    
}

extension UIView {

  func dropShadow() {
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.5
      layer.shadowOffset = CGSize(width: -1, height: 1)
      layer.shadowRadius = 1
      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = UIScreen.main.scale
  }
}
