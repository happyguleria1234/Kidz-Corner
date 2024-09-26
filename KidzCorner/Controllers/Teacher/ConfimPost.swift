import UIKit
import DropDown
import MobileCoreServices

class ConfirmPost: UIViewController, CollageViewDelegate {
    
    @IBOutlet weak var viewStudent: UIView!
    @IBOutlet weak var viewAlbum: UIView!
    var studentId: String?
    var selectedImages: [UIImage]?
    var imageDataArray: [Data]?
    var imageDataArr: [Data] = []
    var selectedType = Int()
    var categoriesData: CategoryModel?
    var classAttendance: ClassAttendanceModel?
    var allClassesData: [ClassName]? {
        didSet {
            let selectedClasses = allClassesData?.filter({ $0.isSelected == true }).map({ $0.name ?? "" }).joined(separator: ", ")
            selectedStudentID2 = allClassesData?.filter({ $0.isSelected == true }).map({ $0.id ?? 0 }) ?? []
            self.tfClass.text = selectedClasses
        }
    }
    var classIDArray = [Int]()
    private var isPushingViewController = false
    var currentDate: String = Date().shortDate
    var childreData: ChildrenModelData?
    @IBOutlet weak var typeCollection: UICollectionView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tf_studentName: UITextField!
    var selectedAlbum: Int = -1
    var selectedDomain: Int = -1
    var selectedSkill: Int = -1
    var selectedStudentID: Int = -1
    var selectedStudentID2 = [Int]()
    var selectedStudents = [Int]()
    var selectedStudentsName = [String]()
    var albumArr: [String]?
    var domainArr: [String]?
    var skillArr: [String]?
    var classId: Int?
    var classIds = String()
    let albumsDropdown = DropDown()
    let domainDropdown = DropDown()
    let skillDropdown = DropDown()
    let studentName = DropDown()
    var albumId = 0
    var domainId = 0
    weak var delegate: afterAdding?
    var layoutDirection: CollageViewLayoutDirection = .vertical
    
    @IBOutlet weak var imgPostt: UIImageView!
    @IBOutlet weak var collageImage: CollageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var textTitle: UITextField!
    
    @IBOutlet weak var textDescription: UITextView!
    
    @IBOutlet weak var textAlbum: UITextField!
    @IBOutlet weak var textDomain: UITextField!
    @IBOutlet weak var textSkill: UITextField!
    
    @IBOutlet weak var switchDashboard: UISwitch!
    @IBOutlet weak var switchActivity: UISwitch!
    @IBOutlet weak var tfClass: UITextField!
    @IBOutlet weak var fileNameLabel: UILabel!
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var activityBtn: UIButton!
    @IBOutlet weak var portfolioBtn: UIButton!
    @IBOutlet weak var bothBtn: UIButton!
    
    
    
    
    var typeArr = ["Activity","Portfolio","Both"]
    var isPostImages = true
    var pdfUrl: URL?
    var selectedTypes = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionImages.register(UINib(nibName: "DashboardCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DashboardCollectionCell")
//        self.typeCollection.register(UINib(nibName: "TypeCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TypeCell")
//        getStudents()
        getCategories()
        initialSetup()
        activitybtnClick()
        selectedTypes = 1
        getSchoolClasses()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initialSetup() {
        if selectedType == 1 {
            imageViewHeight.constant = 280
            collectionImages.isHidden = true
            collageImage.isHidden = false
        } else {
            imageViewHeight.constant = 350
            collectionImages.isHidden = false
            collageImage.isHidden = true
            
        }
        labelName.text = UserDefaults.standard.string(forKey: myName)
        labelDate.text = getCurrentDateString(format: "EEEE, MMM d, yyyy")
        imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(UserDefaults.standard.string(forKey: myImage) ?? "")), placeholderImage: .placeholderImage)

        collectionImages.delegate    = self
        collectionImages.dataSource  = self
        collageImage.delegate    = self
        collageImage.dataSource  = self
        collageImage.reload()
        if isPostImages {
            collectionImages.superview?.isHidden = false
            fileNameLabel.superview?.isHidden = true
        } else {
            collectionImages.superview?.isHidden = true
            fileNameLabel.superview?.isHidden = false
            self.fileNameLabel.text = pdfUrl?.lastPathComponent ?? "-"
        }
        collectionImages.reloadData()
        
