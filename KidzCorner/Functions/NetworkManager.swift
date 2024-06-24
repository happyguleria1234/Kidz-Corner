//
//  NetworkManager.swift
//  KidzCorner
//
//  Created by Happy Guleria on 16/06/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let loader = LoadingManager.shared

    func getRequest<T: Decodable>(urlString: String, responseType: T.Type, fromView view: UIView, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        loader.startAnimatingLoading(view)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.loader.stopAnimatingLoading()
            
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    func getRequestWithParam<T: Decodable>(urlString: String, params: [String: Any]?, responseType: T.Type, fromView view: UIView, completion: @escaping (Result<T, APIError>) -> Void) {
        guard var urlComponents = URLComponents(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if let params = params {
            urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        loader.startAnimatingLoading(view)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.loader.stopAnimatingLoading()
            }
            
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let jsonString = String(data: data, encoding: .utf8) ?? ""
                print("JSON Response String: \(jsonString)")
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }


    
    func postRequest<T: Decodable, U: Encodable>(urlString: String, requestBody: U, responseType: T.Type, fromView view: UIView, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        loader.startAnimatingLoading(view)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.decodingError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.loader.stopAnimatingLoading()
            
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}
