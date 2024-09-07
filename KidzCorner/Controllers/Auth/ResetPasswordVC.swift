//
//  ResetPasswordVC.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 07/07/23.
//

import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var backToLogin: UILabel!
    @IBOutlet weak var tfEmail: UITextField! {
        didSet {
            tfEmail.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributedText()
    }
    

    @IBAction func didTapProceed(_ sender: Any) {
        if isValidEmail(tfEmail.text ?? "") {
            resetPasswordAPI()
        } else {
            Toast.toast(message: "Please enter a valid email", controller: self)
        }
    }

    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: SignIn.self)
    }
}

extension ResetPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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

// MARK: - API
extension ResetPasswordVC {
    func resetPasswordAPI() {
        var params = [String: String]()
        params = ["email": tfEmail.text ?? ""]
        
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        ApiManager.shared.Request(type: ResetPasswordModel.self, methodType: .Post, url: baseUrl+apiForgotPassword, parameter: params) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    if let response = myObject?.data {
                        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpVC") as? VerifyOtpVC {
                            nextVC.userInfo = response
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    } else {
                        Toast.toast(message: msgString ?? "Something went wrong!!", controller: self)
                    }
                }else {
                    Toast.toast(message: "The email address you entered is invalid.", controller: self)
                }
            }
        }
    }
}
