//
//  SocketIOManager.swift
//  Socket
//
//  Created by apple on 03/09/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import SocketIO
import CoreData

typealias successResponse = (()->())
public typealias parameter =  [String:Any]

class SocketIOManager: NSObject {
    
    var onSuccess:(successResponse)?
    static let sharedInstance = SocketIOManager()
    
    let manager = SocketManager(socketURL: URL(string:SocketKeys.socketBaseUrl.instance)!, config: [.log(true),.compress,.connectParams([SocketKeys.user_id.instance:UserDefaults.standard.string(forKey: myUserid) ?? ""])])
    
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        socket = manager.defaultSocket
        defaultHandlers()
    }
    
    func establishConnection(){
        if self.socket.status != .connected{
            self.socket.connect()
        }
    }
    
    func isConnected() ->Bool{
        if self.socket.status == .connected{
            return true
        }
        else{
            return false
        }
    }
    
    func defaultHandlers() {
        socket.on(clientEvent: .statusChange) {data, ack in
            self.socket.on(clientEvent: .reconnect) {data, ack in
                print("Reconnected")
            }
            print("Status Change")
        }
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.connectUser()
        }
        
        socket.on(clientEvent: .reconnectAttempt) {data, ack in
            print("ReConnect Attempt")
        }
        
        socket.on(clientEvent: .error) {data, ack in
            print("error")
            self.establishConnection()
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            print("Disconnect")
        }
    }
    
    //MARK: close socket connection
    func closeConnection() {
        socket.disconnect()
    }
    
}

//MARK: - custom functions

extension SocketIOManager{
    
    //MARK: - Connect user
    
    func connectUser(){
        let param: parameter = ["user_id": UserDefaults.standard.string(forKey: myUserid) ?? ""]
        socket.emit(SocketEmitters.connect_user.instance, param)
    }
    
    func connect_user_listener(){
        socket.on(SocketListeners.connect_listener.instance){arrOfAny, ack in
//            self.addListner()
            print("User Connected Successfully")
            NotificationCenter.default.post(name: Notification.Name("socketConnected"), object: nil, userInfo: nil)
        }
    }
    
    func getUsers() {
        let param: parameter = ["user_id": UserDefaults.standard.string(forKey: myUserid) ?? ""]
        socket.emit(SocketEmitters.chat_listing.instance, param)
    }
    
    //MARK: - Get MessageList
    func messageListing() {
        let param: parameter = ["user_id": UserDefaults.standard.string(forKey: myUserid) ?? "","page":"1","limit":"1"]
        socket.emit(SocketEmitters.chat_listing.instance, param)
        print(param)
    }
    
    func messageListingListener(onSuccess: @escaping(_ messageInfo:[MessageList]) -> Void) {
        socket.on(SocketListeners.chat_listing_listener.instance) { arrOfAny, ack  in
            print("messages listing get successfully")
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: arrOfAny[0], options: [])
                let newMszs = try JSONDecoder().decode([MessageList].self, from: jsonData)
                onSuccess(newMszs)
            }catch{
                print("Error \(error)")
            }
            
        }
    }
    
}
