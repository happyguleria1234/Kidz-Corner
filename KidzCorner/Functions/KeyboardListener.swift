import Foundation
import UIKit


//MARK:- KEYBOARD STATE LISTENER

/*
 USAGE :
 in AppDelegate , didFinishLaunchingWithOptions , write this before return statement:
 KeyboardStateListener.shared.start()
 
 Then in anywhere in the project,
 to check if keyboard is visible or not : KeyboardStateListener.shared.isVisible
 to get Keyboard height : KeyboardStateListener.shared.keyboardheight

 */

class KeyboardStateListener {
    
    static let shared = KeyboardStateListener()
    
    var isVisible = false
    var keyboardheight : CGFloat = 0.0
    
    func start() {
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleShow), name: .UIResponder.keyboardDidShowNotification, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleShow), name: .UIResponder.keyboardDidHideNotification, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleShow),
//                                               name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleHide),
//                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleShow(_ notification: Notification)
    {
        isVisible = true
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        
//       if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                keyboardheight = keyboardHeight
        }
    }
    
    @objc func handleHide()
    {
        isVisible = false
        keyboardheight = 0.0
    }
    
    func stop() {
        NotificationCenter.default.removeObserver(self)
    }
}
