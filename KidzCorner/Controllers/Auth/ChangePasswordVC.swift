//
//  ChangePasswordVC.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 07/07/23.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var tfNewPassword: UITextField! {
        didSet {
            tfNewPassword.delegate = self
        }
    }
    @IBOutlet weak var tfConfirmPassword: UITextField! {
        didSet {
            tfConfirmPassword.delegate = self
        }
    }
    @IBOutlet weak var backToLogin: UILabel!
    
    var userInfo: ResetPasswordData?

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributedText()
    }

    // MARK: - IBActions
    @IBAction func didTapChangePassword(_ sender: Any) {
        if isValid() {
            self.changePasswordAPI()
        }
    }

    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: SignIn.self)
    }
    
    // MARK: - Validations
    func isValid() -> Bool {
        if tfNewPassword.text?.trimmed().count ?? 0 < 8 {
            Toast.toast(message: "Password must be atleast 8 characters", controller: self)
            return false
        } else if tfConfirmPassword.text?.trimmed() != tfNewPassword.text?.trimmed() {
            Toast.toast(message: "Password Mismatch!!", controller: self)
            return false
        }
        return true
    }
}

// MARK: - UITextfield Delegate
extension ChangePasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case tfNewPassword:
            tfNewPassword.resignFirstResponder()
            tfConfirmPassword.becomeFirstResponder()
        case tfConfirmPassword:
            tfConfirmPassword.resignFirstResponder()
        default: break
        }
        return true
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

extension ChangePasswordVC {
    func changePasswordAPI() {
        guard let id = self.userInfo?.id else { return }
        var params = [String: String]()
        params = ["password": self.tfNewPassword.text?.trimmed() ?? "", "id": "\(id)"]
        
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
        
        ApiManager.shared.Request(type: ResetPasswordModel.self, methodType: .Post, url: baseUrl+apiChangePassword, parameter: params) { error, myObject, msgString, statusCode in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    if let response = myObject {
                        let alert = UIAlertController(title: "Kidz Corners", message: response.message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
                            self.navigationController?.popToViewController(ofClass: SignIn.self)
                        })
                        self.present(alert, animated: true)
                    } else {
                        Toast.toast(message: msgString ?? "Something went wrong!!", controller: self)
                    }
                } else if statusCode == 404 {
                    Toast.toast(message: "Email and password don't match", controller: self)
                } else {
                    Toast.toast(message: error?.localizedDescription ?? msgString ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
}
