import Foundation
import Reachability

//MARK:- THIS CLASS HAS CHECKS FOR INTERNET CONNECTIVITY AT A MOMENT AND ALSO CONTAIN CODE THAT WILL DETECT THE CHANGE IN THE INTERNET CONNECTIVITY IN A PARTICULAR VIEW CONTROLLER

public class Connectivity  {
    public let reachability = try! Reachability()
    public static let shared = Connectivity()
    public init(){}
    
//MARK:- CHECKING INTERNET CONNECTIVITY

class public var isConnectedToInternet:Bool {
   
    var internet = false
    
   
    if Connectivity.shared.reachability.connection != .unavailable {
        internet = true
    }
    else{
        internet = false
    }
        return internet
    }
  
    /*
     USAGE:
     if Connectivity.isConnectedToInternet{
     ===== connected to internet ======
     }else{
     == not connected ===
     }
     */
    
    //MARK:- DETECTING CHANGE IN INTERNET CONNECTIVITY
    
    // Call this method in viewWillAppear Always
    func addObserver(_ target : Any, selector : Selector){
        NotificationCenter.default.addObserver(target, selector: selector, name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    //======   Usage in ViewWillAppear  =====
    
    //Connectivity.shared.addObserver(self, selector: #selector(internetConnectivityChangedDetector)
    
    //And add a SelectorMethod as
    
//    @objc func internetConnectivityChangedDetector(){
//        if Connectivity.isConnectedToInternet{
//        ===== connected to internet ======
//        }else{
//        == not connected ===
//        }
//    }
    
    
//MARK:- REMOVE OBSERVER IN VIEW WILL DISAPPEAR
    
    //call this method in viewWillDisappar of view controller where we have added observer
    
    func removeObserver(){
        reachability.stopNotifier()
    }
    
    //USAGE: Connectivity.shared.removeObserver()
    
}
