//
//  DemoTVC.swift
//  Ttwej
//
//  Created by cqlapple on 12/07/24.
//

import UIKit

class DemoTVC: UITableViewCell {
    
    @IBOutlet weak var lblSubject: UILabel!
    
    @IBOutlet weak var bad: UIImageView!
    @IBOutlet weak var improving: UIImageView!
    @IBOutlet weak var good: UIImageView!
    @IBOutlet weak var excellent: UIImageView!
    
    @IBOutlet weak var badRatingView: UIView!
    @IBOutlet weak var improvingRatingView: UIView!
    @IBOutlet weak var GoodRatingView: UIView!
    @IBOutlet weak var excelentRatingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
//    func configureWithRatings(_ ratings: [Rating]) {
//           // Initially hide all views
//           GoodRatingView.isHidden = true
//           improvingRatingView.isHidden = true
//           badRatingView.isHidden = true
//           excelentRatingView.isHidden = true
//           
//           // Loop through the ratings and configure the cell views accordingly
//           for rating in ratings {
//               switch rating.name {
//               case "Good":
//                   GoodRatingView.isHidden = false
//                   good.image = UIImage(named: "star")
//               case "Bad":
//                   badRatingView.isHidden = false
//                   bad.image = UIImage(named: "star")
//               case "Improvement":
//                   improvingRatingView.isHidden = false
//                   improving.image = UIImage(named: "star")
//               case "Excellent":
//                   excelentRatingView.isHidden = false
//                   excellent.image = UIImage(named: "star")
//               default:
//                   break
//               }
//           }
//       }

}
