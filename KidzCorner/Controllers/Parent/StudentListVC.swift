//
//  StudentListVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 20/07/24.
//

import UIKit
import SDWebImage

class StudentListVC: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    var childrenData = [ChildData]()
    var comesFrom = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllChildsAPI()
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAllChildsAPI() {
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.childrenData = myObject?.data ?? []
                    self.tblList.reloadData()
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
}

extension StudentListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = childrenData.count
        if count == 0 {
            tableView.setNoDataMessage("No data found")
        } else {
            tableView.restore()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDataCell", for: indexPath) as! StudentDataCell
        let data = childrenData[indexPath.row]
        cell.lbl_name.text = data.name
        cell.img_user.contentMode = .scaleAspectFill
//        let myUrl = imageBaseUrl+(data.image ?? "")
//        cell.img_user.downloadImage(url: myUrl)
        cell.img_user.sd_setImage(with: URL(string: imageBaseUrl+(data.image ?? "")),
                               placeholderImage: .announcementPlaceholder)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if comesFrom == "4" {
            let storyboard = UIStoryboard(name: "Parent", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DemoVC") as! DemoVC
            vc.userID = childrenData[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TeacherPortfolioVC") as! TeacherPortfolioVC
            vc.studentId = childrenData[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
}

class StudentDataCell: UITableViewCell {
    
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension UIImageView{
    func downloadImage(url:String){
      //remove space if a url contains.
        let stringWithoutWhitespace = url.replacingOccurrences(of: " ", with: "%20", options: .regularExpression)
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: URL(string: stringWithoutWhitespace), placeholderImage: UIImage())
    }
}
