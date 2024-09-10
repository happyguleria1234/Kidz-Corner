//
//  DateManager.swift
//  KidzCorner
//
//  Created by Happy Guleria on 10/09/24.
//

class DatePickerHandler {

    var onDateSelected: ((Date) -> Void)?
    private var datePicker: UIDatePicker!
    private var toolbar: UIToolbar!
    private var textField: UITextField!

    init(parentView: UIView, textField: UITextField) {
        self.textField = textField
        setupDatePicker(parentView: parentView)
    }

    private func setupDatePicker(parentView: UIView) {
        // Create and configure the date picker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        textField.inputView = datePicker
        
        // Create toolbar with "Cancel" and "Done" buttons
        toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        if #available(iOS 14.0, *) {
            toolbar.setItems([cancelButton, UIBarButtonItem.flexibleSpace(), doneButton], animated: false)
        } else {
            // Fallback on earlier versions
        }
        toolbar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolbar
    }

    @objc private func donePressed() {
        // Call the onDateSelected closure with the selected date
        onDateSelected?(datePicker.date)
        textField.resignFirstResponder()
    }

    @objc private func cancelPressed() {
        // Simply dismiss the picker if Cancel is pressed
        textField.resignFirstResponder()
    }

    func showDatePicker() {
        textField.becomeFirstResponder() // This will show the picker
    }
}
