//
//  SenderCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 07/06/24.
//

import UIKit

class SenderCell: UITableViewCell {

    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setMessageData(messageData: MessagesModelListingDatum) {
        lbl_message.text = messageData.message?.message
    }
    
}
