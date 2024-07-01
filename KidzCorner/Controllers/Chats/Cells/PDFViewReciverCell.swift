//
//  PDFViewReciverCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 29/06/24.
//

import UIKit

class PDFViewReciverCell: UITableViewCell {

//    MARK: OUTLETS
    @IBOutlet weak var PdfView: UIView!
    @IBOutlet weak var userImgVw: UIImageView!
    @IBOutlet weak var pdfNameLbl: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImgVw.cornerRadius = 20
    }
    
    func setMessageData(messageData: MessagesModelListingMessage) {
        pdfNameLbl.text = messageData.media ?? ""
        timeLbl.text = extractTime(strDate: messageData.createdAt ?? "")
        lblName.text = "Teacher \(messageData.user?.name ?? "")"
    }
    
}
