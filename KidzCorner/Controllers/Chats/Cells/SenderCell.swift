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
        
//        lbl_time.text = convertDate(messageData.createdAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", toFormat: "HH:mm")
//        lbl_time.text = messageData.createdAt?.toLocalTimeHHmm()
//        lbl_time.text = extractTime(strDate: messageData.createdAt ?? "")
        lbl_time.text = timeconverter(isoDateString: messageData.createdAt ?? "")
    }
    func timeconverter(isoDateString:String) -> String?{
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = isoDateFormatter.date(from: isoDateString)
        let timechecstamp = date?.timeIntervalSince1970
        print("Timestamp: \(timechecstamp)")
        let timeCurrentstamp = Int(timechecstamp!)
        let timestamp: TimeInterval = TimeInterval(timeCurrentstamp)
        let dateCheck = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeZone = TimeZone.current
        let localDateString = dateFormatter.string(from: dateCheck)
        print("Local time: \(localDateString)")
        return localDateString
    }
}
