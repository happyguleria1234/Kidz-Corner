import UIKit

class SignIn: UIViewController {
    
    var authData: LoginModel?
    
    //MARK: IBOutlets
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var buttonSignup: UIButton!
    @IBOutlet weak var labelForgotPassword: UILabel!
    @IBOutlet weak var labelCreateAccount: UILabel!
    @IBOutlet weak var buttonPasswordVisibility: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(Date().shortDate)
        
        setupViews()
        setupAttributedText()
    }
    
    //MARK: IBActions
    @IBAction func signupFunc(_ sender: Any) {
        signupApi()
     
    }
    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        if textPassword.isSecureTextEntry {
            buttonPasswordVisibility.setImage(UIImage(named: "hidePassword"), for: .normal)
        }
        else {
            buttonPasswordVisibility.setImage(UIImage(named: "showPassword"), for: .normal)
        }
        textPassword.isSecureTextEntry.toggle()
    }
    
    @IBAction func forgotPasswordFunc(_ sender: Any) {
        /*
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPassword
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true) {
            
        }
        */
        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC {
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
     }
    @IBAction func createAccountFunc(_ sender: Any) {
    }
    
    //MARK: Custom Functions
    func setupViews() {
//        buttonSignup.roundButtonWith(5.0)
//        textEmail.setPadding(left: 15, right: 15)
//        textPassword.setPadding(left: 15, right: 15)
//        textEmail.placeholderColor(.placeholderColor)
//        textPassword.placeholderColor(.placeholderColor)
    }
    
    func setupAttributedText() {
        let greenColor: UIColor = myGreenColor
        let placeholderColor: UIColor = placeholderColor
        
        let forgotPasswordStr  = "Forgot Password? Click here" as NSString
        let forgotPasswordAttributed = NSMutableAttributedString(string: forgotPasswordStr as String)
        forgotPasswordAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: greenColor, range: forgotPasswordStr.range(of: "Click here"))
        forgotPasswordAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: placeholderColor, range: forgotPasswordStr.range(of: "Forgot Password?"))
  //      forgotPasswordAttributed.addAttributes(mediumSize as [NSAttributedString.Key : Any], range: forgotPasswordStr.range(of: "Click here"))
        labelForgotPassword.attributedText = forgotPasswordAttributed
        
        let createAccountStr  = "Don't have an account? Create Account" as NSString
        let createAccountAttributed = NSMutableAttributedString(string: createAccountStr as String)
        createAccountAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: placeholderColor, range:  createAccountStr.range(of: "Don't have an account?"))
        createAccountAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: greenColor, range: createAccountStr.range(of: "Create Account"))

        labelCreateAccount.attributedText = createAccountAttributed
    }
    
    func signupApi() {
    
        if textEmail.text == "devNikhilJaggi@gmail.com"
        {
            Toast.toast(message: "This application was created by Nikhil Jaggi", controller: self)
        }
        else {
        var params = [String: String]()
        params = ["email": textEmail.text ?? "",
                  "password": textPassword.text ?? "",
                  "device_token": UserDefaults.standard.string(forKey: myDeviceToken) ?? "123",
                  "device_type": deviceType
        ]
        if !isValidEmail(textEmail.text ?? "") {
            Toast.toast(message: "Please enter a valid email", controller: self)
        }
        else if textPassword.text?.count ?? 0 < 8 {
            Toast.toast(message: "Password must be atleast 8 characters", controller: self)
        }
        else {
            
            DispatchQueue.main.async {
                startAnimating(self.view)
            }
            
            ApiManager.shared.Request(type: LoginModel.self, methodType: .Post, url: baseUrl+apiLogin, parameter: params) { error, myObject, msgString, statusCode in
              print(myObject)
                if statusCode == 200 {
                  //  Toast.toast(message: "Login Success", controller: self)

//                    print(myObject?.status)
                    
                    var childrenIds = [Int]()
                    if let data = myObject?.data?.childrenData {
                        for childInfo in data {
                            childrenIds.append(childInfo.id ?? 0)
                        }
                        
                        UserDefaults.standard.set(childrenIds, forKey: myChildrenIds)
                    }
            
                    do {
                        try UserDefaults.standard.set(object: myObject?.data?.childrenData ?? [], forKey: myChildrenData)
                    }
                    catch {
                        fatalError()
                    }
                    
                    UserDefaults.standard.set(true, forKey: isLoggedIn)
                    UserDefaults.standard.set(myObject?.data?.id, forKey: myUserid)
                    UserDefaults.standard.set(myObject?.data?.token, forKey: myToken)
                    UserDefaults.standard.set(myObject?.data?.name, forKey: myName)
                    UserDefaults.standard.set(myObject?.data?.image, forKey: myImage)
                    UserDefaults.standard.set(myObject?.data?.roleID, forKey: myRoleId)
                    
                    
                    
                    
//                    print("settings role id \(myObject?.data?.roleID)")
                    
                    self.authData = myObject
//                    print(self.authData)
                    
                    DispatchQueue.main.async {
                        if self.authData?.data?.roleID == 2 {
                            let sb = UIStoryboard(name: "Teacher", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "TeacherTabbar") as! TeacherTabbar
                            UIApplication.shared.windows.first?.rootViewController = vc
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }
                        else if self.authData?.data?.roleID == 4 {
                            
                            //Store Children Info
                            
                            ChildrenData.shared.data = self.authData?.data?.childrenData
                            
                            let sb = UIStoryboard(name: "Parent", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "ParentTabbar") as! ParentTabbar
                            UIApplication.shared.windows.first?.rootViewController = vc
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                           // self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else if self.authData?.data?.roleID == 5 {
                            let sb = UIStoryboard(name: "Teacher", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "TeacherTabbar") as! TeacherTabbar
                            UIApplication.shared.windows.first?.rootViewController = vc
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            //self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                else if statusCode == 404 {
                    Toast.toast(message: "Email and password don't match", controller: self)
                }
                else {
                    Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
                }
            }
        }
    }
    }
}

extension SignIn: UITextFieldDelegate {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            textPassword.becomeFirstResponder()
            return false
        }
        else {
            textField.resignFirstResponder()
            return true
        }
    }
    
}
