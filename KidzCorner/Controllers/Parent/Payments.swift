import UIKit
import DropDown

class Payments: UIViewController {
    
    var currentIndexPath: IndexPath?
    
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tablePayments: UITableView!
    @IBOutlet weak var amountCollectionView: UICollectionView!
    var previouslyDisplayedIndexPath: IndexPath?
    
    @IBOutlet weak var pageControl: UIPageControl!
    var total = Int()
    var paymentsData: PaymentsModel?
    var filteredPaymentsData: [PaymentsData] = []
    var childInfo: ChildAttendanceModel?
    var childrenData = [ChildData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnDrop(_ sender: UIButton) {
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
        tablePayments.register(UINib(nibName: "InvoiceCell", bundle: nil), forCellReuseIdentifier: "InvoiceCell")
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
                    self.getPayments(userId: myObject?.data?.last?.id ?? 0)
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func getPayments(userId: Int = 0) {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
        total = 0
        let parameters = ["userId": userId]
        ApiManager.shared.Request(type: PaymentsModel.self, methodType: .Get, url: baseUrl+apiGetAllPayments, parameter: parameters) { [weak self] error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if statusCode == 200 {
                    self.paymentsData = myObject
                    self.filteredPaymentsData = myObject?.data ?? []
                    self.total = myObject?.data?.reduce(0, { $0 + (Int($1.amount ?? "") ?? 0) }) ?? 0
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
        return self.paymentsData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeader") as! InvoiceHeader
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell", for: indexPath) as! InvoiceCell
        let data = self.paymentsData?.data?[indexPath.row]
        cell.labelName.text = data?.student?.name ?? ""
        cell.labelDate.text = data?.invoiceEndDate ?? ""
        cell.labelAmount.text = "$\(data?.amount ?? "")"
        if data?.status == "1" {
            cell.labelColors(UIColor(named: "statsColor")!)
            cell.viewOuter.firstColor = .clear
            cell.viewOuter.secondColor = .clear
            cell.viewOuter.backgroundColor = UIColor.clear
            cell.labelStatus.text = "Due"
            cell.labelStatus.textColor = .red
            cell.viewOuter.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 1, opacity: 0.0, shadowColor: .clear, cornerRadius: 1)
        } else if data?.status == "2" {
            cell.viewOuter.shadowWithRadius(radius: 5)
            cell.viewOuter.firstColor = UIColor(named: "gradientTop")!
            cell.viewOuter.secondColor = UIColor(named: "gradientBottom")!
            cell.labelStatus.text = "Paid"
            cell.labelColors(.white)
            cell.labelStatus.textColor = .white
        } else if data?.status == "4" {
            cell.labelColors(UIColor(named: "statsColor")!)
            cell.viewOuter.firstColor = .clear
            cell.viewOuter.secondColor = .clear
            cell.viewOuter.backgroundColor = UIColor.clear
            cell.labelStatus.text = "Partial"
            cell.labelStatus.textColor = .systemOrange
            cell.viewOuter.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 1, opacity: 0.0, shadowColor: .clear, cornerRadius: 1)
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
        pageControl.numberOfPages = childrenData.count
        return childrenData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvoiceHeadCollectionCell", for: indexPath) as! InvoiceHeadCollectionCell
        var userData = [ChildData]()
        userData = childrenData.reversed()
        cell.leftBtn.tag = indexPath.item
        cell.rightBtn.tag = indexPath.item
        cell.lblName.text = userData[indexPath.item].name ?? ""
        cell.amountLbl.text = "$\(total)"
        cell.leftBtn.addTarget(self, action: #selector(scrollLeft(_:)), for: .touchUpInside)
        cell.rightBtn.addTarget(self, action: #selector(scrollRight(_:)), for: .touchUpInside)
        
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
    
    @objc func scrollLeft(_ sender: UIButton) {
        let currentIndex = sender.tag
        if currentIndex > 0 {
            let previousIndex = IndexPath(item: currentIndex - 1, section: 0)
            amountCollectionView.scrollToItem(at: previousIndex, at: .centeredHorizontally, animated: true)
            getPayments(userId: childrenData[sender.tag].id ?? 0)
        }
    }
    
    @objc func scrollRight(_ sender: UIButton) {
        let currentIndex = sender.tag
        if currentIndex < collectionView(amountCollectionView, numberOfItemsInSection: 0) - 1 {
            getPayments(userId: childrenData[sender.tag].id ?? 0)
            let nextIndex = IndexPath(item: currentIndex + 1, section: 0)
            amountCollectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        getPayments(userId: childrenData[currentPage].id ?? 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        amountCollectionView.collectionViewLayout.invalidateLayout()
    }
}
