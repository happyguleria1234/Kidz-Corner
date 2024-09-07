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
    
    @IBOutlet weak var btnDoneOutlet: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tblData: UITableView!
    
    var comesFrom = String()
    var userID = Int()
    var selectedIndex: Int?
    var selectedTitle = String()
    var dataArray = [DataArray]()
    var callBack: (([DataArray])->())?
    var selectClasses = [DemoDatum]()
    
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
            btnDoneOutlet.isHidden = false
        case "Domain":
            lbl_title.text = "Select Domain"
            btnDoneOutlet.isHidden = false
        case "Student":
            lbl_title.text = "Select Student"
            btnDoneOutlet.isHidden = false
        case "Classes":
            lbl_title.text = "Select Classes"
            btnDoneOutlet.isHidden = false
        case "class":
            hitEvaluationList(userId: userID)
            lbl_title.text = "Select Evaluation"
            btnDoneOutlet.isHidden = true
        default:
            print("")
        }
        dataArray.sort { $0.value.localizedCompare($1.value) == .orderedAscending }
        tblData.reloadData()
    }
    
    func hitEvaluationList(userId:Int){
        let param = ["userId":userId]
        ApiManager.shared.Request(type: DemoAlbumModel.self, methodType: .Get, url: baseUrl+evaluationList, parameter: param) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.selectClasses = myObject?.data ?? []
                    self.tblData.reloadData()
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
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
        if selectedTitle == "class" {
            return selectClasses.count
        } else {
            return dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        if selectedTitle == "class" {
            cell.lblBrand.text = selectClasses[indexPath.row].name
            cell.imageWidth.constant = 0
            cell.userImage.isHidden = true
        } else {
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
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTitle == "Student" || selectedTitle == "Classes" {
            dataArray[indexPath.row].isSelect.toggle()
            tblData.reloadData()
        } else if selectedTitle == "class"{
            if comesFrom == "4" {
                let storyboard = UIStoryboard(name: "Parent", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DemoVC2") as! DemoVC2
                vc.selectedTitle = selectClasses[indexPath.row].name ?? ""
                vc.userID = userID
                self.navigationController?.pushViewController(vc, animated: true)
            } else if comesFrom == "2"{
                let storyboard = UIStoryboard(name: "Parent", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DemoVC") as! DemoVC
                vc.selectedTitle = selectClasses[indexPath.row].name ?? ""
                vc.userID = userID
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
