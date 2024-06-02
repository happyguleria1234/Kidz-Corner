import UIKit
import YPImagePicker
import MobileCoreServices

//var imageDataArr: [Data] = []

class Post: UIViewController, afterAdding {
    
    var selectType = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: commented on 18 july 2022 line #17
        // showPicker()
    }
    
    func setupViews() {
        
    }
    
    @IBAction func didTapPhotos(_ sender: Any) {
        selectType = 0
        showPicker()
    }
    
    @IBAction func didTapPdf(_ sender: Any) {
        presentDocumentPicker()
    }
    
    @IBAction func btnCollage(_ sender: UIButton) {
        selectType = 1
        showPicker()
    }
    
    
    @objc func showPicker() {
        
        self.tabBarController?.hidesBottomBarWhenPushed = true
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .photo
        config.showsPhotoFilters = false
        config.screens = [.photo,.library]
        config.video.libraryTimeLimit = 500.0
        config.showsCrop = .none
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.targetImageSize = YPImageSize.cappedTo(size: 512)
        if selectType == 1 {
            config.library.minNumberOfItems = 2
        } else {
            config.library.minNumberOfItems = 1
        }
        config.library.maxNumberOfItems = 9
        config.library.skipSelectionsGallery = true
        let picker = YPImagePicker(configuration: config)
        
        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                //print("Picker was canceled")
                picker.dismiss(animated: true, completion: {
                    // TODO: Commented on 18 july 53 line
                    //                    self.tabBarController?.selectedIndex = 0
                    //self.navigationController?.popViewController(animated: true)
                })
                return
            }
            _ = items.map { print("🧀 \($0)") }
            var imageArray: [UIImage] = []
            var imageDataArr: [Data] = []
            if items.count > 0{
                for (_,data) in items.enumerated(){
                    let firstItem = data
                    switch firstItem {
                    case .photo(let photo):
                        imageArray.append(photo.image)
                        do {
                            let imgData = try! photo.image.jpegData(compressionQuality: 0.1)
                            imageDataArr.append(imgData!)
                        }
                        catch {
                            print("Error converting image to data")
                        }
                    case .video(let _):
                        return
                    }
                }
                picker.dismiss(animated: true, completion: { [weak self] in
                    
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ConfirmPost") as! ConfirmPost
                    vc.imageDataArray = imageDataArr
                    vc.selectedImages = imageArray
                    vc.studentId = ""
                    vc.delegate = self
                    vc.isPostImages = true
                    vc.selectedType = self?.selectType ?? 0
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }
        }
        picker.definesPresentationContext = true
        picker.modalPresentationStyle = .overCurrentContext
        present(picker, animated: true, completion: nil)
    }
    
    func afterAdding() {
        self.tabBarController?.selectedIndex = 0
    }
    
}

extension Post: UIDocumentPickerDelegate {
    func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPost") as! ConfirmPost
        vc.pdfUrl = selectedFileURL
        vc.delegate = self
        vc.isPostImages = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
