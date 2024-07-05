//
//  RecieverImageCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 26/06/24.
//

import UIKit
import SDWebImage

class RecieverImageCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var imgSend: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img_user.cornerRadius = 20
    }

    func setMessageData(messageData: MessagesModelListingMessage) {
        if let url = URL(string: imageBaseUrl+(messageData.media ?? "")) {
            imgSend.sd_setImage(with: url, placeholderImage: .placeholderImage, options: [.scaleDownLargeImages])
        }
        lblName.text = "Teacher \(messageData.user?.name ?? "")"
//        lblTime.text = timeconverter(isoDateString: messageData.createdAt ?? "")
        lblTime.text = messageData.createdAt?.toLocalTimeHHmm()

        let userID = UserDefaults.standard.value(forKey: "myUserid") as? Int ?? 0
    }
}
