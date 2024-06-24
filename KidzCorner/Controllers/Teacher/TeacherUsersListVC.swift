import UIKit

protocol OpenChatVCProtocol:AnyObject {
    func openChat(_ studentID:Int,_ userProfileImage:String?,_ userName:String?)
}

class TeacherUsersListVC: UIViewController {
    
    private var allChildrenData = [ChildrenList]()
    private var childrenData = [ChildrenList]()
    weak var delegate:OpenChatVCProtocol?
    
    var isComing = String()
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentList()
    }
    
    @IBAction func chatDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        let searchedText = textField.text
        handleChatUserSearch(searchedText)
    }
    
    private func handleChatUserSearch(_ searchedText: String?) {
        var filteredUserList = [ChildrenList]()
        
        if let searchedText = searchedText?.lowercased(), !searchedText.isEmpty {
            filteredUserList = childrenData.filter { chatData in
                if var name = chatData.name {
                    name = name.lowercased()
                    return name.contains(searchedText)
                }
                return false
            }
        } else {
            filteredUserList = allChildrenData
        }
        
        self.childrenData = filteredUserList
        self.tblList.reloadData()
    }
}
extension TeacherUsersListVC {
    
    private func showIndicator() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
    }
    
    private func stopIndicator() {
        DispatchQueue.main.async {
            stopAnimating()
        }
    }
    
    struct GeneralModel :Codable{
        
    }
    
    func getStudentList() {
        showIndicator()
        ApiManager.shared.Request(type: ChildrenListModel.self,
                                  methodType: .Get,
                                  url: baseUrl+"all_children",
                                  parameter: [:]) { error, resp, msgString, statusCode in
            
            guard error == nil,
                  let userlist = resp?.data?.data,
                  statusCode == 200 else {
                self.stopIndicator()
                return }
            
            DispatchQueue.main.async {
                self.stopIndicator()
                self.allChildrenData = userlist
                self.childrenData = userlist
                self.tblList.reloadData()
                print("CharRoomResp: \(userlist)")
            }
        }
    }
}
extension TeacherUsersListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        childrenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
        let data = childrenData[indexPath.row]
        cell.lblName.text = data.name
        cell.img_profile.contentMode = .scaleAspectFill
        if let userProfileUrl = data.image {
            cell.img_profile.sd_setImage(with: URL(string: imageBaseUrl+(userProfileUrl)),
                                   placeholderImage: .announcementPlaceholder)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = childrenData[indexPath.row]
        guard let id = data.id else { return }
        delegate?.openChat(id,data.image,data.name)
        navigationController?.popViewController(animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


struct ChildrenListModel: Codable {
    let status: Int?
    let message: String?
    let data: ChildrenListData?
}

// MARK: - DataClass
struct ChildrenListData: Codable {
    let from, perPage: Int?
    let data: [ChildrenList]?
    let firstPageURL, nextPageURL: String?
    let currentPage: Int?
    let path: String?
    let prevPageURL: String?
    let to: Int?

    enum CodingKeys: String, CodingKey {
        case from
        case perPage = "per_page"
        case data
        case firstPageURL = "first_page_url"
        case nextPageURL = "next_page_url"
        case currentPage = "current_page"
        case path
        case prevPageURL = "prev_page_url"
        case to
    }
}

// MARK: - Datum
struct ChildrenList: Codable {
    let email: String?
    let id: Int?
    let userStatus, name: String?
    let roleID: Int?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case email, id
        case userStatus = "user_status"
        case name
        case roleID = "role_id"
        case image
    }
}
