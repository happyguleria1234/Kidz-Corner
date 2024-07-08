//
//  BrandVC.swift
//  AirCloset
//
//  Created by cqlios3 on 14/09/23.
//

import UIKit
import Foundation

class BrandVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //------------------------------------------------------
    
    //MARK: Varibles and outlets
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tblData: UITableView!
    
    var selectedIndex: Int?
    var selectedTitle = String()
    var dataArray = [DataArray]()
    var callBack: (([DataArray])->())?
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    //MARK: Custome Function
    
    func setup() {
        switch selectedTitle {
        case "Album":
            lbl_title.text = "Select Album"
        case "Domain":
            lbl_title.text = "Select Domain"
        case "Student":
            lbl_title.text = "Select Student"
        case "Classes":
            lbl_title.text = "Select Classes"
        default:
            print("")
        }
        tblData.reloadData()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnDone(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true, completion: { [self] in
            callBack?(dataArray.filter({ $0.isSelect == true }))
        })
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: Table view datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let data = dataArray[indexPath.row]
        
        cell.lblBrand.text = data.value
        cell.imgChecked.image = data.isSelect ? UIImage(named: "checkBoxIcon") : UIImage(named: "uncheckedBox")
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTitle == "Student" || selectedTitle == "Classes" {
            dataArray[indexPath.row].isSelect.toggle()
            tblData.reloadData()
        } else {
            // Ensure single selection
            if let previousIndex = selectedIndex {
                dataArray[previousIndex].isSelect = false
                let previousIndexPath = IndexPath(row: previousIndex, section: 0)
                if let previousCell = tableView.cellForRow(at: previousIndexPath) as? SearchCell {
                    previousCell.imgChecked.image = UIImage(named: "uncheckedBox")
                }
            }
            
            dataArray[indexPath.row].isSelect.toggle()
            selectedIndex = dataArray[indexPath.row].isSelect ? indexPath.row : nil
            
            let currentCell = tableView.cellForRow(at: indexPath) as! SearchCell
            currentCell.imgChecked.image = dataArray[indexPath.row].isSelect ? UIImage(named: "checkBoxIcon") : UIImage(named: "uncheckedBox")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        
    }
    
    //------------------------------------------------------
}


class SearchCell: UITableViewCell {
    
    @IBOutlet weak var imgChecked: UIImageView!
    @IBOutlet weak var lblBrand: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

struct DataArray {
    var value: String
    var isSelect: Bool
    var id: Int
}
