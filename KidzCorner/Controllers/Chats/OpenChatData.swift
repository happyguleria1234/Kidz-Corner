//
//  OpenChatData.swift
//  KidzCorner
//
//  Created by Happy Guleria on 26/06/24.
//

import UIKit
import WebKit
import Foundation
import SDWebImage

class OpenChatData : UIViewController, WKNavigationDelegate {
    
    var url = String()
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    @IBOutlet weak var pdfKit: WKWebView!
    @IBOutlet weak var imgShow: UIImageView!
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if url.contains(".pdf") {
            imgShow.isHidden = true
            pdfKit.isHidden = false
            if let url = URL(string: imageBaseUrl + url) {
                let request = URLRequest(url: url)
                pdfKit.navigationDelegate = self
                pdfKit.load(request)
            } else {
                print("Invalid URL")
            }
        } else {
            imgShow.isHidden = false
            pdfKit.isHidden = true
            if let url = URL(string: imageBaseUrl+(url)) {
                print(url)
                imgShow.sd_setImage(with: url, placeholderImage: .placeholderImage, options: [.scaleDownLargeImages])
            }
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
