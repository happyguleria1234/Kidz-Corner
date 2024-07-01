//
//  MessageList.swift
//  KidzCorner
//
//  Created by Happy Guleria on 12/06/24.
//

import Foundation

// MARK: - Welcome
struct MessageList: Codable {
    let status: Int
    let data: MessageListData
    let message: String
}

// MARK: - DataClass
struct MessageListData: Codable {
    let data: [MessageListUsers]
    let links: Links
}

// MARK: - Datum
struct MessageListUsers: Codable {
    let ctID, ctSenderID: String
    let ctMessageID: Int
    let ctReceiverID, ctMessage: String
    let ctMedia, ctMediaThumbnail: String
    let ctMessageType, ctDeletedByuserid1, ctDeletedByuserid2, ctIsActive: Int
    let ctCreatedAt: String?
    let ctUpdatedAt, uID, uToyyibpayUsername, uToyyibpaySecret: String
    let uToyyibpayCategory, uFacebookAccessToken, uClassID: String
    let uActiveChildID: String?
    let uName: String
    let uQuickbooksID: String?
    let uCreatedBy, uStatus, uRoleID, uEmail: String
    let uEmailVerifiedAt: String?
    let uPassword, uImage: String
    let uDocument: String?
    let uAddress, uContactNumber: String
    let uGender: String?
    let uIslogin: Int
    let uDob: String?
    let uActive: Int
    let uLeavePlanID, uRememberToken, uDeviceToken: String?
    let uDeviceType: Int
    let uAssignedForm, uAssignSchools, uShowSchoolToHeadquarter: String?
    let uLastLogin, uUserLoginType, uAdminApprove, uCreatedAt: String
    let uUpdatedAt, uUserStatus, uChatToken, unreadMessageCount: String
    let message: String
    let media: String
    let isread, messageType: Int
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case ctID = "ct_id"
        case ctSenderID = "ct_sender_id"
        case ctMessageID = "ct_message_id"
        case ctReceiverID = "ct_receiver_id"
        case ctMessage = "ct_message"
        case ctMedia = "ct_media"
        case ctMediaThumbnail = "ct_media_thumbnail"
        case ctMessageType = "ct_message_type"
        case ctDeletedByuserid1 = "ct_deleted_byuserid_1"
        case ctDeletedByuserid2 = "ct_deleted_byuserid_2"
        case ctIsActive = "ct_is_active"
        case ctCreatedAt = "ct_created_at"
        case ctUpdatedAt = "ct_updated_at"
        case uID = "u_id"
        case uToyyibpayUsername = "u_toyyibpay_username"
        case uToyyibpaySecret = "u_toyyibpay_secret"
        case uToyyibpayCategory = "u_toyyibpay_category"
        case uFacebookAccessToken = "u_facebook_access_token"
        case uClassID = "u_class_id"
        case uActiveChildID = "u_active_child_id"
        case uName = "u_name"
        case uQuickbooksID = "u_quickbooks_id"
        case uCreatedBy = "u_created_by"
        case uStatus = "u_status"
        case uRoleID = "u_role_id"
        case uEmail = "u_email"
        case uEmailVerifiedAt = "u_email_verified_at"
        case uPassword = "u_password"
        case uImage = "u_image"
        case uDocument = "u_document"
        case uAddress = "u_address"
        case uContactNumber = "u_contact_number"
        case uGender = "u_gender"
        case uIslogin = "u_islogin"
        case uDob = "u_dob"
        case uActive = "u_active"
        case uLeavePlanID = "u_leave_plan_id"
        case uRememberToken = "u_remember_token"
        case uDeviceToken = "u_device_token"
        case uDeviceType = "u_device_type"
        case uAssignedForm = "u_assigned_form"
        case uAssignSchools = "u_assign_schools"
        case uShowSchoolToHeadquarter = "u_show_school_to_headquarter"
        case uLastLogin = "u_last_login"
        case uUserLoginType = "u_user_login_type"
        case uAdminApprove = "u_admin_approve"
        case uCreatedAt = "u_created_at"
        case uUpdatedAt = "u_updated_at"
        case uUserStatus = "u_user_status"
        case uChatToken = "u_chat_token"
        case unreadMessageCount = "unread_message_count"
        case message, media, isread
        case messageType = "message_type"
        case profileImage = "profile_image"
    }
}

// MARK: - Links
struct Links: Codable {
    let total: String
    let totalPages, currentPage: Int

    enum CodingKeys: String, CodingKey {
        case total, totalPages
        case currentPage = "current_page"
    }
}


import Foundation

struct SendMessageData: Codable {
    var createdAt: String
    var id: Int
    var isRead: Int
    var media: String?
    var mediaThumbnail: String?
    var message: String
    var messageType: Int
    var senderId: Int
    var studentId: Int
    var threadId: Int
    var updatedAt: String
    var student, user: Student
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id
        case isRead = "isread"
        case media
        case mediaThumbnail = "media_thumbnail"
        case message
        case messageType = "message_type"
        case senderId = "sender_id"
        case studentId = "student_id"
        case threadId = "thread_id"
        case updatedAt = "updated_at"
        case student, user
    }
}

struct Response: Codable {
    var data: MessagesModelListingDatum
    var message: String
    var status: Int
}

// MARK: - UploadModel
struct UploadModel: Codable {
    let status: Int
    let data: String
}
