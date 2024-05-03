//
//  StudentProfileCell.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 14/10/23.
//

import UIKit

class StudentProfileCell: UICollectionViewCell {

    @IBOutlet weak var profileOuterView: UIView!
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            [self] in
            profileOuterView.layer.cornerRadius = profileOuterView.bounds.height / 2
            self.profileOuterView.superview?.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 4, opacity: 0.2, shadowColor: .black, cornerRadius: 8)
        }
    }

}
