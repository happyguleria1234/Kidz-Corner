import UIKit

class PaymentDetail: UIViewController {
    
    @IBOutlet weak var tableDetails: UITableView!
    @IBOutlet weak var invoicelistTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnAction: UIButton!
    
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var invoiceCollectionView: UICollectionView!
    @IBOutlet weak var invoiceheightConstraint: NSLayoutConstraint!
    
    var taxAmount: String?
    var paymentId: Int?
    var paymentDetail: PaymentsData?
    var paymentDetail2: ReciptModelDatum?
    var totalAmount: String?
    var comesFrom = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable()
        updateCollection()
    }
    
    func updateCollection(){
        let layout = LeftAlignedCollectionViewFlowLayout()
        invoiceCollectionView.collectionViewLayout = layout
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableDetails.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                invoicelistTableViewHeightConstraint.constant = newsize.height
            }
        }
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
                let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SelectClass") as! SelectClass
                vc.payment_reciepts = paymentDetail?.payment_reciepts ?? []
                vc.comesFrom = "Payments"
                vc.callBack = { value in
                    DispatchQueue.main.async { [self] in
                        let story = UIStoryboard(name: "Parent", bundle: nil)
                        let vc = story.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
                        vc.invoiceId = value
                        self.navigationController?.pushViewController(vc, animated: true)
                        //                        controller?.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: false, completion: {
                })
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
        tableDetails.register(UINib(nibName: "InvoiceDetailsCellNewTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceDetailsCellNewTableViewCell")
        tableDetails.delegate = self
        tableDetails.dataSource = self
        invoiceCollectionView.delegate = self
        invoiceCollectionView.dataSource = self
        invoiceCollectionView.register(UINib(nibName: "InvoiceCollectionDataCell", bundle: nil), forCellWithReuseIdentifier: "InvoiceCollectionDataCell")
        lbl_amount.text = "$\(self.totalAmount ?? "")"
    }
    
}

extension PaymentDetail: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
        return paymentDetail?.payment_reciepts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvoiceCollectionDataCell", for: indexPath) as! InvoiceCollectionDataCell
        cell.invoiceListLbl.text = "Invoice \(paymentDetail?.payment_reciepts?[indexPath.row].receipt_id ?? "")"
