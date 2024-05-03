import UIKit

class Payments: UIViewController {
    @IBOutlet weak var tablePayments: UITableView!
    
    var paymentsData: PaymentsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getPayments()
        
    }
    
    func registerTable() {
        tablePayments.register(UINib(nibName: "InvoiceCell", bundle: nil), forCellReuseIdentifier: "InvoiceCell")
        tablePayments.register(UINib(nibName: "InvoiceHeader", bundle: nil), forCellReuseIdentifier: "InvoiceHeader")
        tablePayments.delegate = self
        tablePayments.dataSource = self
    }
    
    func getPayments() {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        
        let parameters = [String: String]()
        ApiManager.shared.Request(type: PaymentsModel.self, methodType: .Get, url: baseUrl+apiGetAllPayments, parameter: parameters) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.paymentsData = myObject
                print(myObject)
                DispatchQueue.main.async {
                    self.tablePayments.reloadData()
                }
               
            }
            else {
                Toast.show(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
}

extension Payments: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentsData?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeader") as! InvoiceHeader
        
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell", for: indexPath) as! InvoiceCell
        
        let data = self.paymentsData?.data?[indexPath.row]
        
        printt("Name \(self.paymentsData?.data?[0].student?.name ?? "")")
        
        cell.labelName.text = self.paymentsData?.data?[0].student?.name ?? ""
        cell.labelDate.text = data?.invoiceEndDate ?? ""
        cell.labelAmount.text = "$\(data?.amount ?? "")"

        if self.paymentsData?.data?[indexPath.row].status == "1" {
            cell.labelColors(UIColor(named: "statsColor")!)
            cell.viewOuter.firstColor = .clear
            cell.viewOuter.secondColor = .clear
            cell.viewOuter.backgroundColor = UIColor.clear
            cell.labelStatus.text = "Due"
            cell.labelStatus.textColor = .red
            cell.viewOuter.giveShadowAndRoundCorners(shadowOffset: CGSize.zero, shadowRadius: 1, opacity: 0.0, shadowColor: .clear, cornerRadius: 1)
        }
        else if self.paymentsData?.data?[indexPath.row].status == "2" {
            cell.viewOuter.shadowWithRadius(radius: 5)
            cell.viewOuter.firstColor = UIColor(named: "gradientTop")!
            cell.viewOuter.secondColor = UIColor(named: "gradientBottom")!
            cell.labelStatus.text = "Paid"
            cell.labelColors(.white)
            cell.labelStatus.textColor = .white
        }
    
    return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentDetail") as! PaymentDetail
        vc.paymentId = self.paymentsData?.data?[indexPath.row].id
        vc.paymentDetail = self.paymentsData?.data?[indexPath.row]
        
        let amountArr = self.paymentsData?.data?[indexPath.row].invoiceItems?.compactMap {
            (Int($0.itemCost ?? "0") ?? 0) * (Int($0.itemQty ?? "0") ?? 0)
        }
        let totalAmountInteger = amountArr?.sum()
        
        vc.totalAmount = String(totalAmountInteger ?? 0)
        vc.taxAmount = self.paymentsData?.data?[indexPath.row].tax ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
