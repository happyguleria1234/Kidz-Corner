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
    
    case disconnect_user          = "disconnect_user"
    case chat_listing             = "user_joins"
    case connect_user             = "user_status"
    case send_message             = "send_message"
    case get_message              = "message_listing"
    case report_user              = "reportuser"
    case block_user               = "blocked_user"
    case delete_chat              = "delete_chat"
    case cont_unread_msg          = "cont_unread_msg"
    case mute_notification        = "mute_notification"
    case get_group_messages       = "get_group_messages"
    case live_location_track      = "tracking_user"
    case block_status             = "block_status"
    case user_booking_data        = "user_booking_data"
    
    var instance : String {
        return self.rawValue
    }
}

enum SocketListeners:String{
    
    case disconnect_listener      = "disconnect_listener"
    case chat_listing_listener    = "user_joins"
    case send_message_listner     = "send_message"
    case connect_listener         = "user_status"
    case my_chat                  = "message_listing"
    case report_data              = "report_data"
    case delete_data              = "delete_chat"
    case block_data               = "block_data"
    case mute_notification_data   = "mute_notification_data"
    case get_group_messages       = "get_group_messages"
    case live_location_final      = "live_location_final"
    case block_status             = "block_status"
    case block_unblock            = "blocked_user"
    case report_user              = "reportuser"
    case user_booking_data        = "user_booking_data"
    case cont_unread_msg          = "cont_unread_msg"
    
    var instance : String {
        return self.rawValue
    }
    
}




