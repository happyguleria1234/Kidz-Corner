//
//  ResetPasswordModel.swift
//  KidzCorner
//
//  Created by Ajay Kumar on 10/07/23.
//

import Foundation

import Foundation

// MARK: - ResetPasswordModel
struct ResetPasswordModel: Codable {
    let status: Int?
    let message: String?
    let data: ResetPasswordData?
}

// MARK: - ResetPasswordData
struct ResetPasswordData: Codable {
    let id: Int? //, classID, activeChildID: Int?
    let name: String?
//    let quickbooksID, createdBy: Int?
//    let status: String?
//    let roleID: Int?
    let email: String?// emailVerifiedAt, image, address: String?
//    let contactNumber, gender: String?
//    let islogin: Int?
//    let dob: String?
//    let active: Int?
//    let deviceToken, deviceType, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
//        case classID = "class_id"
//        case activeChildID = "active_child_id"
        case name
//        case quickbooksID = "quickbooks_id"
//        case createdBy = "created_by"
//        case status
//        case roleID = "role_id"
        case email
//        case emailVerifiedAt = "email_verified_at"
//        case image, address
//        case contactNumber = "contact_number"
//        case gender, islogin, dob, active
//        case deviceToken = "device_token"
//        case deviceType = "device_type"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
    }
}
