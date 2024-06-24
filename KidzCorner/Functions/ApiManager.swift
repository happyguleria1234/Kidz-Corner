import Foundation
import UIKit

//Mark:- API MANAGER , MAKE USE OF URL SESSIONS FOR MAKING REQUESTS TO REMOTE SERVER

//CONTAIN PUT , PATCH, POST , GET , DELETE AND MULTIPART(POST) REQUEST
class ApiManager  {
    
    public static let shared = ApiManager()
    private init(){}
    
    //IF YOUR BACKEND IS USING BASIC AUTHENTICATION , PLEASE ADD YOUR USERNAME AND PASSWORD THERE, IT WILL BE USED INSIDE THE METHOD
    //IN CASE OF NO USERNAME AND PASSWORD , LEAVE THEM AS IT IS
    
    let USERNAME = ""
    let PASSWORD = ""
    
    //MARK:- ALERT METHOD FOR SHOWING INTERNET CONNECTION ERROR
    //TO BE USED IN THE MEHODS
    func callInternetAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    //MARK:- REQUEST METHOD
    func Request<T:Decodable>(type: T.Type ,methodType: MethodType,url:String,sessionKey: String? = nil ,parameter: [String:Any],completion:@escaping (_ error: Error?, _ myObject: T? , _ msgString : String? , _ statusCode : Int?) -> ()){
        
        //CHECKING INTERNET CONNECTIVTY
        guard Connectivity.isConnectedToInternet else {
            //IF NOT CONNECTED TO INTERNET , GO OUT OF METHOD ,SHOW ALERT AND STOP INDICATOR
            stopAnimating()
            callInternetAlert()
            return
        }
        
        //CHECKING URL VALIDATION
        guard let url = URL(string: url) else {
            //IF NOT A VALID URL , SHOW ALERT , STOP INDICATOR AND RETURN
            stopAnimating()
            Toast.show(message: "Invalid Url !", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: UIColor.red)
            return
        }
        
        //CREATING A NEW URL SO THAT WE CAN APPEND IN CASE OF GET OR DELETE REQUEST
        var finalUrl = url
        
        if methodType == .Get || methodType == .Delete {
            //MOSTLY , GET AND DELETE REQUESTS DO NOT HAVE A BODY AND QUERY PARAMS ARE APPENDED TO URL, WE WILL USE THE PARAMETER TO GENERATE A [String: String] DICTIONARY AND THEN APPEND TO URL
            
            let stringDictionary = CovertToStringDict(parameter)
           
            //CHECKING IF WE CAN APPEND PARAMETERS TO STRING URL
            guard let newURl = url.append(queryParameters: stringDictionary) else {
                stopAnimating()
                Toast.show(message: "Unable to Generate appended Url for \(methodType.rawValue) request !", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: UIColor.red)
                return
            }
            //GENERATE NEW URL
            finalUrl = newURl
            printt("GENERATED URL FOR \(methodType.rawValue) request : \(finalUrl)")
        }else {
            //PRINTING PARAMETERS TO CONSOLE
            printt("Parameters for \(finalUrl) : \(parameter)")
        }
        
        //CREATING REQUEST FROM URL
        var request = URLRequest(url: finalUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        //DEFINING REQUEST TYPE
        request.httpMethod = methodType.rawValue
        
        //SETTING UP BASIC AUTH IF USERNAME AND PASSWORD IS ADDED
        if USERNAME != "" {
            let loginString = "\(USERNAME):\(PASSWORD)"
            guard let loginData = loginString.data(using: String.Encoding.utf8) else {
                return
            }
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }
     
        //SETTING SESSION KEY TO HEADER
        //CHECK FOR THIS STEP YOURSELF, SOME BACKEND DEVELOPER SET THERE OWN KEY (say "sessionkey" or "sessionKey" or something else) IN PLACE OF "Authorization" ,  ALSO SOMETIMES SESSIONKEY IS PASSED LIKE "Bearer \(sessionKey)" , THIS DEPEND ON BACKEDN , YOU NEED TO CHECK THAT FOR ONE TIME ONLY
//        if sessionKey != nil {
//            request.setValue(sessionKey ?? "", forHTTPHeaderField: "Authorization")
//        }
        
        if let myToken = UserDefaults.standard.string(forKey: myToken) {
            print(myToken)
        request.setValue("Bearer \(myToken)", forHTTPHeaderField: "Authorization")
        }
        //YOU CAN PASS OTHER HEADERS ACCORDING TO YOUR REQUIREMENT
        //USING request.setValue("VALUE_HERE", forHTTPHeaderField: "HEADER_HERE")
        
        //SETTING UP BODY
        if methodType == .Post {
            request.httpBody = parameter.percentEncoded()
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }else {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if methodType == .Get || methodType == .Delete {
             //GET METHOD MUST NOT HAVE A BODY , SAME GOES FOR DELETE , I GUESS
            }else if methodType == .Patch || methodType == .Put{
                let postData = try? JSONSerialization.data(withJSONObject: parameter, options: [])
                request.httpBody = postData
            }
        }
        
        //SENDING REQUEST
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            //STOP LOADER AS SOON AS THE RESULT ARRIVE
            stopAnimating()
            
            //CHECKING FOR ERROR
            guard error == nil else {
                DispatchQueue.main.async {
                Toast.show(message: "Error : \(error!.localizedDescription)", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: .red)
                }
                return
            }
            
            //CHECKING FOR RIGHT OUTPUT
            guard let httpResponse = response as? HTTPURLResponse else {
                //THIS HAPPENDS MOSTLY IN CASE OF SERVER ERROR
                DispatchQueue.main.async {
                Toast.show(message: "Something Went Wrong !", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: .red)
                }
                return
            }
            printt("STATUS CODE FOR \(finalUrl) : \(httpResponse.statusCode)")
            if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print(String(decoding: jsonData, as: UTF8.self))
            } else {
                print("json data malformed")
            }
            if httpResponse.statusCode == 200{
                
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data!)
                    completion(nil,decoded , nil ,200)
                } catch let errorr   {
                    //IF YOU ARE GETTING ERROR IN MODEL DECODING , FORCE URWRAP try (put ! after try)  , APPLICATION WILL CRASH AND THE INFORMATION ABOUT THE KEY THAT IS CAUSING TROUBLE, WILL GET PRINTED TO CONSOLE
                    completion(errorr,nil , nil ,200)
                }
            }else{
                stopAnimating()
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions() , .allowFragments]) as! [String:Any]
                    printt("JSON OF FAILED REQUEST \(jsonResponse)")
                    //CHECK FOR MESSAGE KEY IN THE ABOVE RESPONSE AND ENTER BELOW IN PLACE OF "message"
                    completion(error, nil , jsonResponse["message"] as? String ?? "Something Went Wrong" , httpResponse.statusCode)
                }catch let errr {
                    completion(errr,nil , nil , httpResponse.statusCode)
                    
                }
            }
        }).resume()
    }
    
    //Usage:
    //IMPORTANT NOTE:-
    //YOU DON'T HAVE TO APPEND QUERRY PARAMS TO URL FOR USING GET AND DELETE REQUEST , JUST PASS THE PARAMETERS IN parameters AND METHOD WILL AUTOMATICALLY APPEND IT TO URL STRING IN CASE OF GET AND DELETE REQUEST
    /*
     WITH SESSION KEY :
     ApiManager.shared.Request(type: SomeModel.self, methodType: MethodType.Post, url: "your url string here", parameter: [String:Any]()) { (error, response, stringMessage, statusCode) in
     //Get your response here
     }
     WITHOUT SESSION KEY:
     ApiManager.shared.Request(type: SomeModel.self, methodType: MethodType.Get, url: "your url string here", sessionKey: "your session key here(Pass Nil if not required)", parameter: [String:Any]()) { (error, response, stringMessage, statusCode) in
         //Get your response here
     }
     */
   
    //MARK:- MULTIPART FORM DATA REQUEST
    public func requestWithImage<T:Decodable>(type: T.Type,url:String, parameter:[String:Any]?,imageNames: [String], imageKeyName: String, images:[Data],sessionKey: String? = nil , completion: @escaping(_ error:Error?, _ myObject: T?,_ messageStr:String?,_ statusCode :Int?)->Void) {
        
        //CHECKING INTERNET CONNECTIVTY
        guard Connectivity.isConnectedToInternet else {
            //IF NOT CONNECTED TO INTERNET , GO OUT OF METHOD ,SHOW ALERT AND STOP INDICATOR
            stopAnimating()
            callInternetAlert()
            return
        }
        
        //CHECKING URL VALIDATION
        guard let url = URL(string: url) else {
            //IF NOT A VALID URL , SHOW ALERT , STOP INDICATOR AND RETURN
            stopAnimating()
            Toast.show(message: "Invalid Url !", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: UIColor.red)
            return
        }
        
            // generate boundary string using a unique per-app string
            let boundary = UUID().uuidString
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            
          
        request.httpMethod = MethodType.Post.rawValue
        //SETTING UP BASIC AUTH IF USERNAME AND PASSWORD IS ADDED
        if USERNAME != "" {
            let loginString = "\(USERNAME):\(PASSWORD)"
            guard let loginData = loginString.data(using: String.Encoding.utf8) else {
                return
            }
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }

        if let myToken = UserDefaults.standard.string(forKey: myToken) {
        request.setValue("Bearer \(myToken)", forHTTPHeaderField: "Authorization")
        }
        
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var data = Data()
            if parameter != nil{
                for(key, value) in parameter!{
                    // Add the reqtype field and its value to the raw http request data
                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                    data.append("\(value)".data(using: .utf8)!)
                }
            }
            for (index,imageData) in images.enumerated() {
                // Add the image data to the raw http request data
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(imageKeyName)\"; filename=\"\(index)\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                data.append(imageData)
            }
            
            // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            // Send a POST request to the URL, with the data we created earlier
            
            session.uploadTask(with: request, from: data , completionHandler: { (data, response, error) in
                //STOP LOADER AS SOON AS THE RESULT ARRIVE
                stopAnimating()
                
                //CHECKING FOR ERROR
                guard error == nil else {
                    DispatchQueue.main.async {
                    Toast.show(message: "Error : \(error!.localizedDescription)", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: .red)
                    }
                    return
                }
                
                //CHECKING FOR RIGHT OUTPUT
                guard let httpResponse = response as? HTTPURLResponse else {
                    //THIS HAPPENDS MOSTLY IN CASE OF SERVER ERROR
                    DispatchQueue.main.async {
                    Toast.show(message: "Something Went Wrong !", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: .red)
                    }
                    return
                }
                
                    if httpResponse.statusCode == 200{
                        
//                        do {
//                            let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers,.allowFragments]) as! [String: Any]
//                            completion(nil, nil,(json["message"] as? String),httpResponse.statusCode)
//                            printt("Json of Failed mutlipart request \(json)")
//                        } catch let myJSONError {
//                            completion(myJSONError,nil,nil,httpResponse.statusCode)
//                        }
                        
                        guard let data = data else {
                            completion(error, nil,nil,httpResponse.statusCode)
                            return
                        }
                        guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
                            DispatchQueue.main.async {
                            Toast.show(message: "Unable to decode Model!", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: .red)
                        }
                            return
                        }
                        completion(nil,decodeData,nil,httpResponse.statusCode)

                    }else{
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers,.allowFragments]) as! [String: Any]
                            completion(nil, nil,(json["message"] as? String),httpResponse.statusCode)
                            printt("Json of Failed mutlipart request \(json)")
                        } catch let myJSONError {
                            completion(myJSONError,nil,nil,httpResponse.statusCode)
                        }
                        
                    
                    }
            }).resume()
        }
    
    //USAGE :- SAME AS ABOVE METHOD

    // MARK: - New Multipart Request
    public func requestWithImageNew<T:Decodable>(type: T.Type,url:String, parameter:[String:Any]?, media: [Media],sessionKey: String? = nil , completion: @escaping(_ error:Error?, _ myObject: T?,_ messageStr:String?,_ statusCode :Int?)->Void){
        
        //CHECKING INTERNET CONNECTIVTY
        guard Connectivity.isConnectedToInternet else {
            //IF NOT CONNECTED TO INTERNET , GO OUT OF METHOD ,SHOW ALERT AND STOP INDICATOR
            stopAnimating()
            callInternetAlert()
            return
        }
        
        //CHECKING URL VALIDATION
        guard let url = URL(string: url) else {
            //IF NOT A VALID URL , SHOW ALERT , STOP INDICATOR AND RETURN
            stopAnimating()
            Toast.show(message: "Invalid Url !", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: UIColor.red)
            return
        }
        
            // generate boundary string using a unique per-app string
            let boundary = UUID().uuidString
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            
          
        request.httpMethod = MethodType.Post.rawValue
        //SETTING UP BASIC AUTH IF USERNAME AND PASSWORD IS ADDED
        if USERNAME != "" {
            let loginString = "\(USERNAME):\(PASSWORD)"
            guard let loginData = loginString.data(using: String.Encoding.utf8) else {
                return
            }
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }

        if let myToken = UserDefaults.standard.string(forKey: myToken) {
        request.setValue("Bearer \(myToken)", forHTTPHeaderField: "Authorization")
        }
        
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var data = Data()
            if parameter != nil{
                for(key, value) in parameter!{
                    // Add the reqtype field and its value to the raw http request data
                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                    data.append("\(value)".data(using: .utf8)!)
                }
            }
        /*
            for (index,imageData) in images.enumerated() {
                // Add the image data to the raw http request data
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(imageKeyName)\"; filename=\"\(index)\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                data.append(imageData)
            }
         */
        
        let lineBreak = "\r\n"
         for photo in media {
             /*
             data.append("--\(boundary + lineBreak)".data(using: .utf8)!)
             data.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)".data(using: .utf8)!)
             data.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)".data(using: .utf8)!)
             data.append(photo.data)
              */
             data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
             data.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\r\n".data(using: .utf8)!)
//                data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
             data.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)".data(using: .utf8)!)
             data.append(photo.data)

//                data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//             data.append(lineBreak.data(using: .utf8)!)
         }
            
            // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            // Send a POST request to the URL, with the data we created earlier
            
            session.uploadTask(with: request, from: data , completionHandler: { (data, response, error) in
                //STOP LOADER AS SOON AS THE RESULT ARRIVE
                stopAnimating()
                
                //CHECKING FOR ERROR
                guard error == nil else {
                    DispatchQueue.main.async {
                    Toast.show(message: "Error : \(error!.localizedDescription)", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: .red)
                    }
                    return
                }
                
                //CHECKING FOR RIGHT OUTPUT
                guard let httpResponse = response as? HTTPURLResponse else {
                    //THIS HAPPENDS MOSTLY IN CASE OF SERVER ERROR
                    DispatchQueue.main.async {
                    Toast.show(message: "Something Went Wrong !", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: .red)
                    }
                    return
                }
                
                    if httpResponse.statusCode == 200{
                        
//                        do {
//                            let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers,.allowFragments]) as! [String: Any]
//                            completion(nil, nil,(json["message"] as? String),httpResponse.statusCode)
//                            printt("Json of Failed mutlipart request \(json)")
//                        } catch let myJSONError {
//                            completion(myJSONError,nil,nil,httpResponse.statusCode)
//                        }
                        
                        guard let data = data else {
                            completion(error, nil,nil,httpResponse.statusCode)
                            return
                        }
                        guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
                            DispatchQueue.main.async {
                            Toast.show(message: "Unable to decode Model!", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: .red)
                        }
                            return
                        }
                        completion(nil,decodeData,nil,httpResponse.statusCode)

                    }else{
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers,.allowFragments]) as! [String: Any]
                            completion(nil, nil,(json["message"] as? String),httpResponse.statusCode)
                            printt("Json of Failed mutlipart request \(json)")
                        } catch let myJSONError {
                            completion(myJSONError,nil,nil,httpResponse.statusCode)
                        }
                        
                    
                    }
            }).resume()
        }
    }
   
extension Dictionary {
  public  func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}



// MARK:- APPENING QUERRY PARAMS TO URL FOR GET AND DELETE REQUEST
extension URL {
  func append(queryParameters: [String: String]) -> URL? {
      guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
        Toast.show(message: "Unable to Bind Url !", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: .red)
          return nil
      }

      let urlQueryItems = queryParameters.map {
          return URLQueryItem(name: $0, value: $1)
      }
      urlComponents.queryItems = urlQueryItems
      return urlComponents.url
  }
}

//MARK:- CONVERT [STRING : ANY]() TO [STRING: STRING]()
func CovertToStringDict(_ dict : [String:Any]) -> [String:String] {
    var newDict = [String:String]()
    for (key, value) in dict {
        newDict[key] = "\(value)"
    }
    return newDict
}



struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String
    let fileExt: String

//    init?(withImageData image: Data, forKey key: String, withMimeType mimeType: String = "image/jpg", withFileExt: String = ".jpeg") {
//        self.key = key
//        self.mimeType = mimeType
//        self.fileName = "\(arc4random())\(fileExt)"
//
////        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
//        self.data = image
//    }
}
