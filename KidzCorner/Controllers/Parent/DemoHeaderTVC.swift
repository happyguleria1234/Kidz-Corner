//
//  DemoHeaderTVC.swift
//  Ttwej
//
//  Created by cqlapple on 12/07/24.
//

import UIKit

class DemoHeaderTVC: UITableViewCell {

    @IBOutlet weak var lblExcellent: UILabel!
    @IBOutlet weak var lblGood: UILabel!
    @IBOutlet weak var lblImprove: UILabel!
    @IBOutlet weak var lblBas: UILabel!
    
    @IBOutlet weak var BadHeaderView: UIView!
    @IBOutlet weak var improvingHeaderView: UIView!
    @IBOutlet weak var goodHeaderView: UIView!
    @IBOutlet weak var excelentHeaderView: UIView!
    
    @IBOutlet weak var lblStream: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViewsWithRatings(_ ratings: [Rating]) {
         // Hide all header views initially
         BadHeaderView.isHidden = true
         improvingHeaderView.isHidden = true
         goodHeaderView.isHidden = true
         excelentHeaderView.isHidden = true
         
         // Loop through the ratings array and update views and labels based on rating name
         for rating in ratings {
             switch rating.name {
             case "Good":
                 goodHeaderView.isHidden = false
                 lblGood.text = rating.name
             case "Bad":
                 BadHeaderView.isHidden = false
                 lblBas.text = rating.name
             case "Improvement":
                 improvingHeaderView.isHidden = false
                 lblImprove.text = rating.name
             case "Excellent":
                 excelentHeaderView.isHidden = false
                 lblExcellent.text = rating.name
             default:
                 break
             }
         }
     }
}
