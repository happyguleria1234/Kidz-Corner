//
//  Comments.swift
//  KidzCorner
//
//  Created by macMini_Mansa on 25/06/22.
//

import UIKit

class Comments: UIViewController {
    
    @IBOutlet weak var tableComments: UITableView!
    @IBOutlet weak var viewWriteComment: UIView!
    @IBOutlet weak var textComment: UITextField!
    @IBOutlet weak var labelNoComments: UILabel!
    @IBOutlet weak var buttonPostComment: UIButton!
    
    var portfolioId: Int = 0
    var commentsData: CommentsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getComments(portfolioId: portfolioId)
    }
    
    @IBAction func postCommentFunc(_ sender: Any) {
        if let commentText = textComment.text {
            addComment(portfolioId: self.portfolioId, comment: commentText)
        }
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        textComment.setPadding(20)
        viewWriteComment.layer.borderColor = UIColor.lightGray.cgColor
        viewWriteComment.layer.borderWidth = 1
        
    }
    
    func setupTable() {
        tableComments.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        tableComments.dataSource = self
        tableComments.delegate = self
    }
    
    func getComments(portfolioId: Int) {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        let parameters = ["portfolio_id": String(portfolioId)]
        
        ApiManager.shared.Request(type: CommentsModel.self, methodType: .Get, url: baseUrl+apiComments, parameter: parameters) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.commentsData = myObject
                DispatchQueue.main.async {
                    
                    if myObject?.data?.comments?.count != 0 {
                        self.tableComments.reloadData()
                        self.labelNoComments.isHidden = true
                        self.tableComments.isHidden = false
                    }
                    else {
                        self.labelNoComments.isHidden = false
                        self.tableComments.isHidden = true
                    }
                    
                }
            }
        }
    }
    
    func addComment(portfolioId: Int, comment: String) {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        let parameters = ["portfolio_id": String(portfolioId),
                          "comment": comment]
        
        ApiManager.shared.Request(type: LikeModel.self, methodType: .Post, url: baseUrl+apiComments, parameter: parameters) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    self.textComment.text = ""
                    self.textComment.resignFirstResponder()
                    self.getComments(portfolioId: portfolioId)
                }
            }
        }
    }
    
    func deleteCommentAPI(commentId: Int) {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        let parameters = ["id": String(commentId)]
                          
        ApiManager.shared.Request(type: LikeModel.self, methodType: .Delete, url: baseUrl+apiComments, parameter: parameters) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    self.getComments(portfolioId: self.portfolioId)
                }
            }
        }
    }
    
    func instance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
       let viewController = storyboard.instantiateViewController(withIdentifier: "Comments") as! Comments
        return viewController
    }
}

extension Comments: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count \(commentsData?.data?.comments?.count ?? 0)")
        return commentsData?.data?.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as! CommentsCell
        
        let data = self.commentsData?.data?.comments?[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        let date = dateFormatter.date(from: data?.createdAt ?? "")
        
        cell.labelName.text = data?.user?.name ?? ""
        cell.labelTime.text = date?.timeAgoDisplay()
        cell.labelComment.text = data?.comment ?? ""
        
        cell.imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(data?.user?.image ?? "")), placeholderImage: .placeholderImage)
        
        cell.buttonDelete.tag = indexPath.row
        cell.buttonDelete.addTarget(self, action: #selector(deleteComment), for: .touchUpInside)
        
        if let myUserId = UserDefaults.standard.string(forKey: myUserid) {
            if String(data?.userID ?? 0) == myUserId {
                cell.buttonDelete.isHidden = false
                cell.buttonDeleteHeight.constant = 20
            }
            else {
                cell.buttonDelete.isHidden = true
                cell.buttonDeleteHeight.constant = 0
            }
        }
        
        return cell
    }
    
    @objc func deleteComment(sender: UIButton) {
        print("Comment Id \(commentsData?.data?.comments?[sender.tag].id ?? 0)")
        deleteCommentAPI(commentId: commentsData?.data?.comments?[sender.tag].id ?? 0)
    }
}
