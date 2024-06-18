//
//  UserMessagesList.swift
//  KidzCorner
//
//  Created by Happy Guleria on 15/06/24.
//

import Foundation

// MARK: - UserMessagesList
struct UserMessagesList: Codable {
    let status: Int
    let data: UserMessagesListDataClass
    let message: String
}

// MARK: - DataClass
struct UserMessagesListDataClass: Codable {
    let data: [UserMessagesListDatum]
    let links: UserMessagesListLinks
}

// MARK: - Datum
struct UserMessagesListDatum: Codable {
    let id, senderID, receiverID, threadID: Int
    let message: String
    let media, mediaThumbnail: String
    let messageType: Int
    let isread: Bool
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case threadID = "thread_id"
        case message, media
        case mediaThumbnail = "media_thumbnail"
        case messageType = "message_type"
        case isread
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Links
struct UserMessagesListLinks: Codable {
    let total, totalPages, currentPage, type: Int

    enum CodingKeys: String, CodingKey {
        case total, totalPages
        case currentPage = "current_page"
        case type
    }
}
