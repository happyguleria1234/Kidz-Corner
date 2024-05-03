//
//  AcitivitiesModel.swift
//  KidzCorner
//
//  Created by Apple on 06/11/23.
//

import Foundation

// MARK: - ActivitiesModel
struct ActivitiesModel: Codable {
    var status: Int?
    var message: String?
    var data: ActivitiesDataClass?
}

// MARK: - ActivitiesDataClass
struct ActivitiesDataClass: Codable {
    var from, perPage: Int?
    var data: [ActivityData]?
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

// MARK: - ActivityData
struct ActivityData: Codable {
    var id: Int?
    var createdAt: String?
    var createdBy: Int?
    var descriptions, parentView: String?
    var calendarID: Int?
    var title, date, isActive, startTimeMin: String?
    var endTimeMin, fullDate, updatedAt, startTimeHours: String?
    var endTimeHours: String?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case createdBy = "created_by"
        case descriptions
        case parentView = "parent_view"
        case calendarID = "calendar_id"
        case title, date
        case isActive = "is_active"
        case startTimeMin = "start_time_min"
        case endTimeMin = "end_time_min"
        case fullDate = "full_date"
        case updatedAt = "updated_at"
        case startTimeHours = "start_time_hours"
        case endTimeHours = "end_time_hours"
    }
}
