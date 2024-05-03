import UIKit

class PaymentDetail: UIViewController {
    
    @IBOutlet weak var tableDetails: UITableView!
    
    var taxAmount: String?
    var paymentId: Int?
    var paymentDetail: PaymentsData?
    var totalAmount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableDetails.reloadData()
        }
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true, completion: {
            
        })
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
        return (self.paymentDetail?.invoiceItems?.count ?? 0) + 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailHeader") as! InvoiceDetailHeader
        let data = self.paymentDetail
        
        cell.labelName.text = data?.student?.name
        cell.labelId.text = String(data?.id ?? 0)
        cell.labelCycle.text = "\(data?.invoiceStartDate ?? "") - \(data?.invoiceEndDate ?? "")"
        cell.labelDueDate.text = data?.invoicePaymentDue

        switch data?.status {
        case "1":
            cell.labelStatus.text = "Due"
            cell.labelStatus.textColor = UIColor(named: "denyColor")!
        case "2":
            cell.labelStatus.text = "Paid"
            cell.labelStatus.textColor = myGreenColor
        case .none:
            printt("No status")
        case .some(_):
            printt("Case Some")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailFooter") as! InvoiceDetailFooter
        cell.viewInvoice.tag = section
        cell.viewInvoice.addTarget(self, action: #selector(showInvoice), for: .touchUpInside)
        return cell
    }
    
    @objc func showInvoice(sender: UIButton) {
        if let invoiceId = self.paymentDetail?.id {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
            vc.invoiceId = invoiceId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailCell", for: indexPath) as! InvoiceDetailCell
        
        if indexPath.row < (self.paymentDetail?.invoiceItems?.count ?? 0) {
            
            let data = self.paymentDetail?.invoiceItems?[indexPath.row]
            
            cell.labelAmount.textColor = UIColor(named: "myDarkGreen")!
            cell.labelDescription.textColor = UIColor(named: "myDarkGreen")!
            cell.labelDescription.text = data?.itemName
            
            cell.viewOuter.firstColor = .clear
            cell.viewOuter.secondColor = .clear
            cell.viewOuter.backgroundColor = UIColor.clear
            
            let cost = Int(data?.itemCost ?? "")
            let quantity = Int(data?.itemQty ?? "")
            let totalCost = (cost ?? 0) * (quantity ?? 0)
            printt("totalCost \(totalCost)")
            cell.labelAmount.text = "$\(String(totalCost))"
            
        }
        else {
            cell.labelDescription.text = "Total"
            cell.labelAmount.text = "$\(self.totalAmount ?? "")"
            cell.labelDescription.textColor = .white
            cell.labelAmount.textColor = .white
            cell.viewOuter.firstColor = UIColor(named: "gradientTop")!
            cell.viewOuter.secondColor = UIColor(named: "gradientBottom")!
            //cell.viewOuter.shadowWithRadius(radius: 5)
        }
        
    return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == (self.paymentDetail?.invoiceItems?.count ?? 0) {
          return 75
        }
        else {
        return 50
    }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }    
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}
