import UIKit

class ChildInformation: UIViewController {
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var viewOuter: UIView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelClass: UILabel!
    
    @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var viewAttendance: UIView!
    
    @IBOutlet weak var attendanceTriangle: UIView!
    @IBOutlet weak var activityTriangle: UIView!
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AttendanceContainer().delegate = self
        
        setupViews()
        attendanceContainer()
    }
    
    @IBAction func backFunc(_ sender: Any) {
        
    }
    
    @IBAction func activityFunc(_ sender: Any) {
        activityContainer()
        containerHeight.constant = 750
    }
    @IBAction func attendanceFunc(_ sender: Any) {
        containerHeight.constant = 350
        attendanceContainer()
    }
    func setupViews() {
        DispatchQueue.main.async { [self] in
            
            viewContainer.defaultShadow()
            viewOuter.defaultShadow()
            viewOuter.layer.cornerRadius = 20
            viewActivity.layer.cornerRadius = 20
            viewAttendance.layer.cornerRadius = 20
            setDownTriangle(triangleView: attendanceTriangle)
            setDownTriangle(triangleView: activityTriangle)
        }
    }
    
    func activityContainer() {
        activityTriangle.isHidden = false
        attendanceTriangle.isHidden = true
        
//        ViewEmbedder.embed(withIdentifier: "ActivityContainer", parent: self, container: viewContainer) { AttendanceContainer in
//
//        }
    }
    
    func attendanceContainer() {
        activityTriangle.isHidden = true
        attendanceTriangle.isHidden = false
        
//        ViewEmbedder.embed(withIdentifier: "AttendanceContainer", parent: self, container: viewContainer) { AttendanceContainer in
//
//        }
    }
}

extension ChildInformation: DateSelected {
    
    func dateTapped() {
        printt("Dateeee")
    }
    
}
