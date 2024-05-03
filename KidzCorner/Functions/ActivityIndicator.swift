import Foundation
import UIKit

//MARK: - LOADER (ACTIVITY indicator)

let loadingView: UIView = UIView()
let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
var view1 = UIView()

func startAnimating(_ uiView : UIView){
        DispatchQueue.main.async {
        view1 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view1.center = uiView.center
        view1.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view1.clipsToBounds = true
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view1.center
        loadingView.backgroundColor = UIColor.lightGray //you can set own color here
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        if #available(iOS 13.0, *) {
            actInd.style = UIActivityIndicatorView.Style.large
        } else {
            actInd.style = UIActivityIndicatorView.Style.whiteLarge
        }
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2)
   //     actInd.color = .myDarkGreen
        loadingView.addSubview(actInd)
        view1.addSubview(loadingView)
        uiView.addSubview(view1)
        actInd.startAnimating()
    }
}

func stopAnimating(){
    DispatchQueue.main.async {
    actInd.stopAnimating()
    view1.removeFromSuperview()
    }
}

/*
 Usage :
 to start : startAnimating(yourView) //Most probably it is self.view for whole page
 to stop : stopAnimating()
 */
