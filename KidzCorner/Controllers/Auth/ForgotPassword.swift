import UIKit
import WebKit

class ForgotPassword: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
         loadWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    @IBAction func backFunc(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    func loadWebView() {
        let myURL = URL(string:"https://kidzcorner.live/login")
           let myRequest = URLRequest(url: myURL!)
           webView.load(myRequest)
    }
}
