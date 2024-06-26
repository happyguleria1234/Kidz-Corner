//
//  MessageModel.swift
//  KidzCorner
//
//  Created by Happy Guleria on 24/06/24.
//

import Foundation

// MARK: - MessagesModelListing
struct MessagesModelListing: Codable {
    let status: Int
    let data: DataClass
    let message: String
}

// MARK: - DataClass
struct DataClass: Codable {
    let currentPage: Int
    let data: [MessagesModelListingDatum]
    let firstPageURL: String
    let from: Int
    let nextPageURL, path: String?
    let perPage: Int
    let prevPageURL: String?
    let to: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to
    }
}

// MARK: - Datum
struct MessagesModelListingDatum: Codable {
    let media, mediaThumbnail: String?
//    let isread: Bool
    let createdAt, updatedAt: String
    let id, senderID, studentID, threadID: Int
    let message: String
    let messageType: Int
    var student, user: Student

    enum CodingKeys: String, CodingKey {
        case media
        case mediaThumbnail = "media_thumbnail"
//        case isread
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id
        case senderID = "sender_id"
        case studentID = "student_id"
        case threadID = "thread_id"
        case message
        case messageType = "message_type"
        case student, user
    }
}