//        cell.invoiceListLbl.text = "Download Invoice \(indexPath.row + 1)"
        DispatchQueue.main.async {
            self.invoiceheightConstraint.constant = self.invoiceCollectionView.contentSize.height
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if comesFrom == "Recipt" {
            if let invoiceId = self.paymentDetail2?.id {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
                vc.invoiceId = invoiceId
                vc.comesFrom = "Recipt"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if paymentDetail?.payment_reciepts?.count ?? 0 > 1{
                let story = UIStoryboard(name: "Parent", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
                vc.invoiceId = Int(paymentDetail?.payment_reciepts?[indexPath.item].invoice_id ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                if let invoiceId = self.paymentDetail?.id {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoicePdf") as! InvoicePdf
                    vc.invoiceId = invoiceId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if comesFrom == "Recipt" {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailsCellNewTableViewCell", for: indexPath) as! InvoiceDetailsCellNewTableViewCell
                return cell
            } else {
                let data = self.paymentDetail2?.items?[indexPath.row - 1]
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailCell", for: indexPath) as! InvoiceDetailCell
                cell.labelAmount.textColor = #colorLiteral(red: 0, green: 0.221154958, blue: 0.3455371857, alpha: 1)
                cell.labelDescription.textColor = #colorLiteral(red: 0, green: 0.221154958, blue: 0.3455371857, alpha: 1)
                cell.labelDescription.text = data?.description
                cell.viewOuter.firstColor = .clear
                cell.viewOuter.secondColor = .clear
                cell.viewOuter.backgroundColor = UIColor.clear
                cell.bottomLine.isHidden = false
                cell.labelAmount.text = "$\(String(data?.amount ?? 0))"
                DispatchQueue.main.async {
                    self.invoicelistTableViewHeightConstraint.constant = self.tableDetails.contentSize.height
                }
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailsCellNewTableViewCell", for: indexPath) as! InvoiceDetailsCellNewTableViewCell
                return cell
            } else {
                let data = self.paymentDetail?.invoiceItems?[indexPath.row - 1]
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailCell", for: indexPath) as! InvoiceDetailCell
                cell.labelAmount.textColor = #colorLiteral(red: 0, green: 0.221154958, blue: 0.3455371857, alpha: 1)
                cell.labelDescription.textColor = #colorLiteral(red: 0, green: 0.221154958, blue: 0.3455371857, alpha: 1)
                cell.labelDescription.text = data?.itemName
                cell.viewOuter.firstColor = .clear
                cell.viewOuter.secondColor = .clear
                cell.viewOuter.backgroundColor = UIColor.clear
                cell.bottomLine.isHidden = false
                cell.labelAmount.text = "$\(String(data?.itemCost ?? ""))"
                DispatchQueue.main.async {
                    self.invoicelistTableViewHeightConstraint.constant = self.tableDetails.contentSize.height
                }
                return cell
            }
        }
        
        
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDetailCell", for: indexPath) as! InvoiceDetailCell
        //        if comesFrom == "Recipt" {
        //            if indexPath.row < (self.paymentDetail2?.items?.count ?? 0) {
        //                let data = self.paymentDetail2?.items?[indexPath.row]
        //                cell.labelAmount.textColor = #colorLiteral(red: 0, green: 0.221154958, blue: 0.3455371857, alpha: 1)
        //                cell.labelDescription.textColor = #colorLiteral(red: 0, green: 0.221154958, blue: 0.3455371857, alpha: 1)
        //                cell.labelDescription.text = data?.description
        //                cell.viewOuter.firstColor = .clear
        //                cell.viewOuter.secondColor = .clear
        //                cell.viewOuter.backgroundColor = UIColor.clear
        //                cell.bottomLine.isHidden = false
        //                cell.labelAmount.text = "$\(String(data?.amount ?? 0))"
        //            } else {
        //                cell.labelDescription.text = "Total"
        //                cell.labelAmount.text = "$\(self.totalAmount ?? "")"
        //                cell.labelDescription.textColor = .white
        //                cell.labelAmount.textColor = .white
        //                cell.bottomLine.isHidden = true
        //                cell.viewOuter.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.6352941176, blue: 0.6392156863, alpha: 0.5121173469)
        ////                cell.viewOuter.firstColor = UIColor(named: "gradientTop")!
        ////                cell.viewOuter.secondColor = UIColor(named: "gradientBottom")!
        //            }
        //        } else {
        //            if indexPath.row < (self.paymentDetail?.invoiceItems?.count ?? 0) {
        //                let data = self.paymentDetail?.invoiceItems?[indexPath.row]
        //                cell.labelAmount.textColor = #colorLiteral(red: 0, green: 0.221154958, blue: 0.3455371857, alpha: 1)
        //                cell.labelDescription.textColor = #colorLiteral(red: 0, green: 0.221154958, blue: 0.3455371857, alpha: 1)
        //                cell.labelDescription.text = data?.itemName
        //                cell.viewOuter.firstColor = .clear
        //                cell.viewOuter.secondColor = .clear
        //                cell.bottomLine.isHidden = false
        //                cell.viewOuter.backgroundColor = UIColor.clear
        //                let cost = Int(data?.itemCost ?? "")
        //                let quantity = Int(data?.itemQty ?? "")
        //                let totalCost = (cost ?? 0) * (quantity ?? 0)
        //                printt("totalCost \(totalCost)")
        //                cell.labelAmount.text = "$\(String(totalCost))"
        //            } else {
        //                cell.labelDescription.text = "Total"
        //                cell.labelAmount.text = "$\(self.totalAmount ?? "")"
        //                cell.labelDescription.textColor = .white
        //                cell.labelAmount.textColor = .white
        //                cell.bottomLine.isHidden = true
        //                cell.viewOuter.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.6352941176, blue: 0.6392156863, alpha: 0.5121173469)
        ////                cell.viewOuter.firstColor = UIColor(named: "gradientTop")!
        ////                cell.viewOuter.secondColor = UIColor(named: "gradientBottom")!
        //            }
        //        }
        //        DispatchQueue.main.async {
        //            self.invoicelistTableViewHeightConstraint.constant = self.tableDetails.contentSize.height
        //        }
        //        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if indexPath.row == (self.paymentDetail?.invoiceItems?.count ?? 0) {
    //            return 50
    //        } else {
    //            return 50
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 35
        } else {
            return 50
        }
    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 0
    //    }
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}


