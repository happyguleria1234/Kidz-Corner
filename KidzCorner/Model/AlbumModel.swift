//
//  AlbumModel.swift
//  KidzCorner
//
//  Created by Happy Guleria on 07/07/24.
//

import Foundation

// MARK: - AlbumModel
struct AlbumModel: Codable {
    let status: Int?
    let message: String?
    let data: AlbumModelDataClass?
}

// MARK: - DataClass
struct AlbumModelDataClass: Codable {
    let currentPage: Int?
    let data: [AlbumModelDatum]?
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
struct AlbumModelDatum: Codable {
    let id: Int?
    let thumbnail: String?
    let userID, images_count: Int?
    let classID: Int?
    let name: String?
    let createdBy, isactive, postType: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, thumbnail
        case userID = "user_id"
        case classID = "class_id"
        case name, images_count
        case createdBy = "created_by"
        case isactive
        case postType = "post_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
