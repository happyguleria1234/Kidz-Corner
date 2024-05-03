//
//  ParentCell.swift
//  KidzCorner
//
//  Created by Apple on 28/10/23.
//

import UIKit

class ParentCell: UICollectionViewCell {

    @IBOutlet weak var imageGuardian: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonAddImage: UIButton!
    @IBOutlet weak var viewAddImage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.viewAddImage.layer.cornerRadius = self.viewAddImage.bounds.height/2.0
            self.viewAddImage.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        }
    }

}
