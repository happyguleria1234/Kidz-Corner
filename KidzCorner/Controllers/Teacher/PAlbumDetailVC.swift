//
//  PAlbumDetailVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 07/07/24.
//

import UIKit

class PAlbumDetailVC: UIViewController {
    
    var studentId = Int()
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var PortfolioDetailtableView: UITableView!
    
    var albumId:String?
    var albumDetailData: AlbumModelDataa?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        
    }
    
    func update(){
        PortfolioDetailtableView.dataSource = self
        PortfolioDetailtableView.delegate = self
        PortfolioDetailtableView.register(UINib(nibName: "DashboardTableCell", bundle: nil), forCellReuseIdentifier: "DashboardTableCell")
        self.hitAlbumWithId(album_id: albumId ?? "0",studentID: studentId)
    }

    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    MARK: HIT API
    
    func hitAlbumWithId(album_id:String, studentID:Int){
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        var param = ["student_id":studentID]
        ApiManager.shared.Request(type: AlbumModelDataa.self, methodType: .Get, url: baseUrl+album_posts+"\(album_id)", parameter: param) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.sync {
                    self.albumDetailData = myObject
                    self.PortfolioDetailtableView.reloadData()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
}
extension PAlbumDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = albumDetailData?.data?.data?.count ?? 0
        if count == 0 {
            tableView.setNoDataMessage("No post found!")
        } else {
            tableView.restore()
        }
        return albumDetailData?.data?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableCell", for: indexPath) as! DashboardTableCell
        cell.likeCommentView.isHidden = true
        cell.likeCommentviewHeightConstraint.constant = 0
        let data = self.albumDetailData?.data?.data
        cell.buttonMore.isHidden = false
        cell.cellContent = data?[indexPath.row].portfolioImage ?? []
        cell.collectionImages.tag = indexPath.row
        cell.collectionImages.reloadData()
        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(gotoRatings(sender:)), for: .touchUpInside)
        cell.imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(data?[indexPath.row].teacher?.image ?? "")), placeholderImage: .placeholderImage)
//        cell.postData = data
        cell.labelName.text = data?[indexPath.row].teacher?.name ?? ""
        cell.labelTitle.text = data?[indexPath.row].title ?? ""
        cell.labelDescription.text = data?[indexPath.row].postContent ?? ""
        cell.labelTime.text = data?[indexPath.row].postDate
        cell.labelDomain.text = data?[indexPath.row].domain?.name ?? ""
        cell.buttonLike.setImage(UIImage(named: "likeEmpty"), for: .normal)
        cell.buttonLike.setImage(UIImage(named: "likeFilled"), for: .selected)
        if data?[indexPath.row].isCollage == 0 {
            cell.collectionHeight.constant = 350
        } else {
            cell.collectionHeight.constant = 280
        }
        cell.view = self
        cell.buttonLike.tag = indexPath.row
        cell.buttonComment.tag = indexPath.row
        cell.buttonShare.tag = indexPath.row
        cell.buttonWriteComment.tag = indexPath.row
        cell.hideUnreadCommentViews(true)
        cell.viewOuter.defaultShadow()
        cell.backgroundColor = .clear
        return cell
    }
    
    @objc func gotoRatings(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Parent", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DemoVC") as! DemoVC
        vc.userID = studentId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
