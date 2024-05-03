//
//  ClassSelectionVC.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 22/06/23.
//

import UIKit

class ClassSelectionVC: UIViewController {

    weak var delegate: ClassSelectionVCDelegate?
    var allClassesData: [ClassName]?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellReuseIdentifier: "SelectionCell")
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableHeight.constant = tableView.contentSize.height
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == view {
            self.dismiss(animated: true)
        }
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func didTapSave(_ sender: Any) {
        self.delegate?.updatedData(data: self.allClassesData ?? [])
        self.dismiss(animated: true)
    }
}

// MARK: Table view delegates
extension ClassSelectionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allClassesData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as! SelectionCell
        let data = self.allClassesData?[indexPath.row]
        cell.titleLabel.text = data?.name ?? ""
        if data?.isSelected ?? Bool() {
            cell.checkBoxImage.image = UIImage(named: "checkedBox")
        } else{
            cell.checkBoxImage.image = UIImage(named: "uncheckedBox")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.allClassesData?[indexPath.row].isSelected ?? Bool()) {
            self.allClassesData?[indexPath.row].isSelected = false
        } else {
            self.allClassesData?[indexPath.row].isSelected = true
        }
        self.tableView.reloadData()
    }
}

protocol ClassSelectionVCDelegate: AnyObject {
    func updatedData(data: [ClassName])
}
