//
//  NotificationsVC.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 01/07/23.
//

import UIKit

class NotificationsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var notificationData: [NotificationDetail]? {
        didSet {
            if notificationData?.count ?? 0 > 0 {
                emptyLabel.isHidden = true
            } else {
                emptyLabel.isHidden = false
            }
            tableView.reloadData()
        }
    }
    @IBOutlet weak var emptyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        getNotifications()
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupTable() {
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
    }
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationData?.count ?? 0
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.viewOuter.defaultShadow()
        cell.backgroundColor = .clear
        cell.notificationImage.tintColor = UIColor(named: "myDarkGreen")
        let data = notificationData?[indexPath.row]
        cell.titleLabel.text = data?.message ?? "No title"
        cell.subtitleLabel.text = data?.message ?? "No message"
        cell.invoiceBtn.tag = indexPath.row
        cell.invoiceBtn.addTarget(self, action: #selector(openInvoice(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func openInvoice(sender: UIButton) {
        if let id = self.notificationData?[sender.tag].invoiceID {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
            vc.invoiceId = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getNotifications() {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
       
        ApiManager.shared.Request(type: NotificationModel.self, methodType: .Get, url: baseUrl+apiNotification, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                self.notificationData = myObject?.data?.data ?? []
                
            }
            if statusCode == 200 {}
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
}
