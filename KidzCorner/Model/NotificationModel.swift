//
//  NotificationModel.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 23/07/23.
//

import Foundation

// MARK: - NotificationModel
struct NotificationModel: Codable {
    var status: Int?
    var message: String?
    var data: NotificationData?
}

// MARK: - NotificationData
struct NotificationData: Codable {
    var from, perPage: Int?
    var data: [NotificationDetail]?
    var firstPageURL: String?
    var nextPageURL: String?
    var currentPage: Int?
    var path: String?
    var prevPageURL: String?
    var to: Int?

    enum CodingKeys: String, CodingKey {
        case from
        case perPage = "per_page"
        case data
        case firstPageURL = "first_page_url"
        case nextPageURL = "next_page_url"
        case currentPage = "current_page"
        case path
        case prevPageURL = "prev_page_url"
        case to
    }
}

// MARK: - Notification
struct NotificationDetail: Codable {
    var status, id, invoiceID: Int?
    var createdAt, message: String?
    var userID: Int?
    var updatedAt: String?
    var isView: Int?

    enum CodingKeys: String, CodingKey {
        case status, id
        case invoiceID = "invoice_id"
        case createdAt = "created_at"
        case message
        case userID = "user_id"
        case updatedAt = "updated_at"
        case isView = "is_view"
    }
}


