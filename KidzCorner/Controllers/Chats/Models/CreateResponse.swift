//
//  CreateResponse.swift
//  KidzCorner
//
//  Created by Happy Guleria on 01/07/24.
//

import Foundation

// MARK: - MessageDataModel
struct MessageDataModel: Codable {
    let status: Int?
    let data: DataClass?
    let message: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let thread: Thread?
    let student: StudentNew?
}

// MARK: - Student
struct StudentNew: Codable {
    let id, name: String?
    let email: String?
    let image, userStatus: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, image
        case userStatus = "user_status"
    }
}

// MARK: - Thread
struct Thread: Codable {
    let id, studentID: String?
    let messageID: Int?
    let message, media, mediaThumbnail: JSONNull?
    let messageType, deletedByuserid1, deletedByuserid2, isActive: Int?
    let createdAt: JSONNull?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case studentID = "student_id"
        case messageID = "message_id"
        case message, media
        case mediaThumbnail = "media_thumbnail"
        case messageType = "message_type"
        case deletedByuserid1 = "deleted_byuserid_1"
        case deletedByuserid2 = "deleted_byuserid_2"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
