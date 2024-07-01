//
//  DownloadManager.swift
//  KidzCorner
//
//  Created by Happy Guleria on 29/06/24.
//

import UIKit

class DownloadManager {
    
    static let shared = DownloadManager()
    private let alertManager = AlertManager.shared // Injecting AlertManager
    private var activityIndicator: UIActivityIndicatorView?
    
    private init() {}
    
    private func showLoader() {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow) {
                if #available(iOS 13.0, *) {
                    self.activityIndicator = UIActivityIndicatorView(style: .large)
                } else {
                    // Fallback on earlier versions
                }
                self.activityIndicator?.center = keyWindow.center
                self.activityIndicator?.hidesWhenStopped = true
                keyWindow.addSubview(self.activityIndicator!)
                self.activityIndicator?.startAnimating()
            }
        }
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            self.activityIndicator = nil
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        showLoader()
        URLSession.shared.dataTask(with: url) { data, response, error in
            self.hideLoader()
            guard let data = data, error == nil else {
                print("Failed to download image:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func downloadPDF(from url: URL, completion: @escaping (Data?) -> Void) {
        showLoader()
        URLSession.shared.dataTask(with: url) { data, response, error in
            self.hideLoader()
            guard let data = data, error == nil else {
                print("Failed to download PDF:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
    
    func saveImage(image: UIImage, fileName: String) {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert image to data.")
            return
        }
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            DispatchQueue.main.async {
                self.alertManager.showAlert(title: "Success", message: "Image saved successfully.", viewController: UIApplication.shared.keyWindow?.rootViewController)
            }
        } catch {
            DispatchQueue.main.async {
                self.alertManager.showAlert(title: "Error", message: "Failed to save image: \(error.localizedDescription)", viewController: UIApplication.shared.keyWindow?.rootViewController)
            }
        }
    }
    
    func savePDF(data: Data, fileName: String) {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            DispatchQueue.main.async {
                self.alertManager.showAlert(title: "Success", message: "PDF saved successfully.", viewController: UIApplication.shared.keyWindow?.rootViewController)
            }
        } catch {
            DispatchQueue.main.async {
                self.alertManager.showAlert(title: "Error", message: "Failed to save PDF: \(error.localizedDescription)", viewController: UIApplication.shared.keyWindow?.rootViewController)
            }
        }
    }
}
