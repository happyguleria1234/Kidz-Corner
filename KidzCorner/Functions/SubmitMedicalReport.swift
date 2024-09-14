//
//  SubmitMedicalReport.swift
//  KidzCorner
//
//  Created by Happy Guleria on 14/09/24.
//

import Foundation

class MultipartFormDataRequest {
    
    let boundary: String
    var body: Data
    
    init() {
        self.boundary = "Boundary-\(UUID().uuidString)"
        self.body = Data()
    }
    
    func addTextField(key: String, value: String) {
        body += Data("--\(boundary)\r\n".utf8)
        body += Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8)
        body += Data("\(value)\r\n".utf8)
    }
    
    func addFileField(key: String, filePath: String, contentType: String = "application/octet-stream") throws {
        let fileURL = URL(fileURLWithPath: filePath)
        let fileName = fileURL.lastPathComponent
        let fileData = try Data(contentsOf: fileURL)
        
        body += Data("--\(boundary)\r\n".utf8)
        body += Data("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".utf8)
        body += Data("Content-Type: \(contentType)\r\n\r\n".utf8)
        body += fileData
        body += Data("\r\n".utf8)
    }
    
    func finalizeBody() {
        body += Data("--\(boundary)--\r\n".utf8)
    }
    
    func createRequest(url: String, headers: [String: String], httpMethod: String = "POST") -> URLRequest {
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
        request.httpMethod = httpMethod
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        for (headerField, value) in headers {
            request.addValue(value, forHTTPHeaderField: headerField)
        }
        
        request.httpBody = body
        return request
    }
    
    func execute(request: URLRequest, completion: @escaping (Result<String, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            completion(.success(responseString))
        }
        task.resume()
    }
}
