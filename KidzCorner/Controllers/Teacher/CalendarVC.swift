//
//  CalendarVC.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 21/06/23.
//

import UIKit

class CalendarVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self.view {
            self.dismiss(animated: true)
        }
    }

    @IBAction func didTapSave(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
