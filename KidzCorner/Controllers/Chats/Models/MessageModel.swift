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
    let data: MessagesModelListingDataClass
    let message: String
}

// MARK: - DataClass
struct MessagesModelListingDataClass: Codable {
    let currentPage: Int
    let data: [MessagesModelListingDatum]
    let firstPageURL: String
    let from, lastPage: Int
    let lastPageURL: String
    let links: [Link]
    let nextPageURL: String?
    let path: String
    let perPage: Int
    let prevPageURL: String?
    let to, total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - Datum
struct MessagesModelListingDatum: Codable {
    var date: String
    var messages: [MessagesModelListingMessage]
}

// MARK: - Message
struct MessagesModelListingMessage: Codable {
    let media, mediaThumbnail: String?
//    let isread: Bool?
    let createdAt, updatedAt: String?
    let id, senderID, studentID, threadID: Int?
    let message: String?
    let messageType: Int?
    let student, user: Students?

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


struct SendMessageModal: Codable{
    let data: MessagesModelListingMessage?
}
// MARK: - Student
struct Students: Codable {
    var id: Int?
    let name: String?
    let email: String?
    let image: String?
    let userStatus: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, image
        case userStatus = "user_status"
        
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.userStatus = try container.decodeIfPresent(String.self, forKey: .userStatus)
        
        if let value = try? container.decodeIfPresent(Int.self, forKey: .id){
            id = value
        }else if let value = try? container.decodeIfPresent(String.self, forKey: .id){
            id = Int(value)
        }
    }
    
}

struct Link: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
