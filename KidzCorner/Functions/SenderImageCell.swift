//
//  SenderImageCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 26/06/24.
//

import UIKit
import SDWebImage

class SenderImageCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var imgSend: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setMessageData(messageData: MessagesModelListingMessage) {
        if let url = URL(string: imageBaseUrl+(messageData.media ?? "")) {
            imgSend.sd_setImage(with: url, placeholderImage: .placeholderImage, options: [.scaleDownLargeImages])
        }
        lblTime.text = messageData.createdAt?.toLocalTimeHHmm()
//        lblTime.text = timeconverter(isoDateString: messageData.createdAt ?? "")

    }
    
}
