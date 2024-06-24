import Foundation

// MARK: - Welcome
struct ChatInboxModel: Codable {
    let status: Int?
    let data: ChatDataClass?
    let message: String?
}

// MARK: - DataClass
struct ChatDataClass: Codable {
    let currentPage: Int?
    let data: [ChatData]?
    let firstPageURL: String?
    let from: Int?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to: Int?

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
struct ChatData: Codable {
    let id, studentID, messageID, isActive: Int?
    let createdAt, updatedAt: String?
    let message: Message?
    let media, mediaThumbnail: String?
    let messageType, deletedByuserid1, deletedByuserid2: Int?
    let student: StudentData?

    enum CodingKeys: String, CodingKey {
        case id
        case studentID = "student_id"
        case messageID = "message_id"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case message, media
        case mediaThumbnail = "media_thumbnail"
        case messageType = "message_type"
        case deletedByuserid1 = "deleted_byuserid_1"
        case deletedByuserid2 = "deleted_byuserid_2"
        case student
    }
}

// MARK: - Message
struct Message: Codable {
    let media, mediaThumbnail: String?
    let isread: Int?
    let createdAt, updatedAt: String?
    let id, senderID, studentID, threadID: Int?
    let message: String?
    let messageType: Int?

    enum CodingKeys: String, CodingKey {
        case media
        case mediaThumbnail = "media_thumbnail"
        case isread
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id
        case senderID = "sender_id"
        case studentID = "student_id"
        case threadID = "thread_id"
        case message
        case messageType = "message_type"
    }
}

// MARK: - Student
struct StudentData: Codable {
    let id: Int?
    let name, email, image, userStatus: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, image
        case userStatus = "user_status"
    }
}

