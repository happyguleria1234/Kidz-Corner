//
//  SelectionCell.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 22/06/23.
//

import UIKit

class SelectionCell: UITableViewCell {

    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
