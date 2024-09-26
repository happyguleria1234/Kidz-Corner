import UIKit

protocol classSelected: NSObjectProtocol {
    func selectedClass(classId: Int,className: String)
}

class SelectClass: UIViewController {
    
    var classes: AllClassesModel?
    var controller:UIViewController?
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var tableClasses: UITableView!
    var payment_reciepts = [payment_recieptsData]()
    var delegate: classSelected?
    var comesFrom = String()
    var callBack: ((Int)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupTable()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                tblHeight.constant = newsize.height
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        tableClasses.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableClasses.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if comesFrom != "Payments" {
            getClasses()
        }
    }
    
    @IBAction func topDismiss(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func bottomDismiss(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }
    
    func setupTable() {
        tableClasses.register(UINib(nibName: "ClassesCell", bundle: nil), forCellReuseIdentifier: "ClassesCell")
        tableClasses.delegate = self
        tableClasses.dataSource = self
    }
    
    func getClasses() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        let params = [String: String]()
        ApiManager.shared.Request(type: AllClassesModel.self, methodType: .Get, url: baseUrl+apiGetAllClasses, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    self.classes = myObject
                    self.tableClasses.reloadData()
                }
            }
            else {
               printt("Error fetching classes")
            }
        }
    }
}

extension SelectClass: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comesFrom == "Payments" {
            return payment_reciepts.count
        } else {
            return self.classes?.data?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesCell", for: indexPath) as! ClassesCell
        if comesFrom == "Payments" {
            cell.labelName.text = "Invoice \(indexPath.row + 1)"
        } else {
            cell.labelName.text = self.classes?.data?[indexPath.row].name ?? ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if comesFrom == "Payments" {
            dismiss(animated: true) { [self] in
                callBack?(Int(self.payment_reciepts[indexPath.row].invoice_id ?? "") ?? 0)
            }
        } else {
            self.dismiss(animated: false) {
                self.delegate?.selectedClass(classId: self.classes?.data?[indexPath.row].id ?? 0, className: self.classes?.data?[indexPath.row].name ?? "")
            }
        }
    }
}
