//
//  DemoModel.swift
//  KidzCorner
//
//  Created by Happy Guleria on 21/07/24.
//

import Foundation

// MARK: - AlbumModel
struct DemoAlbumModel: Codable {
    let status: Int?
    let message: String?
    let data: [DemoDatum]?
}

// MARK: - Datum
struct DemoDatum: Codable {
    let id: Int?
    let name: String?
    let createdBy, adminID, status: Int?
    let createdAt, updatedAt: String?
    let classID: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdBy = "created_by"
        case adminID = "admin_id"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case classID = "class_id"
    }
}

