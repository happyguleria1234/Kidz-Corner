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

extension Date {
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

extension Date {
    func timeAgoDisplayNew() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 30 * day
        let year = 365 * day
        
        if secondsAgo < minute {
            return "Just now"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minute\(secondsAgo / minute > 1 ? "s" : "") ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hour\(secondsAgo / hour > 1 ? "s" : "") ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) day\(secondsAgo / day > 1 ? "s" : "") ago"
        } else if secondsAgo < month {
            return "\(secondsAgo / week) week\(secondsAgo / week > 1 ? "s" : "") ago"
        } else if secondsAgo < year {
            return "\(secondsAgo / month) month\(secondsAgo / month > 1 ? "s" : "") ago"
        } else {
            return "\(secondsAgo / year) year\(secondsAgo / year > 1 ? "s" : "") ago"
        }
    }
}

func convertStrToDate(strDate: String) -> Date? {
    let dateFormatter = ISO8601DateFormatter()
    return dateFormatter.date(from: strDate)
}

func getDate(strDate: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" // Adjusted format
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current
    return dateFormatter.date(from: strDate)
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


import UIKit

@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

func extractTime(strDate: String) -> String? {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    guard let date = dateFormatter.date(from: strDate) else {
        return nil
    }
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm"
    return timeFormatter.string(from: date)
}


//MARK: LOCAL TIME ZONE
func timeconverter(isoDateString:String) -> String?{
    let isoDateFormatter = ISO8601DateFormatter()
    isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    let date = isoDateFormatter.date(from: isoDateString)
    let timestampCheck = date?.timeIntervalSince1970
    print("Timestamp here: -> \(timestampCheck)")
    let timeCurrentstamp = Int(timestampCheck!)
    let timestamp: TimeInterval = TimeInterval(timeCurrentstamp)
    let dateCheck = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm"
    //    FOR LOCAL
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
    //    FOR Singapore
    //    dateFormatter.timeZone = TimeZone(identifier: "Asia/Singapore")
    let localDateString = dateFormatter.string(from: dateCheck)
    print("Local time: -> \(localDateString)")
    return localDateString
}


//MARK: TIME STAMP CONVERTER
func convertTimeStampIntotime(timestamp:Double){
    let timeCurrentstamp = Int(timestamp)
    let timestamp: TimeInterval = TimeInterval(timeCurrentstamp)
    let dateCheck = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm"
    //    FOR LOCAL
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
    //    FOR Singapore
    //    dateFormatter.timeZone = TimeZone(identifier: "Asia/Singapore")
    let localDateString = dateFormatter.string(from: dateCheck)
    print("Local time: -> \(localDateString)")
}


extension String {
    func toLocalTimeHHmm() -> String? {
           // Create the input date formatter for the UTC date string
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
           dateFormatter.locale = Locale(identifier: "en_US_POSIX")
           dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
           
           // Parse the input date string
           guard let utcDate = dateFormatter.date(from: self) else {
               return nil
           }
           
           // Create the output date formatter for the local time zone
           let localDateFormatter = DateFormatter()
           localDateFormatter.dateFormat = "HH:mm"
           localDateFormatter.timeZone = TimeZone.current
        localDateFormatter.timeZone = .current
           // Convert the UTC date to the local time string
           let localTimeString = localDateFormatter.string(from: utcDate)
           
           return localTimeString
       }
}

func convertDate(_ dateString: String, fromFormat: String, toFormat: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    dateFormatter.timeZone = TimeZone(identifier: "UTC") // Set input time zone to UTC
    guard let date = dateFormatter.date(from: dateString) else {
        return nil
    }
    // Set the output time zone to the device's current time zone
    dateFormatter.timeZone = TimeZone.current
    // Set the output date format
    dateFormatter.dateFormat = toFormat
    return dateFormatter.string(from: date)
}


//extension Date {
//    func formattedDateAndTime() -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        return formatter.string(from: self)
//    }
//}

extension Date {
    func formattedDateAndTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func isNextDay(comparedTo date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.compare(self, to: date, toGranularity: .day) == .orderedDescending
    }
}
