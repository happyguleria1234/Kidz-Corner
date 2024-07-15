//
//  BrandVC.swift
//  AirCloset
//
//  Created by cqlios3 on 14/09/23.
//

import UIKit
import SDWebImage
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
        if selectedTitle == "Student" {
            cell.imageWidth.constant = 40
            cell.userImage.isHidden = false
        } else {
            cell.imageWidth.constant = 0
            cell.userImage.isHidden = true
        }
        cell.lblBrand.text = data.value
        if let url = URL(string: imageBaseUrl + (data.userImage)) {
            cell.userImage.sd_setImage(with: url, placeholderImage: .placeholderImage, options: [.scaleDownLargeImages])
        }
        cell.checkView.backgroundColor = data.isSelect ? #colorLiteral(red: 0.2741542459, green: 0.6354581118, blue: 0.6397424936, alpha: 1) : #colorLiteral(red: 0.8745093942, green: 0.8745102286, blue: 0.8917174935, alpha: 1)
        
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
                    previousCell.checkView.backgroundColor = #colorLiteral(red: 0.8745093942, green: 0.8745102286, blue: 0.8917174935, alpha: 1)
                }
            }
            dataArray[indexPath.row].isSelect.toggle()
            selectedIndex = dataArray[indexPath.row].isSelect ? indexPath.row : nil            
            let currentCell = tableView.cellForRow(at: indexPath) as! SearchCell
            currentCell.checkView.backgroundColor = dataArray[indexPath.row].isSelect ? #colorLiteral(red: 0.2741542459, green: 0.6354581118, blue: 0.6397424936, alpha: 1) : #colorLiteral(red: 0.8745093942, green: 0.8745102286, blue: 0.8917174935, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var lblBrand: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

struct DataArray {
    var value: String
    var isSelect: Bool
    var id: Int
    var userImage: String
}
