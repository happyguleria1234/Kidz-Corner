//
//  TeacherPortfolioVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 07/07/24.
//

import UIKit

class TeacherPortfolioVC: UIViewController {

    var studentId = Int()
    var albumData: AlbumModel?
    @IBOutlet weak var TbackBtn: UIButton!
    @IBOutlet weak var TmainImgVw: UIImageView!
    @IBOutlet weak var TuploadImgBtn: UIButton!
    @IBOutlet weak var teacherPortfolio: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
    }
    
    
    func updateData(){
        teacherPortfolio.register(UINib(nibName: "UserListViewCell", bundle: nil), forCellReuseIdentifier: "UserListViewCell")
        getportfolioAlbum(studentID: studentId)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func uploadImgBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func getportfolioAlbum(studentID: Int){
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        var param = ["student_id":studentID]
        ApiManager.shared.Request(type: AlbumModel.self, methodType: .Get, url: baseUrl+portfolioalbums, parameter: param) { [self] error, myObject, msgString, statusCode in
            if statusCode == 200 {
                albumData = myObject
                DispatchQueue.main.async {
                    self.teacherPortfolio.reloadData()
                }
            } else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }

}
extension TeacherPortfolioVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = albumData?.data?.data?.count ?? 0
        if count == 0 {
            tableView.setNoDataMessage("No post found!")
        } else {
            tableView.restore()
        }
        return albumData?.data?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListViewCell", for: indexPath) as! UserListViewCell
        if let data = albumData?.data?.data?[indexPath.row] {
            cell.setData(userData: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = albumData?.data?.data?[indexPath.row]
        let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PAlbumDetailVC") as! PAlbumDetailVC
        vc.albumId = "\(data?.id ?? 0)"
        vc.studentId = studentId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
