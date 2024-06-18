//
//  LoadingManager.swift
//  KidzCorner
//
//  Created by Happy Guleria on 16/06/24.
//

import Foundation
import UIKit

class LoadingManager {
    static let shared = LoadingManager()
    
    private init() {}
    
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var overlayView = UIView()

    func startAnimatingLoading(_ uiView: UIView) {
        DispatchQueue.main.async {
            self.overlayView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            self.overlayView.center = uiView.center
            self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.overlayView.clipsToBounds = true

            self.loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            self.loadingView.center = self.overlayView.center
            self.loadingView.backgroundColor = UIColor.lightGray
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10

            self.actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            if #available(iOS 13.0, *) {
                self.actInd.style = UIActivityIndicatorView.Style.large
            } else {
                self.actInd.style = UIActivityIndicatorView.Style.whiteLarge
            }
            self.actInd.center = CGPoint(x: self.loadingView.frame.size.width / 2, y: self.loadingView.frame.size.height / 2)

            self.loadingView.addSubview(self.actInd)
            self.overlayView.addSubview(self.loadingView)
            uiView.addSubview(self.overlayView)
            self.actInd.startAnimating()
        }
    }

    func stopAnimatingLoading() {
        DispatchQueue.main.async {
            self.actInd.stopAnimating()
            self.overlayView.removeFromSuperview()
        }
    }
}
