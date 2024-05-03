import UIKit
import DropDown

class PostStudentActivity: UIViewController {
    
    var currentDate: String = ""
    
    var classId: String = ""
    var studentId: String = ""
    var selectedImages: [UIImage]?
    var imageDataArray: [Data]?
      
    var categoriesData: CategoryModel?
    
    var selectedAlbum: Int = -1
    var selectedDomain: Int = -1
    var selectedSkill: Int = -1
    
    var albumArr: [String]?
    var domainArr: [String]?
    var skillArr: [String]?
    
    let albumsDropdown = DropDown()
    let domainDropdown = DropDown()
    let skillDropdown = DropDown()
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var textTitle: UITextField!
    
    @IBOutlet weak var textDescription: UITextView!
    
    @IBOutlet weak var textAlbums: UITextField!
    @IBOutlet weak var textDomain: UITextField!
    @IBOutlet weak var textSkill: UITextField!
    
    @IBOutlet weak var switchDashboard: UISwitch!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollection()
        getCategories()
        
       // getParentsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func shareFunc(_ sender: Any) {
        
        printt("Sharing Activity Post")
       
        if (selectedAlbum != -1),(selectedDomain != -1),(selectedSkill != -1) {
            let albumId = self.categoriesData?.data?.album?[selectedAlbum].id ?? 1
            let domainId = self.categoriesData?.data?.domain?[selectedDomain].id ?? 1
            let skillId = self.categoriesData?.data?.domain?[selectedDomain].skills?[selectedSkill].id ?? 1

//            print(ageId)
//            print(domainId)
//            print(skillId)

     //       Toast.toast(message: "This feature is being worked on", controller: self)

//            if let images = selectedImages {
//          imageDataArray = creatingImageData(imageArray: images)
//            }
            
            
            if textTitle.text == "" {
                Toast.toast(message: "Please enter a title", controller: self)
            }
            else {
                if textDescription.text == "Write your caption here" {
                    Toast.toast(message: "Enter a caption to continue", controller: self)
                }
                else {
                    addPortfolioApi(albumId: albumId, domainId: domainId, skillId: skillId)
                }
            }
        }
        else {
            Toast.toast(message: "Please select a skill", controller: self)
        }
    }
    
    @IBAction func dashboardSwitched(_ sender: Any) {
        print(sender)
    }
    
    func setupViews() {
        DispatchQueue.main.async { [self] in
            
            defaultTextfields(tfs: [textTitle,textSkill,textDomain,textAlbums])
            
            labelName.text = UserDefaults.standard.string(forKey: myName)
            imageProfile.sd_setImage(with: URL(string: imageBaseUrl+(UserDefaults.standard.string(forKey: myImage) ?? "")), placeholderImage: .placeholderImage)
            
            labelDate.text = self.currentDate
            
            imageProfile.layer.cornerRadius = imageProfile.bounds.height/2.0
            collectionImages.layer.cornerRadius = 20
            
            textDescription.layer.borderColor = UIColor.lightGray.cgColor
            textDescription.layer.borderWidth = 0.5
            textDescription.layer.cornerRadius = 5
            textDescription.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            textDescription.delegate = self
            textDescription.text = "Write your caption here"
            textDescription.textColor = .lightGray
            
        }
    }
    
    func setupCollection() {
        collectionImages.register(UINib(nibName: "DashboardCollectionCell", bundle: nil), forCellWithReuseIdentifier:   "DashboardCollectionCell")
        collectionImages.delegate = self
        collectionImages.dataSource = self
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
        
        albumsDropdown.anchorView = textAlbums
        domainDropdown.anchorView = textDomain
        skillDropdown.anchorView = textSkill
        
        albumsDropdown.bottomOffset = CGPoint(x: 0, y: textAlbums.bounds.height)
        domainDropdown.bottomOffset = CGPoint(x: 0, y: textDomain.bounds.height)
        skillDropdown.topOffset = CGPoint(x: 0, y: textSkill.bounds.height)
        
        //ageDropdown.dataSource = ["Poupons", "Bambins", "Prescolaires", "Scolaires"]
        
        self.setupDomains()
        
        albumsDropdown.selectionAction = { [weak self] (index, item) in
            self?.textAlbums.text = item
            self?.selectedAlbum = index
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
    
    func addPortfolioApi(albumId: Int, domainId: Int, skillId: Int) {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        var postDescription: String = ""
        
        guard let textTitle = self.textTitle.text else {
            Toast.toast(message: "Please enter a title", controller: self)
            return
        }
        
        if textDescription.text.trimmingCharacters(in: .whitespacesAndNewlines) == "Write your caption here" {
            postDescription = ""
        }
        else {
            postDescription = textDescription.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        var sendToDashboard = "1"
        if !switchDashboard.isOn {
            sendToDashboard = "0"
        }
        var params = [String: Any]()
        params = [
                "user_id" : self.studentId,
                  "age_group_id" : albumId,
                  "domain_id" : domainId,
                  "skill_id" : skillId,
                "title": textTitle,
                  "post_content" : postDescription,
                "post_date" : self.currentDate,
                  "is_dashboard" : sendToDashboard,
                "class_id" : classId
                ]
        
        print(params)
        
        if imageDataArray != nil {
          
            print("ImageArrCount")
            print(imageDataArray?.count)
            
            ApiManager.shared.requestWithImage(type: BaseModel.self, url: baseUrl+apiPostPortfolio, parameter: params, imageNames: ["image1"], imageKeyName: "images[]", images: imageDataArray!) { error, myObject, messageStr, statusCode in
                if statusCode == 200 {
                    print("Successfully uploaded")
                    print(myObject)
                    DispatchQueue.main.async {
                        
                        self.textTitle.text = ""
                        self.textDescription.text = ""
                        self.selectedAlbum = -1
                        self.selectedDomain = -1
                        self.selectedSkill = -1
                        self.textAlbums.text = ""
                        self.textDomain.text = ""
                        self.textSkill.text = ""
                        
                        self.navigationController?.popToRootViewController(animated: true)
                        }
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
}

extension PostStudentActivity: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

extension PostStudentActivity: UITextViewDelegate {
    
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
