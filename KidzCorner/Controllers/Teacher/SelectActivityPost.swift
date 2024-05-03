import UIKit
import YPImagePicker

class SelectActivityPost: UIViewController {
    
    var studentId: Int = 0
    var classId = 0
    var currentDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showPicker()
    }
    
    func setupViews() {
        
    }
    
    @objc func showPicker() {
        
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        
        config.shouldSaveNewPicturesToAlbum = false
       // config.video.compression = AVAssetExportPresetMediumQuality
        config.startOnScreen = .photo
        config.showsPhotoFilters = false
      //  config.showsFilters = false
        config.screens = [.photo,.library]
     //   config.screens = [.library,.photo]
        config.video.libraryTimeLimit = 500.0
        config.showsCrop = .none
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 5
        config.library.skipSelectionsGallery = true
        let picker = YPImagePicker(configuration: config)
        
        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                //print("Picker was canceled")
                picker.dismiss(animated: true, completion: {
                    self.navigationController?.popViewController(animated: true)
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
                            printt("Error converting image to data")
                        }
                    case .video( _):
                        return
                    }
                }
                picker.dismiss(animated: true, completion: { [weak self] in
                    
                     let vc = self?.storyboard?.instantiateViewController(withIdentifier: "PostStudentActivity") as! PostStudentActivity
                        vc.imageDataArray = imageDataArr
                        vc.selectedImages = imageArray
                    vc.currentDate = self?.currentDate ?? ""
                    if let studentId = self?.studentId {
                        vc.studentId = String(studentId)
                        vc.classId = String(self?.classId ?? 0)
                    }
                        self?.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }
        }
        picker.definesPresentationContext = true
        picker.modalPresentationStyle = .overCurrentContext
        present(picker, animated: true, completion: nil)
    }
    
}
