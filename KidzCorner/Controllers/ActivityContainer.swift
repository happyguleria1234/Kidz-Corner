import UIKit

class ActivityContainer: UIViewController {
    
    var portfolioData: DashboardModel?
    
    @IBOutlet weak var tableActivity: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        printt("Activity Container Appeared")
        let studentId = UserDefaults.standard.integer(forKey: "selectedStudent")
        getTeacherPortfolio(studentId: studentId)
    }
    
    func setupViews() {
        DispatchQueue.main.async { [self] in
        self.view.layer.cornerRadius = 20
    }
    }
    
    func registerTable() {
        tableActivity.register(UINib(nibName: "DashboardTableCell", bundle: nil), forCellReuseIdentifier: "DashboardTableCell")
        tableActivity.delegate = self
        tableActivity.dataSource = self
    }
    
    func getTeacherPortfolio(studentId: Int) {
        
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        var params = [String: Any]()
        params = ["student_id": studentId
                ]
        
        ApiManager.shared.Request(type: DashboardModel.self, methodType: .Get, url: baseUrl+apiGetPortfolio, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async { [self] in
                    
                    print(myObject)
                    portfolioData = myObject
                    DispatchQueue.main.async {
                        self.tableActivity?.reloadData()
                    }
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
}

extension ActivityContainer: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.portfolioData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableCell", for: indexPath) as! DashboardTableCell
        
        let data = self.portfolioData?.data?[indexPath.row]
        
  //      cell.cellContent = self.portfolioData?.data?[indexPath.row].portfoilos
        
     //   cell.imageProfile.sd_SetImage(imgUrl: imageBaseUrl+(data?.teachers?.image ?? ""), placeholder: .placeholderImage)
        
   //     cell.labelName.text = data?.teachers?.fname ?? ""
        cell.labelDescription.text = data?.postContent ?? ""
        cell.labelTime.text = data?.postDate ?? ""
        
        cell.buttonLike.setImage(UIImage(named: "likeEmpty"), for: .normal)
        cell.buttonLike.setImage(UIImage(named: "likeFilled"), for: .selected)
        
        cell.buttonLike.tag = indexPath.row
        
      //  cell.buttonLike.addTarget(self, action: #selector(likeFunc), for: .touchUpInside)
        
        cell.viewOuter.defaultShadow()
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .clear
        return cell
    }
}
