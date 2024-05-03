import UIKit

class AttendanceContainer: UIViewController {
    
    var myName: String?
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonDate: UIButton!
    
    @IBOutlet weak var labelMorningTime: UILabel!
    @IBOutlet weak var labelMorningTemperature: UILabel!
    @IBOutlet weak var imageMorningTeacher: UIImageView!
    @IBOutlet weak var labelMorningTeacher: UILabel!
    
    @IBOutlet weak var labelEveningTime: UILabel!
    @IBOutlet weak var labelEveningTemperature: UILabel!
    @IBOutlet weak var imageEveningTeacher: UIImageView!
    @IBOutlet weak var labelEveningTeacher: UILabel!
    
    var delegate: DateSelected?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        buttonDate.addTarget(self, action: #selector(dates), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        printt("Attendance Container Appeared")
        
    }
    
    @objc func dates() {
        
        //self.parent.present
      
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityContainer") {
            self.parent?.present(vc, animated: true, completion: {
                printt("SS")
            })
        }
        
        
        self.delegate?.dateTapped()
    }
    func setupViews() {
        DispatchQueue.main.async { [self] in
            self.view.layer.cornerRadius = 20
            imageEveningTeacher.layer.cornerRadius = imageEveningTeacher.bounds.height/2.0
            imageMorningTeacher.layer.cornerRadius = imageMorningTeacher.bounds.height/2.0
        }
    }
}

protocol DateSelected: NSObjectProtocol {
    func dateTapped()
}

