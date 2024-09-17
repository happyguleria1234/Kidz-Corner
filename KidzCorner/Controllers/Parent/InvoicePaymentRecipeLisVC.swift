//
//  InvoicePaymentRecipeLisVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 18/09/24.
//

import UIKit

class InvoicePaymentRecipeLisVC: UIViewController {

    @IBOutlet weak var InvoicePaymentRecipeTableView: UITableView!
    @IBOutlet weak var tableviewheightConstraint: NSLayoutConstraint!
    
    var payment_reciepts = [payment_recieptsData]()
    var controller:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InvoicePaymentRecipeTableView.delegate = self
        InvoicePaymentRecipeTableView.dataSource = self
        InvoicePaymentRecipeTableView.register(UINib(nibName: "ClassesCell", bundle: nil), forCellReuseIdentifier: "ClassesCell")
    }
    

}
extension InvoicePaymentRecipeLisVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payment_reciepts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesCell", for: indexPath) as! ClassesCell
        cell.labelName.text = "Invoice \(indexPath.row + 1)"
        cell.labelName.textColor = .black
        DispatchQueue.main.async {
            self.tableviewheightConstraint.constant = self.InvoicePaymentRecipeTableView.contentSize.height
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [self] in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
            vc.invoiceId = Int(payment_reciepts[indexPath.row].invoice_id ?? "")
            controller?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
