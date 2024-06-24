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
        socket.on(SocketListeners.connect_listener.instance) { arrOfAny, ack in
            print("User Connected Successfully")
            NotificationCenter.default.post(name: Notification.Name("socketConnected"), object: nil, userInfo: nil)
        }
    }
    
    //MARK: - User Chats
    
    func getUsers() {
        guard let userID = UserDefaults.standard.value(forKey: myUserid) as? Int else { return }
        let param: parameter = ["page":"1",
                                "limit":"100",
                                "user_id":userID]
        let data = try! JSONSerialization.data(withJSONObject: param)
        socket.emit(SocketEmitters.chat_listing.instance, data) { [self] in
            print(socket.status)
        }        
    }
    
    func messageListingListener(onSuccess: @escaping(_ messageInfo:MessageList) -> Void) {
        socket.on(SocketListeners.chat_listing_listener.instance) { arrOfAny, ack  in
            print("messages listing get successfully")
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: arrOfAny[0], options: [])
                let newMszs = try JSONDecoder().decode(MessageList.self, from: jsonData)
                onSuccess(newMszs)
            }catch{
                print("Error \(error)")
            }
        }
    }
    
    //MARK: - User Messages Listing
    
    func userMessagesEmitter(threadID:Int) {
        let param: parameter = ["id":threadID]
        let data = try! JSONSerialization.data(withJSONObject: param)
        socket.emit(SocketEmitters.message_listing.instance, data) { [self] in
            print(socket.status)
        }
    }
    
    func userMessagesListener(onSuccess: @escaping(_ messageInfo:UserMessagesList) -> Void) {
        socket.on(SocketListeners.message_listing_listner.instance) { arrOfAny, ack  in
            print("User Messages Listing")
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: arrOfAny[0], options: [])
                let newMszs = try JSONDecoder().decode(UserMessagesList.self, from: jsonData)
                onSuccess(newMszs)
            }catch{
                print("Error \(error)")
            }
        }
    }
    
    //MARK: - Send Message
    
    func sendMessageEmitter(messageStr: String,senderId:Int,recieverID:Int,threadID:Int) {
        var param: parameter = ["sender_id":senderId,
                                "student_id":recieverID,
                                "message":messageStr,
                                "message_type":1,
                                "thread_id":threadID]
        let data = try! JSONSerialization.data(withJSONObject: param)
        socket.emit(SocketEmitters.send_message.instance, data) { [self] in
            print(socket.status)
        }
    }
   
    func sendMessageListener(onSuccess: @escaping(String) -> Void) {
        socket.on(SocketListeners.send_message_listner.instance) { arrOfAny, ack  in
            print("User Messages Listing")
            onSuccess("message")
//            do{
//                let jsonData = try JSONSerialization.data(withJSONObject: arrOfAny[0], options: [])
//                let newMszs = try JSONDecoder().decode(UserMessagesList.self, from: jsonData)
//                onSuccess(newMszs)
//            }catch{
//                print("Error \(error)")
//            }
        }
    }
    
    func joinRoomEmitter(userID:Int?) {
        guard let userID = userID else { return }
        let param: parameter = ["userId":userID]
        let data = try! JSONSerialization.data(withJSONObject: param)
        socket.emit(SocketEmitters.joinRoom.instance, data) { [self] in
            print(socket.status)
        }
    }
    
    func joinRoomListner(onSuccess: @escaping(_ messageInfo:UserMessagesList) -> Void) {
        socket.on(SocketListeners.chatroomUsers.instance) { arrOfAny, ack  in
            print("User Messages Listing")
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: arrOfAny[0], options: [])
                let newMszs = try JSONDecoder().decode(UserMessagesList.self, from: jsonData)
                onSuccess(newMszs)
            }catch{
                print("Error \(error)")
            }
        }
    }
    
}
