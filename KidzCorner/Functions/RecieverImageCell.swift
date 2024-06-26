//
//  RecieverImageCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 26/06/24.
//

import UIKit
import SDWebImage

class RecieverImageCell: UITableViewCell {

    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var imgSend: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setMessageData(messageData: MessagesModelListingDatum) {
        if let url = URL(string: imageBaseUrl+(messageData.media ?? "")) {
            print(url)
            imgSend.sd_setImage(with: url, placeholderImage: .placeholderImage, options: [.scaleDownLargeImages])
        }
    }
    
}
