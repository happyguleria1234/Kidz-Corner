////
////  APIRequest.swift
////  AffroppleApp
////
////  Created by pallvi gupta on 11/09/22.
////  Copyright © 2019 apple. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Reachability
//
//var callBackFromWeb: (()->())?
//
//struct WebService {
//    
//    static let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
//    
//    static func service<Model: Codable>(_ api: String, urlAppendId: Any? = nil,form_urlencoded : Bool = false, param: Any? = nil, service: Services = .post ,showHud: Bool = true, response:@escaping (Model,Data,Any) -> Void) {
//        if Reachability.isConnectedToNetwork() {
//            var fullUrlString = baseUrl + api
//            if let idApend = urlAppendId{
//                fullUrlString = baseUrl + api + "/\(idApend)"
//            }
//            if service == .get{
//                if let parm = param{
//                    if parm is String{
//                        fullUrlString.append("?")
//                        fullUrlString += (parm as! String)
//                    }else if parm is Dictionary<String, Any>{
//                        fullUrlString += self.getString(from: parm as! Dictionary<String, Any>)
//                    }else{
//                        assertionFailure("Parameter must be Dictionary or String.")
//                    }}}
//            print(fullUrlString)
//            guard let encodedString = fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {return}
//            var request = URLRequest(url: URL(string: encodedString)!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 2000)
//            request.httpMethod = service.rawValue
//            if let authKey = Store.authKey {
//                request.addValue("Bearer " + authKey, forHTTPHeaderField: "Authorization")
//                print("authKey---\("Bearer " + authKey)")
//            }
//            if (api == APIs.login ||  api == APIs.register ) {
//                request.addValue("dfdf", forHTTPHeaderField: "device_token")
//                request.addValue("2", forHTTPHeaderField: "device_type")
//            }
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//            request.addValue(secretKey, forHTTPHeaderField: "secret_key")
//            request.addValue(publishKey, forHTTPHeaderField: "publish_key")
//            request.addValue(deviceIp, forHTTPHeaderField: "device")
//            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//            
//            if service == .delete {
//                //   request.addValue("application/json", forHTTPHeaderField: "Accept")
//                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//                if let param = param{
//                    if param is String{
//                        let postData = NSMutableData(data: (param as! String).data(using: String.Encoding.utf8)!)
//                        request.httpBody = postData as Data
//                    }else if param is Dictionary<String, Any>{
//                        var parm = self.getString(from: param as! Dictionary<String, Any>)
//                        //print(parm)
//                        parm.removeFirst()
//                        let postData = NSMutableData(data: parm.data(using: String.Encoding.utf8)!)
//                        request.httpBody = postData as Data
//                    }
//                }
//            }
//            
//            if service == .put || service == .post{
//                //request.addValue("application/json", forHTTPHeaderField: "Accept")
//                if form_urlencoded == true {
//                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//                    if let param = param{
//                        if param is String{
//                            let postData = NSMutableData(data: (param as! String).data(using: String.Encoding.utf8)!)
//                            request.httpBody = postData as Data
//                        }else if param is Dictionary<String, Any>{
//                            var parm = self.getString(from: param as! Dictionary<String, Any>)
//                            //print(parm)
//                            parm.removeFirst()
//                            let postData = NSMutableData(data: parm.data(using: String.Encoding.utf8)!)
//                            request.httpBody = postData as Data
//                        }
//                    }
//                }else {
//                    if let parameter = param {
//                        if parameter is String {
//                            request.httpBody = (parameter as! String).data(using: .utf8)
//                        } else if parameter is Dictionary<String, Any>{
//                            var body = Data()
//                            for (key, Value) in parameter as! Dictionary<String, Any>{
//                                //print(key,Value)
//                                if let imageInfo = Value as? ImageStructInfo{
//                                    body.append("--\(boundary)\r\n")
//                                    body.append("Content-Disposition: form-data; name=\"\(imageInfo.key)\"; filename=\"\(imageInfo.fileName)\"\r\n")
//                                    body.append("Content-Type: \(imageInfo.type)\r\n\r\n")
//                                    body.append(imageInfo.data)
//                                    body.append("\r\n")
//                                    request.httpBody = body
//                                }
//                                else if let images = Value as? [ImageStructInfo]{
//                                    for value in images{
//                                        body.append("--\(boundary)\r\n")
//                                        body.append("Content-Disposition: form-data; name=\"\(value.key)\"; filename=\"\(value.fileName)\"\r\n")
//                                        body.append("Content-Type: \(value.type)\r\n\r\n")
//                                        body.append(value.data)
//                                        body.append("\r\n")
//                                        request.httpBody = body
//                                    }
//                                }
//                                else{
//                                    body.append("--\(boundary)\r\n")
//                                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                                    body.append("\(Value)\r\n")
//                                }
//                            }
//                            body.append("--\(boundary)--\r\n")
//                            request.httpBody = body
//                        } else {
//                            assertionFailure("Parameter must be Dictionary or String.")
//                        }}}
//            }
//            let sessionConfiguration = URLSessionConfiguration.default
//            let session = URLSession(configuration: sessionConfiguration)
//            session.dataTask(with: request) { (data, jsonResponse, error) in
//                if showHud{
//                    DispatchQueue.main.async {
//                        if let vc = UIApplication.shared.keyWindow{
//                            MBProgressHUD.hide(for: vc, animated: true)
//                        }
//                    }
//                }
//                if error != nil{
//                    CommonUtilities.shared.showAlert(message: error!.localizedDescription, isSuccess: .error)
//                }else{
//                    if let jsonData = data{
//                        do{
//                            let jsonSer = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String: Any]
//                            print(jsonSer)
//                            let codeInt = jsonSer["code"] as? Int ?? 0
//                            let code = "\(codeInt)"
//                            if let httpResponse = jsonResponse as? HTTPURLResponse {
//                                print("statusCode: \(httpResponse.statusCode)")
//                            }
//                            if code == "401"{
//                                DispatchQueue.main.async {
//                                    if UIApplication.shared.isRegisteredForRemoteNotifications{
//                                        UIApplication.shared.unregisterForRemoteNotifications()
//                                        UIApplication.shared.registerForRemoteNotifications()
//                                    }
//                                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//                                    let SignInViewController = mainStoryBoard.instantiateViewController(withIdentifier: "InitialVC") as! InitialVC
//                                    Store.autoLogin = false
//                                    Store.userDetails = nil
//                                    Store.userType = nil
//                                    let nav = UINavigationController.init(rootViewController: SignInViewController)
//                                    nav.isNavigationBarHidden = true
//                                    UIApplication.shared.windows.first?.rootViewController = nav
//                                }
//                            } else if code != "200" {
//                                DispatchQueue.main.async {
//                                    if let message = jsonSer["message"] as? String{
//                                        if message == "Invalid OTP." {
//                                            callBackFromWeb?()
//                                        }
//                                        CommonUtilities.shared.showAlert(message: message, isSuccess: .error)
//                                    }
//                                }
//                            }else{
//                                let decoder = JSONDecoder()
//                                let model = try decoder.decode(Model.self, from: jsonData)
//                                DispatchQueue.main.async {
//                                    response(model,jsonData,jsonSer)
//                                }
//                            }
//                        }catch let err{
//                            print(err)
//                            CommonUtilities.shared.showAlert(message: err.localizedDescription, isSuccess: .error)
//                        }
//                    }
//                }
//            }.resume()
//        }
//        else
//        {
//            self.showAlert(noInternetConnection)
//        }
//    }
//    
//    private static func showAlert(_ message: String){
//        DispatchQueue.main.async {
//            CommonUtilities.shared.showAlert(message: message, isSuccess: .error)
//        }
//    }
//    
//    
//    private static func getString(from dict: Dictionary<String,Any>) -> String{
//        var stringDict = String()
//        stringDict.append("?")
//        for (key, value) in dict{
//            let param = key + "=" + "\(value)"
//            stringDict.append(param)
//            stringDict.append("&")
//        }
//        stringDict.removeLast()
//        return stringDict
//    }
//}
//
//extension Data {
//    mutating func append(_ string: String) {
//        if let data = string.data(using: .utf8){
//            append(data)
//        }
//    }
//}
//
//extension UIImage{
//    func toData() -> Data{
//        return self.jpegData(compressionQuality: 0.2) ?? Data()
//        
//    }
//    func isEqualToImage(image: UIImage) -> Bool
//    {
//        let data1: Data = self.pngData()!
//        let data2: Data = image.pngData()!
//        return data1 == data2
//    }
//}
//
//struct ImageStructInfo {
//    var fileName: String
//    var type: String
//    var data: Data
//    var key:String
//}
//
//struct ImageStructInfo2 {
//    var fileName: String
//    var type: String
//    var data: Data
//}
// 
//
//
//  
