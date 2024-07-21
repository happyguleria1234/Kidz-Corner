//
//  EvaluationSkillModel.swift
//  KidzCorner
//
//  Created by Happy Guleria on 21/07/24.
//

import Foundation

// MARK: - AlbumModel
struct EvaluatiomSkillAlbumModel: Codable {
    let status: Int?
    let message: String?
    let date: [DateElement]?
    let ratings: [Rating]?
}

// MARK: - DateElement
struct DateElement: Codable {
    let id, createdBy: Int?
    let name: String?
    let isacive: Int?
    let createdAt, updatedAt: String?
    let skills: [DateElement]?
    let domainID: Int?
    let evolution: Evolution?

    enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case name, isacive
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case skills
        case domainID = "domain_id"
        case evolution
    }
}

// MARK: - Evolution
struct Evolution: Codable {
    let id, domainID: Int?
    let publishDate: String?
    let categoryID, skillID, userID, createdBy: Int?
    let remarkType: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case domainID = "domain_id"
        case publishDate = "publish_date"
        case categoryID = "category_id"
        case skillID = "skill_id"
        case userID = "user_id"
        case createdBy = "created_by"
        case remarkType = "remark_type"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Rating
struct Rating: Codable {
    let id: Int?
    let name: String?
    let createdBy: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdBy = "created_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
