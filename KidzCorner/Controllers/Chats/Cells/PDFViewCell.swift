//
//  PDFViewCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 29/06/24.
//

import UIKit

class PDFViewCell: UITableViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var pdfNamelbl: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setMessageData(messageData: MessagesModelListingMessage) {
        let path = messageData.media ?? ""
        let components = path.components(separatedBy: "/")
        if let filename = components.last {
            pdfNamelbl.text = filename
        } else {
            print("Invalid path format")
        }
        timeLbl.text = messageData.createdAt?.toLocalTimeHHmm()
//        timeLbl.text = timeconverter(isoDateString: messageData.createdAt ?? "")


    }
    
}
