//
//  AlertManager.swift
//  KidzCorner
//
//  Created by Happy Guleria on 29/06/24.
//

import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    
    func showAlert(title: String?, message: String?, viewController: UIViewController?, completion: (() -> Void)? = nil) {
        guard let viewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController else {
            print("Failed to present alert: No view controller found.")
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showConfirmationAlert(on viewController: UIViewController, title: String, message: String, yesHandler: @escaping () -> Void, noHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            yesHandler()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            noHandler()
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
