//
//  SocketConstants.swift
//  Fargo
//
//  Created by apple on 23/02/21.
//  Copyright © 2021 Cqlsys MacBook Pro. All rights reserved.
//

import Foundation

enum SocketKeys : String {
    
//    case socketBaseUrl = "http://192.168.1.236:3200/" // Local
    case socketBaseUrl = "http://kidzcorner.live:3000/" //Live
    
    case userId              = "user1Id"
    case senderId            = "sender_id"
    case receiverId          = "reciever_id"
    case userid              = "userid"
    case user2Id             = "user2Id"
    case status              = "status"
    case group_id            = "group_id"
    case message_type        = "message_type"
    case message             = "messages"
    case Image               = "Image"
    case groupId             = "groupId"
    case bookingid           = "bookingid"
    case live_lat            = "latitude"
    case live_long           = "longitude"
    case ext                 = "extension"
    case user_id             = "userId"
    case user2_id            = "user2_id"
    case comments            = "comments"
    case stylist_user_id     = "stylist_user_id"
    case userIDBy            = "userby"
    case useridTO            = "userto"


    var instance : String {
        return self.rawValue
    }
}

enum SocketEmitters:String{
    
    case connect_user             = "user_status"
    case chat_listing             = "user_joins"
    case send_message             = "sendMessage"
    case message_listing          = "chat-history"
    
    var instance : String {
        return self.rawValue
    }
}

enum SocketListeners:String{
    
    case connect_listener         = "user_status"
    case chat_listing_listener    = "chat-threads"
    case message_listing_listner  = "chat-history"
    case send_message_listner     = "receiveMessage"

    
    var instance : String {
        return self.rawValue
    }
    
}




