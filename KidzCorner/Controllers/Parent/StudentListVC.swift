//
//  StudentListVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 20/07/24.
//

import UIKit
import SDWebImage
import Kingfisher

class StudentListVC: UIViewController, SelectEvulation {
    func selectedClass(selectEvulationID: Int) {
    }
    

    @IBOutlet weak var tblList: UITableView!
    var childrenData = [ChildData]()
    var comesFrom = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllChildsAPI()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAllChildsAPI() {
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async { [self] in
                if statusCode == 200 {
                    self.childrenData = myObject?.data ?? []
                    if self.childrenData.count > 1 {
                    } else if self.childrenData.count == 1{
                        if comesFrom == "4" {
                            DispatchQueue.main.async { [self] in
                                let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "BrandVC") as! BrandVC
                                vc.selectedTitle = "class"
                                vc.comesFrom = comesFrom
                                vc.userID = childrenData.first?.id ?? 0
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        } else if comesFrom == "2"{
                            DispatchQueue.main.async { [self] in
                                let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "BrandVC") as! BrandVC
                                vc.selectedTitle = "class"
                                vc.comesFrom = comesFrom
                                vc.userID = childrenData.first?.id ?? 0
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        } else if comesFrom == "5" || comesFrom == "6" || comesFrom == "7" {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParentAnnouncements") as! ParentAnnouncements
                            switch comesFrom {
                            case "5":
                                vc.type = "bulleting"
                            case "6":
                                vc.type = "announcement"
                            case "7":
                                vc.type = "weekly_update"
                            default:
                                break
                            }
                            vc.userID = childrenData.first?.id ?? 0
                            comesForImages = "Images"
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        } else {
                            let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "TeacherPortfolioVC") as! TeacherPortfolioVC
                            vc.studentId = childrenData.first?.id ?? 0
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
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
        let userProfileUrl = URL(string: imageBaseUrl+(data.image ?? ""))
        cell.img_user.kf.setImage(with: userProfileUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if comesFrom == "4" {
            DispatchQueue.main.async { [self] in
                let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BrandVC") as! BrandVC
                vc.selectedTitle = "class"
                vc.comesFrom = comesFrom
                vc.userID = childrenData[indexPath.row].id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if comesFrom == "2"{
            DispatchQueue.main.async { [self] in
                let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BrandVC") as! BrandVC
                vc.selectedTitle = "class"
                vc.comesFrom = comesFrom
                vc.userID = childrenData[indexPath.row].id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if comesFrom == "5" || comesFrom == "6" || comesFrom == "7" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParentAnnouncements") as! ParentAnnouncements
            switch comesFrom {
            case "5":
                vc.type = "bulleting"
            case "6":
                vc.type = "announcement"
            case "7":
                vc.type = "weekly_update"
            default:
                break
            }
            vc.userID = childrenData[indexPath.row].id ?? 0
            comesForImages = "Images"
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
        let stringWithoutWhitespace = url.replacingOccurrences(of: " ", with: "%20", options: .regularExpression)
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: URL(string: stringWithoutWhitespace), placeholderImage: UIImage())
    }
}
