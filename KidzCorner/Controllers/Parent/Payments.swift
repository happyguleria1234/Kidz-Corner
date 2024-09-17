import UIKit
//import DropDown

class Payments: UIViewController {
    
    @IBOutlet weak var btn_recipt: UIButton!
    @IBOutlet weak var btn_invoice: UIButton!
    var currentIndexPath: IndexPath?
    var comesFrom = String()
//    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tablePayments: UITableView!
    @IBOutlet weak var amountCollectionView: UICollectionView!
    var previouslyDisplayedIndexPath: IndexPath?
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var total = Int()
    var paymentsData: PaymentsModel?
    var paymentsData2: ReciptModel?
    var filteredPaymentsData: [PaymentsData] = []
    var filteredPaymentsData2: [ReciptModelDatum] = []
    var childInfo: ChildAttendanceModel?
    var childrenData = [ChildData]()
    var selectedType = 1
    var selectedUserID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_recipt.cornerRadius = 10
        btn_invoice.cornerRadius = 10
        self.tabBarController?.tabBar.isHidden = true
        btn_invoice.setTitleColor(UIColor(named: "myDarkGreen"), for: .normal)
        btn_invoice.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn_recipt.setTitleColor(UIColor.white, for: .normal)
        btn_recipt.backgroundColor = #colorLiteral(red: 0.2741542459, green: 0.6354581118, blue: 0.6397424936, alpha: 1)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        if comesFrom == "" {
            self.navigationController?.popViewController(animated: true)
        } else {
            gotoHome()
        }
    }
    
    @IBAction func btnRecipt(_ sender: UIButton) {
        selectedType = 2
        btn_recipt.setTitleColor(UIColor(named: "myDarkGreen"), for: .normal)
        btn_recipt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn_invoice.setTitleColor(UIColor.white, for: .normal)
        btn_invoice.backgroundColor = #colorLiteral(red: 0.2741542459, green: 0.6354581118, blue: 0.6397424936, alpha: 1)
        getRecipts(userId: selectedUserID)
    }

    @IBAction func btnInvoice(_ sender: UIButton) {
        selectedType = 1
        btn_invoice.setTitleColor(UIColor(named: "myDarkGreen"), for: .normal)
        btn_invoice.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn_recipt.setTitleColor(UIColor.white, for: .normal)
        btn_recipt.backgroundColor = #colorLiteral(red: 0.2741542459, green: 0.6354581118, blue: 0.6397424936, alpha: 1)
        getPayments(userId: selectedUserID)
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "InvoiceHeadCollectionCell", bundle: nil)
        amountCollectionView.register(nib, forCellWithReuseIdentifier: "InvoiceHeadCollectionCell")
        
        // Set the dataSource and delegate
        amountCollectionView.dataSource = self
        amountCollectionView.delegate = self
        
        // Configure layout
        if let layout = amountCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        // Enable paging
        amountCollectionView.isPagingEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllChildsAPI()
        registerTable()
        setupCollectionView()
    }
    
    func registerTable() {
        tablePayments.register(UINib(nibName: "InvoiceNewCell", bundle: nil), forCellReuseIdentifier: "InvoiceNewCell")
//        tablePayments.register(UINib(nibName: "InvoiceCell", bundle: nil), forCellReuseIdentifier: "InvoiceCell")
        tablePayments.register(UINib(nibName: "InvoiceHeader", bundle: nil), forCellReuseIdentifier: "InvoiceHeader")
        tablePayments.delegate = self
        tablePayments.dataSource = self
        
        let nib = UINib(nibName: "InvoiceHeadCollectionCell", bundle: nil)
        amountCollectionView?.register(nib, forCellWithReuseIdentifier: "InvoiceHeadCollectionCell")
        
        amountCollectionView.dataSource = self
        amountCollectionView.delegate = self
    }
    
    func getAllChildsAPI() {
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { [weak self] error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if statusCode == 200 {
                    self.childrenData = myObject?.data ?? []
                    self.amountCollectionView.reloadData()
                    self.getPayments(userId: myObject?.data?.first?.id ?? 0)
                    self.selectedUserID = myObject?.data?.first?.id ?? 0
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func getPayments(userId: Int = 0) {
        DispatchQueue.main.async {
            if self.comesFrom == "" {
                startAnimating(self.view)
//                startAnimating((self.tabBarController?.view)!)
            }
        }
        total = 0
        let parameters = ["userId": userId]
        ApiManager.shared.Request(type: PaymentsModel.self, methodType: .Get, url: baseUrl+apiGetAllPayments, parameter: parameters) { [weak self] error, myObject, msgString, statusCode in
            DispatchQueue.main.async { [self] in
                guard let self = self else { return }
                if statusCode == 200 {
                    self.paymentsData = myObject
                    self.filteredPaymentsData = myObject?.data ?? []
                    myObject?.data?.forEach({ data in
                        if data.status != "2" {
                            let amount = Int(data.amount ?? "")
                            self.total = self.total + (amount ?? 0)
                        }
                    })
                    self.tablePayments.reloadData()
                    self.amountCollectionView.reloadData()
                } else {
                    Toast.show(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func getRecipts(userId: Int = 0) {
        DispatchQueue.main.async {
            if self.comesFrom == "" {
                startAnimating((self.tabBarController?.view)!)
            }
        }
        
        total = 0
        let parameters = ["student_id": userId]
        
        ApiManager.shared.Request(type: ReciptModel.self, methodType: .Get, url: baseUrl+recipts, parameter: parameters) { [weak self] error, myObject, msgString, statusCode in
            DispatchQueue.main.async { [self] in
                guard let self = self else { return }
                
                if statusCode == 200 {
                    self.paymentsData2 = myObject
                    self.filteredPaymentsData2 = myObject?.data ?? []
                    
                    myObject?.data?.forEach({ data in
                        // Safely unwrap totalPaid and convert it to Double first
                        if let totalPaidString = data.totalPaid, let amountDouble = Double(totalPaidString) {
                            // Convert the Double to Int if you only want the integer part
                            let amount = Int(amountDouble)
                            self.total += amount
                        } else {
                            print("Invalid totalPaid value: \(data.totalPaid ?? "nil")")
                        }
                    })
                    
                    print("Total calculated: \(self.total)")
                    
                    self.tablePayments.reloadData()
                    self.amountCollectionView.reloadData()
                } else {
                    Toast.show(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
}

extension Payments: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType == 1 {
            return self.paymentsData?.data?.count ?? 0
        } else {
            return self.paymentsData2?.data?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceNewCell", for: indexPath) as! InvoiceNewCell
        
        if selectedType == 1 {
            
            let data = self.paymentsData?.data?[indexPath.row]
            cell.lbl_date.text = convertDateFormat(dateString: data?.invoiceEndDate ?? "")
            cell.lbl_amount.text = "$\(data?.amount ?? "")"
//            cell.lbl_paid.textColor = .white
            cell.lbl_paid.cornerRadius = 12
            cell.lbl_invoicenumber.text = data?.invoice_id
            if data?.status == "1" {
                cell.lbl_paid.text = "Due"
                cell.lbl_paid.textColor = #colorLiteral(red: 0.85123384, green: 0.4668435454, blue: 0.5514846444, alpha: 1)
                cell.lbl_paid.backgroundColor = #colorLiteral(red: 1, green: 0.8900536895, blue: 0.9094808102, alpha: 1)
            } else if data?.status == "2" {
                cell.lbl_paid.text = "Paid"
                cell.lbl_paid.textColor = #colorLiteral(red: 0.3588545322, green: 0.6942057014, blue: 0.5601734519, alpha: 1)
                cell.lbl_paid.backgroundColor = #colorLiteral(red: 0.8739464879, green: 0.9999284148, blue: 0.9548007846, alpha: 1)
//                cell.lbl_paid.backgroundColor = UIColor(named: "gradientBottom")!
            } else if data?.status == "4" {
                cell.lbl_paid.text = "Partial"
                cell.lbl_paid.textColor = #colorLiteral(red: 0.85123384, green: 0.4668435454, blue: 0.5514846444, alpha: 1)
                cell.lbl_paid.backgroundColor = #colorLiteral(red: 1, green: 0.8900536895, blue: 0.9094808102, alpha: 1)
            }
        } else {
            let data = self.paymentsData2?.data?[indexPath.row]
            cell.lbl_date.text = data?.date ?? ""
            cell.lbl_amount.text = "$\(data?.totalPaid ?? "")"
            cell.lbl_paid.textColor = .white
            cell.lbl_paid.cornerRadius = 5
            cell.lbl_invoicenumber.text = data?.receiptID
            
            cell.lbl_paid.text = "Paid"
            cell.lbl_paid.backgroundColor = UIColor(named: "gradientBottom")!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedType == 1 {
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
            
        } else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentDetail") as! PaymentDetail
            vc.paymentId = self.paymentsData2?.data?[indexPath.row].id
            vc.paymentDetail2 = self.paymentsData2?.data?[indexPath.row]
            var totalAmount = Int()
            self.paymentsData2?.data?[indexPath.row].items?.forEach({ data in
                totalAmount = totalAmount + (data.amount ?? 0)
            })
            vc.comesFrom = "Recipt"
            vc.totalAmount = String(totalAmount)
            vc.taxAmount = ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension Payments: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = childrenData.count
        return childrenData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvoiceHeadCollectionCell", for: indexPath) as! InvoiceHeadCollectionCell
        var userData = [ChildData]()
        userData = childrenData
        cell.leftBtn.tag = indexPath.item
        cell.rightBtn.tag = indexPath.item
        cell.lblName.text = userData[indexPath.item].name ?? ""
        cell.amountLbl.text = "$\(total)"
//        cell.leftBtn.addTarget(self, action: #selector(scrollLeft(_:)), for: .touchUpInside)
//        cell.rightBtn.addTarget(self, action: #selector(scrollRight(_:)), for: .touchUpInside)
        
        if childrenData.count <= 1 {
            cell.leftBtn.isHidden = true
            cell.rightBtn.isHidden = true
        } else {
            cell.leftBtn.isHidden = false
            cell.rightBtn.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    // MARK: - UIScrollViewDelegate
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageWidth = scrollView.frame.size.width
//        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
//        if selectedType == 1 {
//            getPayments(userId: childrenData[currentPage].id ?? 0)
//        } else {
//            getRecipts(userId: childrenData[currentPage].id ?? 0)
//        }
//        selectedUserID = childrenData[currentPage].id ?? 0
//        pageControl.currentPage = currentPage
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView is UICollectionView {
            let pageWidth = scrollView.frame.size.width
            let currentPage = Int(scrollView.contentOffset.x / pageWidth)
            if selectedType == 1 {
                getPayments(userId: childrenData[currentPage].id ?? 0)
            } else {
                getRecipts(userId: childrenData[currentPage].id ?? 0)
            }
            selectedUserID = childrenData[currentPage].id ?? 0
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        amountCollectionView.collectionViewLayout.invalidateLayout()
    }
}

func convertDateFormat(dateString: String) -> String? {
    // Define the input and output date formats
    let inputDateFormat = "dd-MM-yyyy"
    let outputDateFormat = "dd-MM-yyyy"
    
    // Create DateFormatter instances
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = inputDateFormat
    
    // Convert the input string to a Date object
    guard let date = dateFormatter.date(from: dateString) else {
        return nil
    }
    
    // Set the output format
    dateFormatter.dateFormat = outputDateFormat
    
    // Convert the Date object back to a string in the desired format
    return dateFormatter.string(from: date)
}
