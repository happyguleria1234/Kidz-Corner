import UIKit

protocol classSelected: NSObjectProtocol {
    func selectedClass(classId: Int,className: String)
}

class SelectClass: UIViewController {
    
    var classes: AllClassesModel?
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var tableClasses: UITableView!
    
    var delegate: classSelected?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gradientView.layer.opacity = 0.4
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        setupTable()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            let height = self.tableClasses.contentSize.height
            self.tblHeight.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       getClasses()
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
        return self.classes?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesCell", for: indexPath) as! ClassesCell
        
        cell.labelName.text = self.classes?.data?[indexPath.row].name ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false) {
            self.delegate?.selectedClass(classId: self.classes?.data?[indexPath.row].id ?? 0, className: self.classes?.data?[indexPath.row].name ?? "")
        }
    }
}
