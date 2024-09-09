//
//  MedicationCell.swift
//  KidzCorner
//
//  Created by Happy Guleria on 08/09/24.
//

import UIKit

class MedicationCell: UITableViewCell {

    @IBOutlet weak var btn_after: UIButton!
    @IBOutlet weak var btn_before: UIButton!
    @IBOutlet weak var tf_day: UITextField!
    @IBOutlet weak var btn_day: UIButton!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var tf_date: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getData() -> [String: Any] {
           return [
               "name": tf_name.text ?? "",
               "date": tf_date.text ?? "",
               "how_many_time_day": tf_day.text ?? "",
               "before_lunch": btn_before.isSelected ? "1" : "",
               "after_lunch": btn_after.isSelected ? "1" : ""
           ]
       }
}
