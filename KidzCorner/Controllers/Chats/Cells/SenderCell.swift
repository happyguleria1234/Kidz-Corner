//
//  SenderCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 07/06/24.
//

import UIKit

class SenderCell: UITableViewCell {

    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setMessageData(messageData: MessagesModelListingDatum) {
        if messageData.message == "" {
            lbl_message.text = messageData.media
        } else {
            lbl_message.text = messageData.message
        }
    }
    
}
