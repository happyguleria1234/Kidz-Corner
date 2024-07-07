//
//  ChildrenDataModel.swift
//  KidzCorner
//
//  Created by Happy Guleria on 06/07/24.
//

import Foundation
import Foundation

// MARK: - ChildrenModelData
struct ChildrenModelData: Codable {
    let status: Int?
    let message: String?
    let data: ChildrenModelDataDataClass?
}

// MARK: - DataClass
struct ChildrenModelDataDataClass: Codable {
    let currentPage: Int?
    let data: [ChildrenModelDataDatum]?
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
struct ChildrenModelDataDatum: Codable {
    let id: Int?
    let name: String?
    let email: String?
    let roleID: Int?
    let image, userStatus: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case roleID = "role_id"
        case image
        case userStatus = "user_status"
    }
}
