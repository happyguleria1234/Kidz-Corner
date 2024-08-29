//
//  PortFolioDataModel.swift
//  KidzCorner
//
//  Created by Happy Guleria on 29/08/24.
//

import Foundation

// MARK: - PortFolioDataModel
struct PortFolioDataModel: Codable {
    let status: Int?
    let message: String?
    let data: [PortFolioDataModelDatum]?
}

// MARK: - Datum
struct PortFolioDataModelDatum: Codable {
    let id, portfolioID: Int?
    let imageID: Int?
    let userID: Int?
    let post, createdAt, updatedAt: String?
    let user: PortFolioDataModelUser?

    enum CodingKeys: String, CodingKey {
        case id
        case portfolioID = "portfolio_id"
        case imageID = "image_id"
        case userID = "user_id"
        case post
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
    }
}

// MARK: - User
struct PortFolioDataModelUser: Codable {
    let id: Int?
    let idCardNo: Int?
    let toyyibpayUsername, toyyibpaySecret, toyyibpayCategory, facebookAccessToken: String?
    let classID: Int?
    let activeChildID: Int?
    let name: String?
    let quickbooksID: Int?
    let createdBy: Int?
    let status: String?
    let roleID: Int?
    let email: String?
    let emailVerifiedAt: String?
    let image: String?
    let document: String?
    let address, contactNumber: String?
    let gender: String?
    let islogin, isChat: Int?
    let userLoginType, adminApprove: String?
    let createdAt: String?
    let updatedAt, userStatus, chatToken: String?
    let active: Int?
    let dob: String?
    let leavePlanID: Int?
    let deviceToken: String?
    let deviceType, assignedForm, countryID: Int?
    let assignSchools: Int?
    let selectedYear: String?
    let showSchoolToHeadquarter: Int?
    let lastLogin: String?

    enum CodingKeys: String, CodingKey {
        case id
        case idCardNo = "id_card_no"
        case toyyibpayUsername = "toyyibpay_username"
        case toyyibpaySecret = "toyyibpay_secret"
        case toyyibpayCategory = "toyyibpay_category"
        case facebookAccessToken = "facebook_access_token"
        case classID = "class_id"
        case activeChildID = "active_child_id"
        case name
        case quickbooksID = "quickbooks_id"
        case createdBy = "created_by"
        case status
        case roleID = "role_id"
        case email
        case emailVerifiedAt = "email_verified_at"
        case image, document, address
        case contactNumber = "contact_number"
        case gender, islogin
        case isChat = "is_chat"
        case userLoginType = "user_login_type"
        case adminApprove = "admin_approve"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userStatus = "user_status"
        case chatToken = "chat_token"
        case active, dob
        case leavePlanID = "leave_plan_id"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case assignedForm = "assigned_form"
        case countryID = "country_id"
        case assignSchools = "assign_schools"
        case selectedYear = "selected_year"
        case showSchoolToHeadquarter = "show_school_to_headquarter"
        case lastLogin = "last_login"
    }
}
