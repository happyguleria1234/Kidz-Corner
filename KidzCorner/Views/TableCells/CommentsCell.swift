//
//  CommentsCell.swift
//  KidzCorner
//
//  Created by macMini_Mansa on 25/06/22.
//

import UIKit

class CommentsCell: UITableViewCell {
    
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    
    @IBOutlet weak var buttonDeleteHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async { [self] in
//            viewOuter.defaultShadow()
            imageProfile.layer.cornerRadius = imageProfile.bounds.height/2.0
            imageProfile.layer.borderWidth = 0.75
            imageProfile.layer.borderColor = myGreenColor.cgColor
        }
        
        
    }
    
    
}
