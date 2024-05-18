import UIKit
import DropDown
import MobileCoreServices

class ConfirmPost: UIViewController, CollageViewDelegate {
    
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
    
    var currentDate: String = Date().shortDate
    
    @IBOutlet weak var tf_studentName: UITextField!
    var selectedAlbum: Int = -1
    var selectedDomain: Int = -1
    var selectedSkill: Int = -1
    var selectedStudentID: Int = -1
    var selectedStudentID2 = [Int]()

    var albumArr: [String]?
    var domainArr: [String]?
    var skillArr: [String]?
    var classId: Int?

    let albumsDropdown = DropDown()
    let domainDropdown = DropDown()
    let skillDropdown = DropDown()
    let studentName = DropDown()

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
    
    var isPostImages = true
    var pdfUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionImages.register(UINib(nibName: "DashboardCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DashboardCollectionCell")
        getCategories()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func initialSetup() {
        if selectedType == 1 {
            collectionImages.isHidden = true
            collageImage.isHidden = false
        } else {
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
        // Step 1: Create a Date object
        let currentDate = Date()
        
        // Step 2: Create and configure a DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format // Use the format passed as a parameter
        
        // Step 3: Format the date
        let dateString = dateFormatter.string(from: currentDate)
        
        // Return the formatted date string
        return dateString
    }
    
    @IBAction func btnStudent(_ sender: Any) {
        studentName.show()
    }
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func albumFunc(_ sender: Any) {
        albumsDropdown.show()
    }
    
    @IBAction func domainFunc(_ sender: Any) {
        domainDropdown.show()
    }
    
    @IBAction func skillFunc(_ sender: Any) {
        skillDropdown.show()
    }
    
    @IBAction func didTapClass(_ sender: Any) {
        self.classButtonSetup()
    }
    
    @IBAction func shareFunc(_ sender: Any) {
        
        printt("Sharing Activity Post")
        
        let classIds = allClassesData?.filter({ $0.isSelected == true }).map({ $0.id ?? 0}).map({String($0)}).joined(separator: ",") ?? ""
        
        if (selectedAlbum != -1),(selectedDomain != -1), classIds.isEmpty != true { // ,(selectedSkill != -1)
            let albumId = self.categoriesData?.data?.album?[selectedAlbum].id ?? 1
            let domainId = self.categoriesData?.data?.domain?[selectedDomain].id ?? 1
//             let skillId = self.categoriesData?.data?.domain?[selectedDomain].skills?[selectedSkill].id ?? 1
//            print(ageId)
//            print(domainId)
//            print(skillId)

//       Toast.toast(message: "This feature is being worked on", controller: self)

//            if let images = selectedImages {
//                imageDataArray = creatingImageData(imageArray: images)
//            }

            if textTitle.text == "" {
                Toast.toast(message: "Please enter a title", controller: self)
            }
            else {
                if textDescription.text == "Write your caption here" {
                    Toast.toast(message: "Enter a caption to continue", controller: self)
                }
                else {
                    if isPostImages {
                        addPortfolioApi(albumId: albumId, domainId: domainId, classIds: classIds)// skillId: skillId)
                    } else {
                        addPortfolioApiNew(albumId: albumId, domainId: domainId, classIds: classIds)
                    }
                }
            }
        }
        else {
            Toast.toast(message: "Please select class", controller: self)
        }
    }
    
    @IBAction func dashboardSwitched(_ sender: Any) {
        print(sender)
    }
    
    @IBAction func activitySwitched(_ sender: Any) {
        print(sender)
    }
    
    func getAttendance(classId: Int,date: String) {
        var params = [String: Any]()
        params = ["date": date,
                  "class_id": String(classId)]
        
        ApiManager.shared.Request(type: ClassAttendanceModel.self, methodType: .Get, url: baseUrl+apiClassAttendance, parameter: params) { error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async { [self] in
                    self.classAttendance = myObject
                    self.studentName.dataSource = self.classAttendance?.data?.compactMap({ $0.name }) ?? []
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
                
                print(myObject)
                
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
        
        studentName.selectionAction = { [weak self] (index, item) in
            self?.tf_studentName.text = item
            self?.classAttendance?.data?.forEach({ data in
                if item == data.name {
                    self?.selectedStudentID = data.id ?? 0
                }
            })
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
                //  "student_id" : "26",
                "age_group_id" : albumId,
                "domain_id" : domainId,
                //                  "skill_id" : skillId,
                "title": self.textTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "post_content" : postDescription,
                "post_date" : Date().shortDate,
                "is_dashboard" : "1",
                "class_id": classIds,
                "is_collage":selectedType == 0 ? 0 : 1
            ]
        } else {
            
            params = [
                //  "student_id" : "26",
                "age_group_id" : albumId,
                "domain_id" : domainId,
                //                  "skill_id" : skillId,
                "title": self.textTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "post_content" : postDescription,
                "post_date" : Date().shortDate,
                "is_dashboard" : "1",
                "class_id": classIds,
                "user_id": selectedStudentID,
                "is_collage":selectedType == 0 ? 0 : 1
            ]
        }
        print(params)
        
        if selectedType == 1 {
            let screenshot = captureScreenshot(of: collageImage)
            let imageView = UIImageView(image: screenshot)
            ApiManager.shared.requestWithImage(type: BaseModel.self, url: baseUrl+apiPostPortfolio, parameter: params, imageNames: ["image1"], imageKeyName: "images[]", images: [convertImageToData(image: imageView.image ?? UIImage()) ?? Data()]) { error, myObject, messageStr, statusCode in
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
                    
                    //                    }
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
                    self.classButtonSetup()
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
        pageControl.numberOfPages = selectedImages?.count ?? 0
        return selectedImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionCell", for: indexPath) as! DashboardCollectionCell
        
        cell.imagePost.image = selectedImages?[indexPath.row]
        return cell
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
        return CGSize(width: collectionImages.bounds.width, height: collectionImages.bounds.height)
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
        self.getAttendance(classId: selectedStudentID2.first ?? 0, date: self.currentDate)
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
                "age_group_id" : albumId,
                "domain_id" : domainId,
                //                  "skill_id" : skillId,
                "title": self.textTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "post_content" : postDescription,
                "post_date" : Date().shortDate,
                "is_dashboard" : "1",
                "class_id": classIds,
                "is_collage":selectedType == 0 ? 0 : 1
            ]
        } else {
            
            params = [
                //  "student_id" : "26",
                "age_group_id" : albumId,
                "domain_id" : domainId,
                //                  "skill_id" : skillId,
                "title": self.textTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "post_content" : postDescription,
                "post_date" : Date().shortDate,
                "is_dashboard" : "1",
                "class_id": classIds,
                "user_id": selectedStudentID,
                "is_collage":selectedType == 0 ? 0 : 1
            ]
        }
        
        
        print(params)
        
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
        itemView.image = selectedImages?[index]
        itemView.layer.borderWidth = 1
        if index == selectedImages?.count {
            addBlackViewAndLabel(to: itemView)
        }
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
    
//    func collageViewNumberOfRowOrColoumn(_ collageView: CollageView) -> Int {
//        let totalImages = selectedImages?.count ?? 0
//        let targetRowCountOrColumnCount = 3
//        
//        let rowCountOrColumnCount = (totalImages + targetRowCountOrColumnCount - 1) / targetRowCountOrColumnCount
//        if rowCountOrColumnCount > 1 && totalImages == 5 {
//            // Calculate width of each column
//            let columnWidth = collageView.bounds.width / CGFloat(targetRowCountOrColumnCount)
//            // Set content mode of image views in the collage view
//            collageView.setImageColumnWidth(columnWidth)
//            return 5
//        } else if rowCountOrColumnCount == 1 && totalImages == 3 {
//            return 2
//        } else {
//            return max(rowCountOrColumnCount, 1) // Ensure at least 1 row/column
//        }
//    }
    
    func collageViewLayoutDirection(_ collageView: CollageView) -> CollageViewLayoutDirection {
        return layoutDirection
    }
    
    private func addBlackViewAndLabel(to view:UIView) {
        
        let blackView = UIView()
        blackView.backgroundColor = .black
        blackView.alpha = 0.4
        view.addSubview(blackView)
        addConstraints(to: blackView, parentView: view)
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "+\(selectedImages?.count ?? 0)"
        view.addSubview(label)
        addConstraints(to: label, parentView: view)
    }
    
    private func addConstraints(to view:UIView, parentView:UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let horConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal,
                                               toItem: parentView, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal,
                                               toItem: parentView, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        let widConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal,
                                               toItem: parentView, attribute: .width,
                                               multiplier: 1, constant: 0.0)
        let heiConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal,
                                               toItem: parentView, attribute: .height,
                                               multiplier: 1, constant: 0.0)
        
        parentView.addConstraints([horConstraint, verConstraint, widConstraint, heiConstraint])
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
