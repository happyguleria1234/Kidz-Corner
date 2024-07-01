//
//  RecieverCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 07/06/24.
//

import UIKit
import SDWebImage

class RecieverCell: UITableViewCell {
    
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var reciverView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img_profile.cornerRadius = 20
        reciverView.layer.cornerRadius = 10
        reciverView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        reciverView.layer.masksToBounds = true
    }
    
    func setMessageData(messageData: MessagesModelListingMessage) {
        if messageData.message == "" {
            lbl_message.text = messageData.media
        } else {
            lbl_message.text = messageData.message
        }
        lbl_name.text = "Teacher \(messageData.user?.name ?? "")".capitalized
        
        // Convert date to user's local time zone
        lbl_time.text = extractTime(strDate: messageData.createdAt ?? "")
        let userID = UserDefaults.standard.value(forKey: "myUserid") as? Int ?? 0
        if userID == messageData.user?.id {
            if let url = URL(string: imageBaseUrl+(messageData.user?.image ?? "")) {
                print(url)
                img_profile.sd_setImage(with: url, placeholderImage: .placeholderImage, options: [.scaleDownLargeImages])
            }
        } else {
            if let url = URL(string: imageBaseUrl+(messageData.student?.image ?? "")) {
                print(url)
                img_profile.sd_setImage(with: url, placeholderImage: .placeholderImage, options: [.scaleDownLargeImages])
            }
        }
    }
}
