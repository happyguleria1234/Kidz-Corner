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
    let downloadManager = DownloadManager.shared
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    @IBOutlet weak var pdfKit: WKWebView!
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var downloadBtn: UIButton!
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func downloadBtn(_ sender: UIButton) {
        if url.contains(".pdf") == true {
            // Download and save PDF
            guard let pdfUrl = URL(string: imageBaseUrl + url) else { return }
            downloadManager.downloadPDF(from: pdfUrl) { data in
                if let data = data {
                    self.downloadManager.savePDF(data: data, fileName: "downloaded_document.pdf")
                } else {
                    print("Failed to download PDF.")
                }
            }
            
        } else {
            // Download and save image
            guard let imageUrl = URL(string: imageBaseUrl + url) else { return }
            downloadManager.downloadImage(from: imageUrl) { image in
                if let image = image {
                    self.downloadManager.saveImage(image: image, fileName: "downloaded_image.jpg")
                } else {
                    print("Failed to download or convert image.")
                }
            }
        }
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
