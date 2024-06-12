//
//  MessageListingVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 08/06/24.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class MessageListingVC : UIViewController {
    
    //------------------------------------------------------
    
    //MARK: Varibles and Outlets
    
  
    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblMessages: UITableView!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    //MARK: Custom
    
    func setData() {
        tblMessages.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tblMessages.register(UINib(nibName: "RecieverCell", bundle: nil), forCellReuseIdentifier: "RecieverCell")
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

extension MessageListingVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
            return senderCell
        } else {
            let recieverCell = tableView.dequeueReusableCell(withIdentifier: "RecieverCell", for: indexPath) as! RecieverCell
            return recieverCell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension MessageListingVC {
    
    // MARK: - TABLE VIEW SCROLL TO BOTTOM
    func tableViewScrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0)) {
            let numberOfSections = self.tblMessages.numberOfSections
            let numberOfRows = self.tblMessages.numberOfRows(inSection: 0)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tblMessages.scrollToRow(at: indexPath, at: .bottom, animated: false )
            }
        }
    }
}

