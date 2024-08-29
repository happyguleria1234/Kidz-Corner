//
//  RemarkModel.swift
//  KidzCorner
//
//  Created by Happy Guleria on 28/08/24.
//

import Foundation

// MARK: - RemarkModelData
struct RemarkModelData: Codable {
    let status: Int?
    let message: String?
    let data: [RemarkModelDataList]?
}

// MARK: - Datum
struct RemarkModelDataList: Codable {
    let id, userID, mainAnnoucementID, createdBy: Int?
    let createdByRole, isTeacher: Int?
    let title, date, time, announcementStatus: String?
    let description: String?
    let announcementType: Int?
    let type: String?
    let classID: Int?
    let attachment, file: String?
    let active: Int?
    let createdAt, updatedAt: String?
    let status: Int?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case mainAnnoucementID = "main_annoucement_id"
        case createdBy = "created_by"
        case createdByRole = "created_by_role"
        case isTeacher = "is_teacher"
        case title, date, time
        case announcementStatus = "announcement_status"
        case description
        case announcementType = "announcement_type"
        case type
        case classID = "class_id"
        case attachment, file, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status, user
    }
}

// MARK: - User
struct RemarkModelDataListUser: Codable {
    let id: Int?
    let name: String?
    let image: String?
}
