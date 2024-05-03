//
//  VerifyOtpVC.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 07/07/23.
//

import UIKit

class VerifyOtpVC: UIViewController {
    
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    @IBOutlet weak var third: UITextField!
    @IBOutlet weak var fourth: UITextField!
    @IBOutlet weak var fifth: UITextField!
    @IBOutlet weak var backToLogin: UILabel!
    
    var userInfo: ResetPasswordData?

    override func viewDidLoad() {
        super.viewDidLoad()
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
        fifth.delegate = self
        setupAttributedText()
    }
    
    @IBAction func didTapProceed(_ sender: Any) {
        if isValid() {
            verifyEmailAPI()
        }
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: SignIn.self)
    }
    
    func setupAttributedText() {
        let greenColor: UIColor = myGreenColor
        let placeholderColor: UIColor = placeholderColor
        
        let backToLoginStr  = "Back to Login" as NSString
        let backToLoginAttributed = NSMutableAttributedString(string: backToLoginStr as String)
        backToLoginAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: greenColor, range: backToLoginStr.range(of: "Login"))
        backToLoginAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: placeholderColor, range: backToLoginStr.range(of: "Back to"))
        backToLogin.attributedText = backToLoginAttributed
    }
}

extension VerifyOtpVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text
        
        if text?.utf16.count ?? 0 >= 1{
            switch textField{
            case first:
                second.becomeFirstResponder()
            case second:
                third.becomeFirstResponder()
            case third:
                fourth.becomeFirstResponder()
            case fourth:
                fifth.becomeFirstResponder()
            case fifth:
                fifth.resignFirstResponder()
            default:
                break
            }
        }else{
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func isValid() -> Bool {
        let str = getOtp()
        if str.utf16.count < 5 {
            Toast.toast(message: "Please enter valid otp", controller: self)
            return false
        } else {
            return true
        }
    }
    
    func getOtp() -> String {
        "\(first?.text?.trimmed() ?? "")\(second?.text?.trimmed() ?? "")\(third.text?.trimmed() ?? "")\(fourth.text?.trimmed() ?? "")\(fifth.text?.trimmed() ?? "")"
    }
}

extension VerifyOtpVC {
    func verifyEmailAPI() {
        guard let id = self.userInfo?.id else { return }
        var params = [String: String]()
        params = ["otp": self.getOtp(), "id": "\(id)"]
        
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        ApiManager.shared.Request(type: ResetPasswordModel.self, methodType: .Post, url: baseUrl+apiVerifyOtp, parameter: params) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    if let response = myObject?.data {
                        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC {
                            nextVC.userInfo = self.userInfo
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    } else {
                        Toast.toast(message: msgString ?? "Something went wrong!!", controller: self)
                    }
                }
                else if statusCode == 404 {
                    Toast.toast(message: "Email and password don't match", controller: self)
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? msgString ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
}

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