        selectedImages?.forEach({ data in
            do {
                let imgData = try! data.jpegData(compressionQuality: 0.1)
                imageDataArr.append(imgData!)
            }
            catch {
                print("Error converting image to data")
            }
        })
        
    }
    
    func getCurrentDateString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format // Use the format passed as a parameter
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    
    @IBAction func btnStudent(_ sender: Any) {
        if classIds.isEmpty {
            AlertManager.shared.showAlert(title: "Select Classes", message: "Please select class then you were able to get student list", viewController: self)
        } else {
            guard !isPushingViewController else { return } // Prevent multiple pushes
            isPushingViewController = true
            
            getStudents(classIDStr: self.classIds) {
                var dataa = [DataArray]()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrandVC") as! BrandVC
                self.childreData?.data?.data?.forEach({ data in
                    let albumData = DataArray(value: data.name ?? "", isSelect: false, id: data.id ?? 0, userImage: data.image ?? "")
                    dataa.append(albumData)
                })
                vc.callBack = { selectedData in
                    self.tf_studentName.text = selectedData.compactMap({ $0.value }).joined(separator: ",")
                    self.selectedStudents = selectedData.compactMap({ $0.id })
                    self.selectedStudentsName = selectedData.compactMap({ $0.value })
                }
                vc.dataArray = dataa
                vc.selectedTitle = "Student"
                vc.modalPresentationStyle = .overCurrentContext
                
                // Push the view controller
                self.navigationController?.pushViewController(vc, animated: true)
                
                // Reset the flag after the push is complete
                self.isPushingViewController = false
            }
        }
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func albumFunc(_ sender: Any) {
        var dataa = [DataArray]()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrandVC") as! BrandVC
        self.categoriesData?.data?.album?.forEach({ data in
            if let albumID = data.classId, classIDArray.contains(albumID) {
                // Add to dataArray if the album's id is in classIDArray
                let albumData = DataArray(value: data.name ?? "", isSelect: false, id: data.id ?? 0, userImage: "")
                dataa.append(albumData)
            }
        })
        vc.callBack = { selectedData in
            self.textAlbum.text = selectedData.first?.value ?? ""
            self.albumId = selectedData.first?.id ?? 0
        }
        vc.dataArray = dataa
        vc.selectedTitle = "Album"
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func domainFunc(_ sender: Any) {
//        domainDropdown.show()
        var dataa = [DataArray]()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrandVC") as! BrandVC
        self.categoriesData?.data?.domain?.forEach({ data in
            let albumData = DataArray(value: data.name ?? "", isSelect: false,id: data.id ?? 0, userImage: "")
            dataa.append(albumData)
        })
        vc.callBack = { selectedData in
            self.textDomain.text = selectedData.first?.value ?? ""
            self.domainId = selectedData.first?.id ?? 0
        }
        vc.dataArray = dataa
        vc.selectedTitle = "Domain"
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true)
    }
    
    @IBAction func skillFunc(_ sender: Any) {
        skillDropdown.show()
    }
    
    @IBAction func didTapClass(_ sender: Any) {
        var dataa = [DataArray]()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrandVC") as! BrandVC
        self.allClassesData?.forEach({ data in
            let albumData = DataArray(value: data.name ?? "", isSelect: false,id: data.id ?? 0, userImage: "")
            dataa.append(albumData)
        })
        vc.callBack = { [self] selectedData in
            self.classIDArray = selectedData.compactMap { $0.isSelect ? $0.id : nil }
            self.tfClass.text = selectedData.compactMap({ $0.value }).joined(separator: ",")
            let selectedIds = selectedData.compactMap { $0.isSelect ? $0.id : nil }
            self.classIds = selectedIds.map { String($0) }.joined(separator: ",")
        }
        vc.dataArray = dataa
        vc.selectedTitle = "Classes"
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func activityBtn(_ sender: Any) {
        activitybtnClick()
    }
    
    @IBAction func portfolioBtn(_ sender: Any) {
        portfoliobtnClick()
    }
    
    @IBAction func bothBtn(_ sender: Any) {
        bothbtnClick()
    }
    
    func activitybtnClick(){
        self.bothBtn.backgroundColor = #colorLiteral(red: 0, green: 0.537728548, blue: 0.5460962057, alpha: 1)
        self.bothBtn.setTitleColor(.white, for: .normal)
        self.portfolioBtn.backgroundColor = #colorLiteral(red: 0, green: 0.537728548, blue: 0.5460962057, alpha: 1)
        self.portfolioBtn.setTitleColor(.white, for: .normal)
        self.activityBtn.backgroundColor = #colorLiteral(red: 0.966850698, green: 0.97679919, blue: 0.9938296676, alpha: 1)
        self.activityBtn.setTitleColor(#colorLiteral(red: 0, green: 0.537728548, blue: 0.5460962057, alpha: 1), for: .normal)
        selectedTypes = 1
        viewStudent.isHidden = true
        viewAlbum.isHidden = true
    }
    
    func portfoliobtnClick(){
        self.bothBtn.backgroundColor = #colorLiteral(red: 0, green: 0.537728548, blue: 0.5460962057, alpha: 1)
        self.bothBtn.setTitleColor(.white, for: .normal)
        self.activityBtn.backgroundColor = #colorLiteral(red: 0, green: 0.537728548, blue: 0.5460962057, alpha: 1)
        self.activityBtn.setTitleColor(.white, for: .normal)
        self.portfolioBtn.backgroundColor = #colorLiteral(red: 0.966850698, green: 0.97679919, blue: 0.9938296676, alpha: 1)
        self.portfolioBtn.setTitleColor(#colorLiteral(red: 0, green: 0.537728548, blue: 0.5460962057, alpha: 1), for: .normal)
        selectedTypes = 2
        viewStudent.isHidden = false
        viewAlbum.isHidden = false
    }
    
    func bothbtnClick(){
        self.activityBtn.backgroundColor = #colorLiteral(red: 0, green: 0.537728548, blue: 0.5460962057, alpha: 1)
        self.activityBtn.setTitleColor(.white, for: .normal)
        self.portfolioBtn.backgroundColor = #colorLiteral(red: 0, green: 0.537728548, blue: 0.5460962057, alpha: 1)
        self.portfolioBtn.setTitleColor(.white, for: .normal)
        self.bothBtn.backgroundColor = #colorLiteral(red: 0.966850698, green: 0.97679919, blue: 0.9938296676, alpha: 1)
        self.bothBtn.setTitleColor(#colorLiteral(red: 0, green: 0.537728548, blue: 0.5460962057, alpha: 1), for: .normal)
        selectedTypes = 3
        viewStudent.isHidden = false
        viewAlbum.isHidden = false
    }
    
    @IBAction func shareFunc(_ sender: Any) {
        if selectedType == 1 {
            if textTitle.text == "" {
                Toast.toast(message: "Please enter a title", controller: self)
            } else if textDescription.text == "" {
                Toast.toast(message: "Enter a caption to continue", controller: self)
            } else if domainId == 0 {
                Toast.toast(message: "Please select a Domain", controller: self)
            } else if classIds.isEmpty {
                Toast.toast(message: "Please select a class", controller: self)
            } else {
                // Proceed with the appropriate API call
                if isPostImages {
                    addPortfolioApi(albumId: albumId, domainId: domainId, classIds: classIds)
                } else {
                    addPortfolioApiNew(albumId: albumId, domainId: domainId, classIds: classIds)
                }
            }
        } else {
            if selectedTypes == 1 {
                if textTitle.text == "" {
                    Toast.toast(message: "Please enter a title", controller: self)
                } else if textDescription.text == "" {
                    Toast.toast(message: "Enter a caption to continue", controller: self)
                } else if domainId == 0 {
                    Toast.toast(message: "Please select a Domain", controller: self)
                } else if classIds.isEmpty {
                    Toast.toast(message: "Please select a class", controller: self)
                } else {
                    // Proceed with the appropriate API call
                    if isPostImages {
                        addPortfolioApi(albumId: albumId, domainId: domainId, classIds: classIds)
                    } else {
                        addPortfolioApiNew(albumId: albumId, domainId: domainId, classIds: classIds)
                    }
                }
            } else {
                
                if textTitle.text == "" {
                    Toast.toast(message: "Please enter a title", controller: self)
                } else if textDescription.text == "" {
                    Toast.toast(message: "Enter a caption to continue", controller: self)
                } else if classIds.isEmpty {
                    Toast.toast(message: "Please select a class", controller: self)
                } else if albumId == 0{
                    Toast.toast(message: "Please select a Album", controller: self)
                } else if domainId == 0 {
                    Toast.toast(message: "Please select a Domain", controller: self)
                }  else {
                    // Proceed with the appropriate API call
                    if isPostImages {
                        addPortfolioApi(albumId: albumId, domainId: domainId, classIds: classIds)
                    } else {
                        addPortfolioApiNew(albumId: albumId, domainId: domainId, classIds: classIds)
                    }
                }
            }
        }
    }
    
    @IBAction func dashboardSwitched(_ sender: Any) {
        print(sender)
    }
    
    @IBAction func activitySwitched(_ sender: Any) {
        print(sender)
    }
    
    func getStudents(classIDStr: String = "",onSuccess: @escaping(()->())) {
        ApiManager.shared.Request(type: ChildrenModelData.self, methodType: .Get, url: "https://kidzcorner.live/api/all_children", parameter: ["classId": classIDStr]) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async { [self] in
                    self.childreData = myObject
                    self.studentName.dataSource = myObject?.data?.data?.compactMap({ $0.name}) ?? []
                    onSuccess()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func getAttendance(classId: Int,date: String) {
        var params = [String: Any]()
        params = ["date": date,
                  "class_id": String(classId)]
        
        ApiManager.shared.Request(type: ClassAttendanceModel.self, methodType: .Get, url: baseUrl+apiClassAttendance, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async { [self] in
                    self.classAttendance = myObject
//                    self.studentName.dataSource = self.classAttendance?.data?.compactMap({ $0.name }) ?? []
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    func creatingImageData(imageArray: [UIImage]) -> [Data] {
        var dataArr: [Data]?
        for image in imageArray {
                let data = image.pngData()
                dataArr?.append(data ?? Data())
        }
       return dataArr ?? [Data]()
    }
    
    func getCategories() {
        
        let params = [String: String]()
       
        ApiManager.shared.Request(type: CategoryModel.self, methodType: .Get, url: baseUrl+apiActivityCategories, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                self.categoriesData = myObject
                                
                DispatchQueue.main.async {
                    self.setupDropDown()
                }
            }
            else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
        
    }
    func dropDownDataDelegate() {
        albumArr = self.categoriesData?.data?.album?.compactMap {
            $0.name
        }
        albumsDropdown.dataSource = albumArr ?? []
    }
    
    func setupDropDown() {
        
        dropDownDataDelegate()
        DropDown.setupDefaultAppearance()
        albumsDropdown.dismissMode = .onTap
        domainDropdown.dismissMode = .onTap
        skillDropdown.dismissMode = .onTap
        studentName.dismissMode = .onTap

        albumsDropdown.anchorView = textAlbum
        domainDropdown.anchorView = textDomain
        skillDropdown.anchorView = textSkill
        studentName.anchorView = tf_studentName

        albumsDropdown.bottomOffset = CGPoint(x: 0, y: textAlbum.bounds.height)
        domainDropdown.bottomOffset = CGPoint(x: 0, y: textDomain.bounds.height)
        skillDropdown.topOffset = CGPoint(x: 0, y: textSkill.bounds.height)
        studentName.topOffset = CGPoint(x: 0, y: tf_studentName.bounds.height)

        //ageDropdown.dataSource = ["Poupons", "Bambins", "Prescolaires", "Scolaires"]
        
        self.setupDomains()
        
        albumsDropdown.selectionAction = { [weak self] (index, item) in
            self?.textAlbum.text = item
            self?.selectedAlbum = index
        }
        
        studentName.multiSelectionAction = { [weak self] (index, items) in
            guard let self = self else { return }
            print("Selected index: \(index)")
            print("Selected items: \(items)")
            self.tf_studentName.text = selectedStudentsName.joined(separator: ",")
            self.selectedStudentsName = items
            self.selectedStudents = index
            
        }
        
        domainDropdown.selectionAction = { [weak self] (index, item) in
            self?.textDomain.text = item
            self?.selectedDomain = index
            self?.setupSkills(domainId: self?.selectedDomain ?? -1)
            self?.textSkill.text = ""
            self?.selectedSkill = -1
        }
        
        skillDropdown.selectionAction = { [weak self] (index, item) in
            self?.textSkill.text = item
            self?.selectedSkill = index
        }
    }
    
    func setupDomains() {
        let domainArr = self.categoriesData?.data?.domain?.compactMap {
            $0.name
        }
        domainDropdown.dataSource = domainArr ?? []
    }
    func setupSkills(domainId: Int) {
         skillArr = self.categoriesData?.data?.domain?[domainId].skills?.compactMap {
            $0.name
        }
        skillDropdown.dataSource = skillArr ?? []
    }
    
    func addPortfolioApi(albumId: Int, domainId: Int, classIds: String) { //, skillId: Int) {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        var postDescription: String = ""
        if textDescription.text.trimmingCharacters(in: .whitespacesAndNewlines) == "Write your caption here" {
            postDescription = ""
        }
        else {
            postDescription = textDescription.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var params = [String: Any]()
        
        if selectedStudentID == -1 {
            params = [
                "domain_id" : domainId,
                //                  "skill_id" : skillId,
                "title": self.textTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "post_content" : postDescription,
                "post_date" : Date().shortDate,
                "is_dashboard" : "1",
                "class_id": classIds,
                "is_collage":selectedType == 0 ? 0 : 1,
                "portfolio_type":selectedTypes,
                "studentId": selectedStudents.map({String($0)}).joined(separator: ",")
            ]
        } else {
            params = [
                "domain_id" : domainId,
                "title": self.textTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "post_content" : postDescription,
                "post_date" : Date().shortDate,
                "is_dashboard" : "1",
                "class_id": classIds,
                "portfolio_type":selectedTypes,
                "studentId": selectedStudents,
                "is_collage":selectedType == 0 ? 0 : 1,
                "studentId": selectedStudents.map({String($0)}).joined(separator: ",")
            ]
        }
        print(params)
        if selectedTypes != 1 {
               params["age_group_id"] = albumId
           }
        if selectedType == 1 {
            let screenshot = captureScreenshot(of: collageImage)
            let imageView = UIImageView(image: screenshot)
            ApiManager.shared.requestWithImage(type: BaseModel.self, url: baseUrl+apiPostPortfolio, parameter: params, imageNames: ["image1"], imageKeyName: "images[]", images: imageDataArr) { error, myObject, messageStr, statusCode in
                debugPrint(error)
                if statusCode == 200 {
                    print("Successfully uploaded")
                    print(myObject)
                    DispatchQueue.main.async {
                        self.textTitle.text = ""
                        self.textDescription.text = ""
                        self.selectedAlbum = -1
                        self.selectedDomain = -1
                        self.selectedSkill = -1
                        self.textAlbum.text = ""
                        self.textDomain.text = ""
                        self.textSkill.text = ""
                        self.navigationController?.popViewController(animated: true, completion: {
                            self.delegate?.afterAdding()
                        })
                    }
                } else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        } else {
            ApiManager.shared.requestWithImage(type: BaseModel.self, url: baseUrl+apiPostPortfolio, parameter: params, imageNames: ["image1"], imageKeyName: "images[]", images: imageDataArr) { error, myObject, messageStr, statusCode in
                debugPrint(error)
                if statusCode == 200 {
                    print("Successfully uploaded")
                    print(myObject)
                    DispatchQueue.main.async {
                        self.textTitle.text = ""
                        self.textDescription.text = ""
                        self.selectedAlbum = -1
                        self.selectedDomain = -1
                        self.selectedSkill = -1
                        self.textAlbum.text = ""
                        self.textDomain.text = ""
                        self.textSkill.text = ""
                        self.navigationController?.popViewController(animated: true, completion: {
                            self.delegate?.afterAdding()
                        })
                    }
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func getSchoolClasses() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        ApiManager.shared.Request(type: AllClassesModel.self, methodType: .Get, url: baseUrl + apiGetAllClasses, parameter: [:]) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.allClassesData = myObject?.data
//                    self.classButtonSetup()
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func classButtonSetup() {
        if let allClassesData, allClassesData.count != 0 {
            if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClassSelectionVC") as? ClassSelectionVC {
                nextVC.modalTransitionStyle = .crossDissolve
                nextVC.modalPresentationStyle = .overFullScreen
                nextVC.allClassesData = self.allClassesData
                nextVC.delegate = self
                self.navigationController?.present(nextVC, animated: true)
            }
        } else {
            getSchoolClasses()
        }
    }
    
    deinit {
        print("Deinit Here =========>")
    }
}

extension ConfirmPost: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case typeCollection:
            return typeArr.count
        case collectionImages:
            pageControl.numberOfPages = selectedImages?.count ?? 0
            return selectedImages?.count ?? 0
        default:
            print("")
        }
       return selectedImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == typeCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCell", for: indexPath) as! TypeCell
            cell.lblType.text = typeArr[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionCell", for: indexPath) as! DashboardCollectionCell
            cell.imagePost.image = selectedImages?[indexPath.row]
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionImages {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2
            
            pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case typeCollection:
            let numberOfCellsInRow: CGFloat = 3
            let cellSpacing: CGFloat = 10 // Adjust based on your spacing between cells
            let totalSpacing = (numberOfCellsInRow - 1) * cellSpacing
            let cellWidth = (collectionView.bounds.width - totalSpacing) / numberOfCellsInRow
            return CGSize(width: cellWidth, height: cellWidth) // Assuming square cells, adjust height as needed
        case collectionImages:
            return CGSize(width: collectionImages.bounds.width, height: collectionImages.bounds.height)
        default:
            return CGSize.zero
        }
    }

}

extension ConfirmPost: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor(named: "statsColor")
            }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
                textView.text = "Write your caption here"
                textView.textColor = UIColor.lightGray
            }
    }
}

// MARK: - Extension for class selection delegate
extension ConfirmPost: ClassSelectionVCDelegate {
    func updatedData(data: [ClassName]) {
        self.allClassesData = data
        selectedStudentID2 = data.filter({ $0.isSelected == true }).map({ $0.id ?? 0 })
//        self.getAttendance(classId: selectedStudentID2.first ?? 0, date: self.currentDate)
    }
}

protocol afterAdding: NSObjectProtocol, AnyObject {
    func afterAdding()
}

extension ConfirmPost {
    func addPortfolioApiNew(albumId: Int, domainId: Int, classIds: String){ //, skillId: Int) {
        
        
        var postDescription: String = ""
        
        
        
        if textDescription.text.trimmingCharacters(in: .whitespacesAndNewlines) == "Write your caption here" {
            postDescription = ""
        }
        else {
            postDescription = textDescription.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var params = [String: Any]()
        
        if selectedStudentID == -1 {
            params = [
                //  "student_id" : "26",
//                "age_group_id" : albumId,
                "domain_id" : domainId,
                //                  "skill_id" : skillId,
                "title": self.textTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "post_content" : postDescription,
                "post_date" : Date().shortDate,
                "is_dashboard" : "1",
                "class_id": classIds,
                "is_collage":selectedType == 0 ? 0 : 1,
                "portfolio_type":selectedType,
                "studentId": selectedStudents.map({String($0)}).joined(separator: ",")
            ]
        } else {
            
            params = [
//                "age_group_id" : albumId,
                "domain_id" : domainId,
                //                  "skill_id" : skillId,
                "title": self.textTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "post_content" : postDescription,
                "post_date" : Date().shortDate,
                "is_dashboard" : "1",
                "class_id": classIds,
                "user_id": selectedStudentID,
                "is_collage":selectedType == 0 ? 0 : 1,
                "portfolio_type":selectedType,
                "studentId": selectedStudents.map({String($0)}).joined(separator: ",")
            ]
        }
//        is_collage
        
        print(params)
        if selectedTypes != 1 {
               params["age_group_id"] = albumId
           }
        if let pdfUrl, let fileData = convertFileToData(fileURL: pdfUrl) {
            DispatchQueue.main.async {
                startAnimating(self.view)
            }
            let media = [Media.init(key: "pdf_file", fileName: ".pdf", data:  fileData, mimeType: getMimeType(for: pdfUrl) ?? "", fileExt: pdfUrl.pathExtension)]
          
         //   print("ImageArrCount")
         //   print(imageDataArray?.count)
            
            ApiManager.shared.requestWithImageNew(type: BaseModel.self, url: baseUrl+apiPostPortfolio, parameter: params, media: media) { error, myObject, messageStr, statusCode in
                debugPrint(error)
                if statusCode == 200 {
                    print("Successfully uploaded")
                    print(myObject)
                    DispatchQueue.main.async {
                        self.textTitle.text = ""
                        self.textDescription.text = ""
                        self.selectedAlbum = -1
                        self.selectedDomain = -1
                        self.selectedSkill = -1
                        self.textAlbum.text = ""
                        self.textDomain.text = ""
                        self.textSkill.text = ""
                        self.navigationController?.popViewController(animated: true, completion: {
                            self.delegate?.afterAdding()
                        })
                        
                  //      self.tabBarController?.selectedIndex = 0
                    }

                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    
    func getMimeType(for fileURL: URL) -> String? {
        let fileExtension = fileURL.pathExtension

        let fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)?.takeRetainedValue()
        let mimeType = UTTypeCopyPreferredTagWithClass(fileUTI!, kUTTagClassMIMEType)?.takeRetainedValue() as String?

        return mimeType
    }
    
    func convertFileToData(fileURL: URL) -> Data? {
        do {
            let fileData = try Data(contentsOf: fileURL)
            return fileData
        } catch {
            print("Error converting file to data: \(error.localizedDescription)")
            return nil
        }
    }
}

extension ConfirmPost: CollageViewDataSource {
    
    func collageView(_ collageView: CollageView, configure itemView: CollageItemView, at index: Int) {
        guard let image = selectedImages?[index] else { return }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill  // Ensures the image covers the entire area
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: itemView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: itemView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: itemView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: itemView.bottomAnchor)
        ])
        
        itemView.layer.borderWidth = 1
    }
    
    
    func collageViewNumberOfTotalItem(_ collageView: CollageView) -> Int {
        return selectedImages?.count ?? 0
    }
    func collageViewNumberOfRowOrColoumn(_ collageView: CollageView) -> Int {
        let totalImages = selectedImages?.count ?? 0
        let targetRowCountOrColumnCount = 3
        
        let rowCountOrColumnCount = (totalImages + targetRowCountOrColumnCount - 1) / targetRowCountOrColumnCount
        if rowCountOrColumnCount > 1 && selectedImages?.count == 5 {
            return 3
        } else if rowCountOrColumnCount == 1 && selectedImages?.count == 3{
            return 2
        } else {
            return rowCountOrColumnCount > 0 ? rowCountOrColumnCount : 1 // Ensure at least 1 row/column
        }
    }
    
    func collageViewLayoutDirection(_ collageView: CollageView) -> CollageViewLayoutDirection {
        return layoutDirection
    }
    
    private func addBlackViewAndLabel(to view: UIView) {
        let blackView = UIView()
        blackView.backgroundColor = .black
        blackView.alpha = 0.4
        blackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackView)
        
        NSLayoutConstraint.activate([
            blackView.topAnchor.constraint(equalTo: view.topAnchor),
            blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "+\(selectedImages?.count ?? 0)"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

func captureScreenshot(of view: UIView) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
    let screenshot = renderer.image { context in
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    }
    return screenshot
}

func convertImageToData(image: UIImage) -> Data? {
    // Convert UIImage to Data
    if let imageData = image.pngData() {
        return imageData
    }
    return nil
}

// Extension to set width of images within each column in CollageView
extension CollageView {
    func setImageColumnWidth(_ columnWidth: CGFloat) {
        // Calculate the number of images per column
        let imagesPerColumn = (self.subviews.count + 2) / 3 // Adding 2 for rounding purposes
        // Iterate through image views in the collage view and set width
        for (index, imageView) in self.subviews.enumerated() {
            if let imageView = imageView as? UIImageView {
                let columnIndex = index / imagesPerColumn
                imageView.widthAnchor.constraint(equalToConstant: columnWidth).isActive = true
            }
        }
    }
}

class TypeCell: UICollectionViewCell {
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var mainView: CustomView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
