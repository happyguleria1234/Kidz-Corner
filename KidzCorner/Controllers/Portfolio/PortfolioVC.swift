//
//  PortfolioVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 21/06/24.
//

import UIKit

class PortfolioVC: UIViewController {
    
// MARK: - OUTLETS
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mainImgVw: UIImageView!
    @IBOutlet weak var uploadImgBtn: UIButton!
    @IBOutlet weak var portfolioTableVIEW: UITableView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
    }
    
    func updateData(){
        portfolioTableVIEW.delegate = self
        portfolioTableVIEW.dataSource = self
        self.mainImgVw.image = UIImage(named: "placeholder-image")
    }
    
//MARK: - BUTTON ACTIONS
    
    @IBAction func uploadImgBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension PortfolioVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListViewCell", for: indexPath) as! UserListViewCell
        return cell
    }
    
    
}
