import UIKit

class PaymentDetail: UIViewController {
    
    @IBOutlet weak var tableDetails: UITableView!
    @IBOutlet weak var invoicelistTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnAction: UIButton!
    
    var taxAmount: String?
    var paymentId: Int?
    var paymentDetail: PaymentsData?
    var paymentDetail2: ReciptModelDatum?
    var totalAmount: String?
    var comesFrom = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableDetails.reloadData()
        }
        if comesFrom != "Recipt" {
            if paymentDetail?.payment_reciepts?.count ?? 0 > 1{
                self.btnAction.setImage(UIImage(named: "filter"), for: .normal)
            }else{
                self.btnAction.setImage(UIImage(named: "downloads"), for: .normal)
            }
        }else{
            self.btnAction.setImage(UIImage(named: "downloads"), for: .normal)
        }
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true, completion: {
            
        })
    }
    
    @IBAction func viewInvoicePDFBtn(_ sender: UIButton) {
        if comesFrom == "Recipt" {
            if let invoiceId = self.paymentDetail2?.id {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
                vc.invoiceId = invoiceId
                vc.comesFrom = "Recipt"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if paymentDetail?.payment_reciepts?.count ?? 0 > 1{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePaymentRecipeLisVC") as! InvoicePaymentRecipeLisVC
                vc.modalPresentationStyle = .overFullScreen
                vc.payment_reciepts = paymentDetail?.payment_reciepts ?? []
                vc.controller = self
                self.navigationController?.present(vc, animated: false)
            }else{
                if let invoiceId = self.paymentDetail?.id {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
                    vc.invoiceId = invoiceId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    func registerTable() {
        tableDetails.register(UINib(nibName: "InvoiceDetailCell", bundle: nil), forCellReuseIdentifier: "InvoiceDetailCell")
        tableDetails.register(UINib(nibName: "InvoiceDetailHeader", bundle: nil), forCellReuseIdentifier: "InvoiceDetailHeader")
        tableDetails.register(UINib(nibName: "InvoiceDetailFooter", bundle: nil), forCellReuseIdentifier: "InvoiceDetailFooter")
        tableDetails.delegate = self
        tableDetails.dataSource = self
    }
}

extension PaymentDetail: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comesFrom == "Recipt" {
            return (self.paymentDetail2?.items?.count ?? 0) + 1
        } else {
            return (self.paymentDetail?.invoiceItems?.count ?? 0) + 1
        }
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailHeader") as! InvoiceDetailHeader
//        let data = self.paymentDetail
//        
//        cell.labelName.text = data?.student?.name
//        cell.labelId.text = String(data?.id ?? 0)
//        cell.labelCycle.text = "\(data?.invoiceStartDate ?? "") - \(data?.invoiceEndDate ?? "")"
//        cell.labelDueDate.text = data?.invoicePaymentDue
//
//        switch data?.status {
//        case "1":
//            cell.labelStatus.text = "Due"
//            cell.labelStatus.textColor = UIColor(named: "denyColor")!
//        case "2":
//            cell.labelStatus.text = "Paid"
//            cell.labelStatus.textColor = myGreenColor
//        case "4":
//            cell.labelStatus.text = "Partial"
//            cell.labelStatus.textColor = .systemOrange
//
//        case .none:
//            printt("No status")
//        case .some(_):
//            printt("Case Some")
//        }
//        return cell
//    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailFooter") as! InvoiceDetailFooter
//        cell.viewInvoice.tag = section
//        let data = self.paymentDetail
//        if comesFrom == "Recipt" {
//            cell.viewInvoice.setTitle("View Receipt PDF", for: .normal)
//        } else {
//            cell.viewInvoice.setTitle("View Invoice PDF", for: .normal)
////            if data?.status == "1" {
////                cell.viewInvoice.setTitle("View Invoice PDF", for: .normal)
////            } else {
////                cell.viewInvoice.setTitle("View Receipt PDF", for: .normal)
////            }
//        }
//        cell.viewInvoice.addTarget(self, action: #selector(showInvoice), for: .touchUpInside)
//        return cell
//    }
    
//    @objc func showInvoice(sender: UIButton) {
//        if comesFrom == "Recipt" {
//            if let invoiceId = self.paymentDetail2?.id {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
//                vc.invoiceId = invoiceId
//                vc.comesFrom = "Recipt"
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        } else {
//            if let invoiceId = self.paymentDetail?.id {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
//                vc.invoiceId = invoiceId
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailCell", for: indexPath) as! InvoiceDetailCell
        if comesFrom == "Recipt" {
            if indexPath.row < (self.paymentDetail2?.items?.count ?? 0) {
                let data = self.paymentDetail2?.items?[indexPath.row]
                cell.labelAmount.textColor = UIColor(named: "myDarkGreen")!
                cell.labelDescription.textColor = UIColor(named: "myDarkGreen")!
                cell.labelDescription.text = data?.description
                cell.viewOuter.firstColor = .clear
                cell.viewOuter.secondColor = .clear
                cell.viewOuter.backgroundColor = UIColor.clear
                cell.bottomLine.isHidden = false
                cell.labelAmount.text = "$\(String(data?.amount ?? 0))"
                
            } else {
                cell.labelDescription.text = "Total"
                cell.labelAmount.text = "$\(self.totalAmount ?? "")"
                cell.labelDescription.textColor = .white
                cell.labelAmount.textColor = .white
                cell.bottomLine.isHidden = true
                cell.viewOuter.firstColor = UIColor(named: "gradientTop")!
                cell.viewOuter.secondColor = UIColor(named: "gradientBottom")!
            }
        } else {
            if indexPath.row < (self.paymentDetail?.invoiceItems?.count ?? 0) {
                let data = self.paymentDetail?.invoiceItems?[indexPath.row]
                cell.labelAmount.textColor = UIColor(named: "myDarkGreen")!
                cell.labelDescription.textColor = UIColor(named: "myDarkGreen")!
                cell.labelDescription.text = data?.itemName
                cell.viewOuter.firstColor = .clear
                cell.viewOuter.secondColor = .clear
                cell.bottomLine.isHidden = false
                cell.viewOuter.backgroundColor = UIColor.clear
                let cost = Int(data?.itemCost ?? "")
                let quantity = Int(data?.itemQty ?? "")
                let totalCost = (cost ?? 0) * (quantity ?? 0)
                printt("totalCost \(totalCost)")
                cell.labelAmount.text = "$\(String(totalCost))"
            } else {
                cell.labelDescription.text = "Total"
                cell.labelAmount.text = "$\(self.totalAmount ?? "")"
                cell.labelDescription.textColor = .white
                cell.labelAmount.textColor = .white
                cell.bottomLine.isHidden = true
                cell.viewOuter.firstColor = UIColor(named: "gradientTop")!
                cell.viewOuter.secondColor = UIColor(named: "gradientBottom")!
            }
        }
        DispatchQueue.main.async {
            self.invoicelistTableViewHeightConstraint.constant = self.tableDetails.contentSize.height
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == (self.paymentDetail?.invoiceItems?.count ?? 0) {
            return 75
        } else {
            return 50
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 60
//    }    
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}
