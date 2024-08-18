import Kingfisher

protocol OpenChatVCProtocol: AnyObject {
    func openChat(_ studentID: Int, _ userProfileImage: String?, _ userName: String?, _ threadID: Int)
}

class TeacherUsersListVC: UIViewController, SelectClasses {

    private var allChildrenData = [ChildrenList]()
    private var childrenData = [ChildrenList]()
    private var filtteredData = [ChildrenList]()

    weak var delegate: OpenChatVCProtocol?
    var isFiltered = false
    var isComing = String()

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var searchTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentList()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func filter_tapped(_ sender: Any) {
        isFiltered = true
        let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectClassesVC") as! SelectClassesVC
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSearch(_ sender: Any) {
        // Implement search button action if needed
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

    struct GeneralModel: Codable {}

    func getStudentList(classID: Int = 0) {
        showIndicator()
        ApiManager.shared.Request(type: ChildrenListModel.self,
                                  methodType: .Get,
                                  url: baseUrl + "all_children",
                                  parameter: [:]) { error, resp, msgString, statusCode in

            guard error == nil,
                  let userlist = resp?.data?.data,
                  statusCode == 200 else {
                self.stopIndicator()
                return
            }

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
        if isFiltered && !filtteredData.isEmpty {
            return filtteredData.count
        } else {
            return childrenData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
        let data: ChildrenList

        if isFiltered && !filtteredData.isEmpty {
            data = filtteredData[indexPath.row]
        } else {
            data = childrenData[indexPath.row]
        }

        cell.lblName.text = data.name
        cell.img_profile.contentMode = .scaleAspectFill
//        if let userProfileUrl = data.image {
//            cell.img_profile.sd_setImage(with: URL(string: imageBaseUrl + userProfileUrl), placeholderImage: .announcementPlaceholder)
//        }
        if let userProfileUrlString = data.image,
           let userProfileUrl = URL(string: imageBaseUrl + userProfileUrlString) {
            cell.img_profile.kf.setImage(with: userProfileUrl)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data: ChildrenList

        if isFiltered && !filtteredData.isEmpty {
            data = filtteredData[indexPath.row]
        } else {
            data = childrenData[indexPath.row]
        }

        guard let id = data.id else { return }
        delegate?.openChat(id, data.image, data.name, 0)
        navigationController?.popViewController(animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension TeacherUsersListVC {
    func selectedClasses(selectedEvaluationIDs: [Int]) {
        filtteredData.removeAll()  // Clear previous filtered data
        childrenData.forEach { data in
            data.classID?.forEach { id in
                if selectedEvaluationIDs.contains(id) {
                    filtteredData.append(data)
                    return
                }
            }
        }
        filtteredData = filtteredData.uniqued()
        tblList.reloadData()
        isFiltered = filtteredData.count > 0
        print("Total selected classes: \(filtteredData.count)")
    }
}


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

import Foundation

// MARK: - EvaluatiomSkillAlbumModel
struct ChildrenListModel: Codable {
    let status: Int?
    let message: String?
    let data: ChildrenListData?
}

// MARK: - DataClass
struct ChildrenListData: Codable {
    let currentPage: Int?
    let data: [ChildrenList]?
    let firstPageURL: String?
    let from: Int?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to
    }
}

// MARK: - Datum
struct ChildrenList: Codable, Hashable {
    let id: Int?
    let name: String?
    let email: String?
    let roleID: Int?
    let image, userStatus: String?
    let classID: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case roleID = "role_id"
        case image
        case userStatus = "user_status"
        case classID = "classId"
    }
}
