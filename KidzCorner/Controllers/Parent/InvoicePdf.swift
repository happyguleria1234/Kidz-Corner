import UIKit
import WebKit

class InvoicePdf: UIViewController, UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webViewInvoice: WKWebView!
    
    var invoiceId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewInvoice.navigationDelegate = self
        webViewInvoice.uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInvoice()
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showInvoice() {
        if let id = invoiceId {
            let myURL = URL(string:"\(invoicePdfUrl)\(String(id))\(invoicePdfKey)")
            
            printt("Invoice \(myURL)")
            
            let myRequest = URLRequest(url: myURL!)
            webViewInvoice.load(myRequest)
        }
    }
}
