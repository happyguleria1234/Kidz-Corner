//
//  DateManager.swift
//  KidzCorner
//
//  Created by Happy Guleria on 10/09/24.
//

//class DatePickerHandler {
//
//    var onDateSelected: ((Date) -> Void)?
//    private var datePicker: UIDatePicker!
//    private var toolbar: UIToolbar!
//    private var textField: UITextField!
//
//    init(parentView: UIView, textField: UITextField) {
//        self.textField = textField
//        setupDatePicker(parentView: parentView)
//        
//    }
//
//    private func setupDatePicker(parentView: UIView) {
//        // Create and configure the date picker
//      var datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        if #available(iOS 14.0, *) {
//            datePicker.preferredDatePickerStyle = .wheels
//        }
//        
//        textField.inputView = datePicker
//        
//        // Create toolbar with "Cancel" and "Done" buttons
//        toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
//        if #available(iOS 14.0, *) {
//            toolbar.setItems([cancelButton, UIBarButtonItem.flexibleSpace(), doneButton], animated: false)
//        } else {
//            // Fallback on earlier versions
//        }
//        toolbar.isUserInteractionEnabled = true
//        
//        textField.inputAccessoryView = toolbar
//    }
//
//    @objc private func donePressed() {
//        // Call the onDateSelected closure with the selected date
////        onDateSelected?(datePicker.date)
//        textField.resignFirstResponder()
//    }
//
//    @objc private func cancelPressed() {
//        // Simply dismiss the picker if Cancel is pressed
//        textField.resignFirstResponder()
//    }
//
//    func showDatePicker() {
//        textField.becomeFirstResponder() // This will show the picker
//    }
//}

//class DatePickerHandler: NSObject {
//    
//    private var completion: ((Date) -> Void)?
//    private var datePickerContainer: UIView?
//    
//    func openDatePicker(on viewController: UIViewController, completion: @escaping (Date) -> Void) {
//        self.completion = completion
//        
//        // Create a container view
//        let container = UIView(frame: CGRect(x: 0, y: viewController.view.frame.height - 250, width: viewController.view.frame.width, height: 250))
//        container.backgroundColor = .white
//        self.datePickerContainer = container
//        
//        // Create the UIDatePicker
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        if #available(iOS 13.4, *) {
//            datePicker.preferredDatePickerStyle = .wheels
//        }
//        datePicker.frame = CGRect(x: 0, y: 44, width: container.frame.width, height: 206)
//        container.addSubview(datePicker)
//        
//        // Create the toolbar
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: container.frame.width, height: 44))
//        toolbar.sizeToFit()
//        
//        // Create "Done" and "Cancel" buttons
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        
//        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
//        container.addSubview(toolbar)
//        
//        // Show the picker on the screen
//        viewController.view.addSubview(container)
//        
//        // Save reference to datePicker for later use
//        datePicker.tag = 999 // Tag to identify the date picker if needed
//    }
//    
//    // Done button pressed
//    @objc private func donePressed() {
//        if let container = datePickerContainer, let datePicker = container.viewWithTag(999) as? UIDatePicker {
//            completion?(datePicker.date)
//        }
//        removeDatePicker()
//    }
//    
//    // Cancel button pressed
//    @objc private func cancelPressed() {
//        removeDatePicker()
//    }
//    
//    // Remove the date picker from view
//    private func removeDatePicker() {
//        datePickerContainer?.removeFromSuperview()
//    }
//}

//

//import UIKit


extension UIViewController {
    
    func openDatePicker(completion: @escaping (Date) -> Void) {
        // Create a container view
        let datePickerContainer = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 250, width: self.view.frame.width, height: 250))
        datePickerContainer.backgroundColor = .white
        
        // Create the UIDatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.maximumDate = Date()
        datePicker.frame = CGRect(x: 0, y: 44, width: self.view.frame.width, height: 206)
        datePickerContainer.addSubview(datePicker)
        
        // Create the toolbar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        
        // Create a "Done" button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed(_:)))
        
        // Create a "Cancel" button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed(_:)))
        
        // Flexible space between buttons
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        datePickerContainer.addSubview(toolbar)
        
        // Show the picker on the screen
        self.view.addSubview(datePickerContainer)
        
        // Store references using associated objects (optional but handy for cleanup)
        objc_setAssociatedObject(self, &datePickerKey, datePicker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &completionKey, completion, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &containerKey, datePickerContainer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // Done action
    @objc func donePressed(_ sender: UIBarButtonItem) {
        guard let datePicker = objc_getAssociatedObject(self, &datePickerKey) as? UIDatePicker,
              let completion = objc_getAssociatedObject(self, &completionKey) as? (Date) -> Void,
              let datePickerContainer = objc_getAssociatedObject(self, &containerKey) as? UIView else { return }
        
        let selectedDate = datePicker.date
        completion(selectedDate) // Send the selected date through the closure
        datePickerContainer.removeFromSuperview() // Remove picker after selection
    }
    
    // Cancel action
    @objc func cancelPressed(_ sender: UIBarButtonItem) {
        guard let datePickerContainer = objc_getAssociatedObject(self, &containerKey) as? UIView else { return }
        datePickerContainer.removeFromSuperview() // Remove picker when canceled
    }
}

// Associated object keys
private var datePickerKey: UInt8 = 0
private var completionKey: UInt8 = 0
private var containerKey: UInt8 = 0
