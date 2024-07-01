//
//  SenderCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 07/06/24.
//

import UIKit
import SDWebImage

class SenderCell: UITableViewCell {
    
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        senderView.layer.cornerRadius = 10
        senderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        senderView.layer.masksToBounds = true
//        senderView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 10.0)
    }
    
    func setMessageData(messageData: MessagesModelListingMessage) {
        if messageData.message == "" {
            lbl_message.text = messageData.media
        } else {
            lbl_message.text = messageData.message
        }
        lbl_time.text = extractTime(strDate: messageData.createdAt ?? "")
    }
}
