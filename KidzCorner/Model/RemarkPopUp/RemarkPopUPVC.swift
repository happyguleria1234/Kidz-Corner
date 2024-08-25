//
//  RemarkPopUPVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 19/08/24.
//

import UIKit

class RemarkPopUPVC: UIViewController {
    
    //------------------------------------------------------
    
    //MARK: Outlets
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var remarktableView: UITableView!
    
    //------------------------------------------------------
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remarktableView.delegate = self
        remarktableView.dataSource = self
        remarktableView.register(UINib(nibName: "RemarkPopUPCell", bundle: nil), forCellReuseIdentifier: "RemarkPopUPCell")
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func crossBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//------------------------------------------------------

//MARK: Table View delegate and datasource

extension RemarkPopUPVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemarkPopUPCell", for: indexPath) as! RemarkPopUPCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
