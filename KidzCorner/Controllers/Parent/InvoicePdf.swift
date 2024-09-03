import UIKit
import WebKit

class InvoicePdf: UIViewController, UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate, UIDocumentPickerDelegate {
        
    var invoiceId: Int?
    var pdfURL: URL?
    var userID = Int()
    var pdfData: PDFData?
    
    @IBOutlet weak var webViewInvoice: WKWebView!
    @IBOutlet weak var lbl_invoice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewInvoice.navigationDelegate = self
        webViewInvoice.uiDelegate = self
        if invoiceId != 0 {
            if userID != 0 {
                getPDF(studentID:userID)
            } else {
                showInvoice()
            }
        } else {
            loadData()
            lbl_invoice.isHidden = true
        }
    }
    
    private func showIndicator() {
        DispatchQueue.main.async {
            startAnimating(self.view)
        }
    }
    
    private func stopIndicator() {
        DispatchQueue.main.async {
            stopAnimating()
        }
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showInvoice() {
        if let id = invoiceId {
            let myURL = URL(string: "\(invoicePdfUrl)\(String(id))\(invoicePdfKey)")
            let myRequest = URLRequest(url: myURL!)
            webViewInvoice.load(myRequest)
        }
    }
    
    @IBAction func btnDownloadPdf(_ sender: UIButton) {
        guard let urlString = pdfData?.data?.url,
              let myURL = URL(string: "\(imageBaseUrl)\(urlString)") else {
            print("Invalid URL")
            return
        }

        // Create a URLSession to manage the download
        let urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

        // Create a download task
        let downloadTask = urlSession.downloadTask(with: myURL) { (tempURL, response, error) in
            // Check if there was an error
            if let error = error {
                print("Download Error: \(error.localizedDescription)")
                return
            }

            // Get the file manager and document directory path
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first

            // Create a destination URL in the documents directory
            if let tempURL = tempURL, let documentsURL = documentsURL {
                let destinationURL = documentsURL.appendingPathComponent(myURL.lastPathComponent)

                do {
                    if fileManager.fileExists(atPath: destinationURL.path) {
                        try fileManager.removeItem(at: destinationURL)
                    }
                    try fileManager.moveItem(at: tempURL, to: destinationURL)
                    print("File downloaded to: \(destinationURL)")

                    // Present the document picker to save the file to "Files" app
                    DispatchQueue.main.async {
                        if #available(iOS 14.0, *) {
                            let documentPicker = UIDocumentPickerViewController(forExporting: [destinationURL])
                            documentPicker.delegate = self
                            self.present(documentPicker, animated: true, completion: nil)
                        } else {
                            // Fallback on earlier versions
                        }
                    }

                } catch {
                    print("File Move Error: \(error.localizedDescription)")
                }
            }
        }

        // Start the download task
        downloadTask.resume()
    }
    
    func loadData() {
        let myRequest = URLRequest(url: pdfURL!)
        webViewInvoice.load(myRequest)
    }
    
    func getPDF(studentID: Int) {
        DispatchQueue.main.async {
            startAnimating((self.tabBarController?.view)!)
        }
                
        ApiManager.shared.Request(type: PDFData.self, methodType: .Post, url: baseUrl + downloadpdf, parameter: ["user_id": userID]) { [self] error, myObject, msgString, statusCode in
            if statusCode == 200 {
                DispatchQueue.main.sync {
                    self.pdfData = myObject
                    let myURL = URL(string: myObject?.data?.url ?? "")
                    let myRequest = URLRequest(url: myURL!)
                    webViewInvoice.load(myRequest)
                }
            } else {
                Toast.toast(message: error?.localizedDescription ?? somethingWentWrong, controller: self)
            }
        }
    }
    
    // WKNavigationDelegate Methods
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopIndicator()
        // Handle error (Optional)
    }
    
}


import Foundation

// MARK: - PortFolioDataModel
struct PDFData: Codable {
    let status: Int?
    let message: String?
    let data: PDFDataList?
}

// MARK: - DataClass
struct PDFDataList: Codable {
    let url: String?
}
