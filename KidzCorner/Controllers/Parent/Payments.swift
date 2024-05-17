import UIKit
import DropDown

class Payments: UIViewController {
    
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tablePayments: UITableView!
    @IBOutlet weak var amountCollectionView: UICollectionView!
        
    @IBOutlet weak var pageControl: UIPageControl!
    
    var paymentsData: PaymentsModel?
    var filteredPaymentsData: [PaymentsData] = []
    var childInfo: ChildAttendanceModel?
    var childrenData: [ChildData]? {
        didSet {
            self.amountCollectionView.reloadData()
        }
    }
    
    let albumsDropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDropDownData()
        getAllChildsAPI()
        registerTable()
        setupCollectionView()
    }
    
    func setDropDownData() {
        albumsDropdown.dismissMode = .onTap
        albumsDropdown.anchorView = tf_search
        albumsDropdown.bottomOffset = CGPoint(x: 0, y: tf_search.bounds.height)
        albumsDropdown.dataSource = ["3 Month","6 Month","9 Month","1 Year"]
        albumsDropdown.selectionAction = { [weak self] (index, item) in
            self?.tf_search.text = item
            if item == "3 Month" {
                self?.filteredPaymentsData = self?.filterPayments(forMonths: 3) ?? []
            } else if item == "6 Month" {
                self?.filteredPaymentsData = self?.filterPayments(forMonths: 6) ?? []
            } else if item == "6 Month" {
                self?.filteredPaymentsData = self?.filterPayments(forMonths: 9) ?? []
            } else {
                self?.filteredPaymentsData = self?.filterPayments(forMonths: 12) ?? []
            }
        }
    }
    
    @IBAction func btnDrop(_ sender: UIButton) {
        albumsDropdown.show()
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
        getPayments()
    }
    
    func registerTable() {
        tablePayments.register(UINib(nibName: "InvoiceCell", bundle: nil), forCellReuseIdentifier: "InvoiceCell")
        tablePayments.register(UINib(nibName: "InvoiceHeader", bundle: nil), forCellReuseIdentifier: "InvoiceHeader")
        tablePayments.delegate = self
        tablePayments.dataSource = self
        
        
        
        let nib = UINib(nibName: "InvoiceHeadCollectionCell", bundle: nil)
        amountCollectionView?.register(nib, forCellWithReuseIdentifier: "InvoiceHeadCollectionCell")
        
        
        // Set the dataSource and delegate
        amountCollectionView.dataSource = self
        amountCollectionView.delegate = self
        
    }
    
    func getAllChildsAPI() {
        
        ApiManager.shared.Request(type: AllChildrenModel.self, methodType: .Get, url: baseUrl+apiParentAllChild, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.childrenData = myObject?.data
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func filterPayments(forMonths months: Int) -> [PaymentsData] {
           let dateFormatter = ISO8601DateFormatter()
           let calendar = Calendar.current
           let currentDate = Date()
           guard let startDate = calendar.date(byAdding: .month, value: -months, to: currentDate) else { return [] }

        return paymentsData?.data?.filter { payment in
               if let paymentDate = dateFormatter.date(from: payment.createdAt ?? "") {
                   return paymentDate >= startDate && paymentDate <= currentDate
               }
               return false
        } ?? []
       }
    
    func getPayments() {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        let parameters = [String: String]()
        ApiManager.shared.Request(type: PaymentsModel.self, methodType: .Get, url: baseUrl+apiGetAllPayments, parameter: parameters) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.paymentsData = myObject
                self.filteredPaymentsData = myObject?.data ?? []
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

extension Payments: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = childrenData?.count ?? 0
        return childrenData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvoiceHeadCollectionCell", for: indexPath) as! InvoiceHeadCollectionCell
        cell.leftBtn.tag = indexPath.item
        cell.rightBtn.tag = indexPath.item
        cell.lblName.text = childrenData?[indexPath.item].name ?? ""
        cell.leftBtn.addTarget(self, action: #selector(scrollLeft(_:)), for: .touchUpInside)
        cell.rightBtn.addTarget(self, action: #selector(scrollRight(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    @objc func scrollLeft(_ sender: UIButton) {
        let currentIndex = sender.tag
        if currentIndex > 0 {
            let previousIndex = IndexPath(item: currentIndex - 1, section: 0)
            amountCollectionView.scrollToItem(at: previousIndex, at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == amountCollectionView {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2
            
            pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
        }
    }
    
    @objc func scrollRight(_ sender: UIButton) {
        let currentIndex = sender.tag
        if currentIndex < collectionView(amountCollectionView, numberOfItemsInSection: 0) - 1 {
            let nextIndex = IndexPath(item: currentIndex + 1, section: 0)
            amountCollectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        amountCollectionView.collectionViewLayout.invalidateLayout()
    }
}
