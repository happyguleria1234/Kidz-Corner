//
//  PdfVC2.swift
//  KidzCorner
//
//  Created by Happy Guleria on 23/05/24.
//
//

import UIKit
import WebKit
import PDFKit

class PdfVC2: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var pdfKit: WKWebView!
    
    var announcementPDF: String?
    var anouncementData: AnnouncementModelData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        var data = String()
      
        if let url = URL(string: imageBaseUrl + (anouncementData?.attachment ?? "")) {
            // Create a URLRequest from the URL
            let request = URLRequest(url: url)
            
            // Assuming pdfKit is an instance of WKWebView or a similar class
            pdfKit.navigationDelegate = self
            pdfKit.load(request)
        } else {
            // Handle the case where the URL is nil
            print("Invalid URL")
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
