import UIKit


public func printt(_ message: String) {
#if DEBUG
    print(message)
#endif
}

//extension UITabBarController {
//    func removeDotFromTabBarItem(at index: Int) {
//        guard let tabBarItems = ParentTabbar().tabBar.items,
//              tabBarItems.count > index else { return }
//        
//        let itemView = tabBarItems[index].value(forKey: "view") as? UIView
//        itemView?.subviews.forEach { if $0.tag == 101 { $0.removeFromSuperview() } }
//    }
//    
//    func addDotToTabBarItem(at index: Int, color: UIColor = .red, diameter: CGFloat = 10) {
//        
//        printt("\(ParentTabbar().tabBar.items)")
//        printt("\(ParentTabbar().tabBar.items?.count)")
//        
//        guard let tabBarItems = ParentTabbar().tabBar.items,
//              tabBarItems.count > index else { return }
//        
//        let itemView = tabBarItems[index].value(forKey: "view") as? UIView
//        let dot = UIView(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
//        dot.layer.cornerRadius = diameter / 2
//        dot.backgroundColor = color
//        dot.tag = 101 // An arbitrary tag to identify the dot later
//        
//        // Calculate the size and position of the dot based on the tab item's frame
//        let itemFrame = itemView?.frame ?? CGRect.zero
//        let dotX = itemFrame.midX + (itemFrame.width / 4) - (diameter / 2)
//        let dotY = itemFrame.height - diameter - 3 // Adjust the Y position as needed
//        
//        dot.frame.origin = CGPoint(x: dotX, y: dotY)
//        
//        // Remove old dot if any before adding the new one
//        itemView?.subviews.forEach { if $0.tag == 101 { $0.removeFromSuperview() } }
//        
//        // Add the dot to the tab bar item's view
//        itemView?.addSubview(dot)
//    }
//
//}


extension Float {
   mutating func convertTemperatureToFahrenheit() -> Float {
//       return((self * 9/5) + 32)
       if 85.00 <= self && self <= 105.0 {
           return ((self - 32) * 5/9)
       }
       else {
           return self
       }
       
    }
}



extension UITextField {
    
    func defaultTf() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    func setPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.rightView = paddingView
            self.leftViewMode = .always
            self.rightViewMode = .always
        }
        
        func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        func setRightPaddingPoints(_ amount:CGFloat) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
        
    func setInputViewDatePicker(target: Any, selector: Selector , datePickerMode : UIDatePicker.Mode? = .dateAndTime , minimumDate:Date? = Date() , MaximumDate: Date? = Calendar.current.date(byAdding: .year, value: +1, to: Date())! ) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = MaximumDate
        datePicker.datePickerMode = datePickerMode ?? .dateAndTime
        self.inputView = datePicker //3
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    /*USE LIKE THIS IN SELECTOR METHOD
     In View Did Load :
     textFeild.setInputViewDatePicker(target: self, selector: #selector(tapDoneStart))
     #Selector Method to show usage
     @objc func tapDoneStart(){
     if let datePicker = self.tfStartTime.inputView as? UIDatePicker {
     let dateformatter = DateFormatter()
     dateformatter.dateFormat = "dd MMM, hh:mm"
     self.textFeild.text = dateformatter.string(from: datePicker.date)
     }
     self.tfStartTime.resignFirstResponder()
     }
     */
}
extension Date {
    
    /*
     dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
     */
    
        func timeAgoDisplay() -> String {
                let calendar = Calendar.current
                let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
                let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
                let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
                let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

                if minuteAgo < self {
                    let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
                    return "\(diff) sec ago"
                } else if hourAgo < self {
                    let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
                    return "\(diff) min ago"
                } else if dayAgo < self {
                    let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
                    return "\(diff) hrs ago"
                } else if weekAgo < self {
                    let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
                    return "\(diff) days ago"
                }
                let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
                return "\(diff) weeks ago"
            }
    
    func localizedDescription(date dateStyle: DateFormatter.Style = .medium,
                              time timeStyle: DateFormatter.Style = .medium,
                              in timeZone: TimeZone = .current,
                              locale: Locale = .current,
                              using calendar: Calendar = .current) -> String {
        Formatter.date.calendar = calendar
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        Formatter.date.dateFormat = "dd-MM-yyyy"
        return Formatter.date.string(from: self)
    }
    
    func longDescription(date dateStyle: DateFormatter.Style = .medium,
                         time timeStyle: DateFormatter.Style = .medium,
                         in timeZone: TimeZone = .current,
                         locale: Locale = .current,
                         using calendar: Calendar = .current) -> String {
        Formatter.date.calendar = calendar
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        Formatter.date.dateFormat = "dd MMMM yyyy"
        return Formatter.date.string(from: self)
    }
    
    var localizedDescription: String { localizedDescription() }
    var longDescription: String { longDescription() }
    
    var shortDate: String { localizedDescription(date: .short, time: .none) }
    
    var longDate: String { longDescription(date: .long, time: .none)}
}

extension Formatter {
    static let date = DateFormatter()
}

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}


extension UIViewController {
    
    func defaultTextfields(tfs: [UITextField]) {
        
        for tf in tfs {
            tf.defaultTf()
        }
    }
}

extension String {
    static var currentTime: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "SGT")
        return dateFormatter.string(from: currentDate)
    }
}

extension UIDatePicker {
    
    var textColor: UIColor {
        set {
            setValue(newValue, forKeyPath: "textColor")
        }
        get {
            return value(forKeyPath: "textColor") as? UIColor ?? .black
        }
    }
}

extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
